#!/bin/bash
# This script commits and pushes changes when Obsidian is closed
# Log file for monitoring
LOG_FILE="$HOME/obsidian-close.log"
STATE_FILE="$HOME/.obsidian-last-close"
VAULT_DIR="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/my-obsidian-vault"

# Check if Obsidian is running
if pgrep -f "Obsidian" > /dev/null 2>&1; then
    # Obsidian is still running, clean up state file
    rm -f "$STATE_FILE"
    exit 0
fi

# Use timestamp to prevent duplicate commits
CURRENT_TIME=$(date +%s)
LAST_COMMIT_TIME=0

# Read last commit time if state file exists
if [ -f "$STATE_FILE" ]; then
    LAST_COMMIT_TIME=$(cat "$STATE_FILE")
fi

# Only commit if at least 30 seconds have passed since last commit
TIME_DIFF=$((CURRENT_TIME - LAST_COMMIT_TIME))
if [ $TIME_DIFF -lt 30 ]; then
    # Too soon since last commit
    exit 0
fi

# Record current time to prevent duplicate commits
echo "$CURRENT_TIME" > "$STATE_FILE"

echo "[$(date)] Obsidian closed - starting commit process" >> "$LOG_FILE"

cd "$VAULT_DIR" || { echo "[$(date)] Failed to change to vault directory" >> "$LOG_FILE"; rm -f "$STATE_FILE"; exit 1; }

# Check if there are any changes to commit
if git diff --quiet && git diff --cached --quiet; then
    echo "[$(date)] No changes to commit" >> "$LOG_FILE"
    exit 0
fi

# Load commit message template from JSON
if [ -f "$VAULT_DIR/91-Automation/commit-messages.json" ]; then
    TEMPLATE=$(jq -r '.mac' "$VAULT_DIR/91-Automation/commit-messages.json" 2>/dev/null)
    if [ "$TEMPLATE" = "null" ] || [ -z "$TEMPLATE" ]; then
        TEMPLATE="Auto-commit from Mac on close - {{datetime}}"
    fi
else
    TEMPLATE="Auto-commit from Mac on close - {{datetime}}"
fi

# Insert current date/time into template
NOW=$(date "+%Y-%m-%d %H:%M")
MESSAGE="${TEMPLATE//\{\{datetime\}\}/$NOW}"

echo "[$(date)] Committing changes with message: $MESSAGE" >> "$LOG_FILE"

# Git commit and push
if git add . && git commit -m "$MESSAGE"; then
    if git push 2>> "$LOG_FILE"; then
        echo "[$(date)] Successfully committed and pushed changes" >> "$LOG_FILE"
    else
        echo "[$(date)] Failed to push changes" >> "$LOG_FILE"
        rm -f "$STATE_FILE"  # Remove state on failure so it can retry
    fi
else
    echo "[$(date)] Failed to commit changes" >> "$LOG_FILE"
    rm -f "$STATE_FILE"  # Remove state on failure so it can retry
fi
