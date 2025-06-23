#!/bin/bash
# Local script for Obsidian backup automation
# This avoids iCloud extended attribute issues with Launch Agents

LOG_FILE="$HOME/obsidian-backup.log"
STATE_FILE="$HOME/.obsidian-last-backup"
ICLOUD_VAULT="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/my-obsidian-vault"
LOCAL_VAULT="$HOME/.obsidian-vault-backup"

# Check if Obsidian is running
if pgrep -f "Obsidian" > /dev/null 2>&1; then
    # Obsidian is still running, clean up state file
    rm -f "$STATE_FILE"
    exit 0
fi

# Use timestamp to prevent duplicate commits
CURRENT_TIME=$(date +%s)
LAST_BACKUP_TIME=0

# Read last backup time if state file exists
if [ -f "$STATE_FILE" ]; then
    LAST_BACKUP_TIME=$(cat "$STATE_FILE")
fi

# Only backup if at least 30 seconds have passed since last backup
TIME_DIFF=$((CURRENT_TIME - LAST_BACKUP_TIME))
if [ $TIME_DIFF -lt 30 ]; then
    # Too soon since last backup
    exit 0
fi

# Record current time to prevent duplicate backups
echo "$CURRENT_TIME" > "$STATE_FILE"

echo "[$(date)] Obsidian closed - starting backup to GitHub" >> "$LOG_FILE"

# Local vault is already the primary vault - no need to sync from iCloud
echo "[$(date)] Using local vault as primary vault" >> "$LOG_FILE"

cd "$LOCAL_VAULT" || { echo "[$(date)] Failed to change to local vault directory" >> "$LOG_FILE"; rm -f "$STATE_FILE"; exit 1; }

# Get GitHub token from gh CLI
GH_TOKEN=$(gh auth token 2>/dev/null)
if [ -z "$GH_TOKEN" ]; then
    echo "[$(date)] Failed to get GitHub token from gh CLI" >> "$LOG_FILE"
    rm -f "$STATE_FILE"
    exit 1
fi

# Initialize git repo if it doesn't exist
if [ ! -d ".git" ]; then
    echo "[$(date)] Initializing git repository" >> "$LOG_FILE"
    git init >> "$LOG_FILE" 2>&1
    git remote add origin https://Ardae1:$GH_TOKEN@github.com/Ardae1/my-obsidian-vault.git >> "$LOG_FILE" 2>&1
    git fetch origin >> "$LOG_FILE" 2>&1
    git reset --hard origin/main >> "$LOG_FILE" 2>&1
else
    # Update remote URL to use token
    git remote set-url origin https://Ardae1:$GH_TOKEN@github.com/Ardae1/my-obsidian-vault.git >> "$LOG_FILE" 2>&1
fi

# Check if there are any changes to commit
if git diff --quiet && git diff --cached --quiet; then
    echo "[$(date)] No changes to backup" >> "$LOG_FILE"
    exit 0
fi

# Simple check for remote changes
echo "[$(date)] Checking for remote changes" >> "$LOG_FILE"
git fetch origin >> "$LOG_FILE" 2>&1

if ! git diff --quiet HEAD origin/main; then
    echo "[$(date)] Remote changes detected - rebasing local changes" >> "$LOG_FILE"
    
    # Simple rebase with automatic conflict resolution (keep ours)
    if git rebase origin/main >> "$LOG_FILE" 2>&1; then
        echo "[$(date)] Rebase successful" >> "$LOG_FILE"
    else
        echo "[$(date)] Conflicts during rebase - keeping local changes" >> "$LOG_FILE"
        git rebase --abort >> "$LOG_FILE" 2>&1
        git reset --hard HEAD >> "$LOG_FILE" 2>&1
        echo "[$(date)] Conflicts resolved by keeping local version" >> "$LOG_FILE"
    fi
fi

# Load commit message template from JSON
if [ -f "$LOCAL_VAULT/91-Automation/commit-messages.json" ]; then
    TEMPLATE=$(jq -r '.mac' "$LOCAL_VAULT/91-Automation/commit-messages.json" 2>/dev/null)
    if [ "$TEMPLATE" = "null" ] || [ -z "$TEMPLATE" ]; then
        TEMPLATE="Auto-commit from Mac on close - {{datetime}}"
    fi
else
    TEMPLATE="Auto-commit from Mac on close - {{datetime}}"
fi

# Insert current date/time into template
NOW=$(date "+%Y-%m-%d %H:%M")
MESSAGE="${TEMPLATE//\{\{datetime\}\}/$NOW}"

echo "[$(date)] Backing up changes with message: $MESSAGE" >> "$LOG_FILE"

# Git commit and push
echo "[$(date)] Current directory: $(pwd)" >> "$LOG_FILE"
echo "[$(date)] Git status:" >> "$LOG_FILE"
git status >> "$LOG_FILE" 2>&1

if git add . 2>> "$LOG_FILE"; then
    echo "[$(date)] Git add successful" >> "$LOG_FILE"
    if git commit -m "$MESSAGE" 2>> "$LOG_FILE"; then
        echo "[$(date)] Git commit successful" >> "$LOG_FILE"
        if git push 2>> "$LOG_FILE"; then
            echo "[$(date)] Successfully backed up changes to GitHub" >> "$LOG_FILE"
        else
            echo "[$(date)] Failed to push to GitHub" >> "$LOG_FILE"
            rm -f "$STATE_FILE"  # Remove state on failure so it can retry
        fi
    else
        echo "[$(date)] Failed to commit changes" >> "$LOG_FILE"
        rm -f "$STATE_FILE"  # Remove state on failure so it can retry
    fi
else
    echo "[$(date)] Failed to add changes" >> "$LOG_FILE"
    rm -f "$STATE_FILE"  # Remove state on failure so it can retry
fi
