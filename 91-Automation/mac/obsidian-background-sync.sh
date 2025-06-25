#!/bin/bash
# Simple background sync - pulls updates when Obsidian is closed

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

LOG_FILE="$HOME/obsidian-sync.log"
LOCK_FILE="$HOME/.obsidian-sync.lock"
LOCAL_VAULT="$HOME/.obsidian-vault-backup"

# Cleanup function to remove lock file on exit
cleanup() {
    rm -f "$LOCK_FILE"
}

# Set trap to cleanup on exit, interrupt, or termination
trap cleanup EXIT INT TERM

# Check for existing lock file
if [ -f "$LOCK_FILE" ]; then
    exit 0
fi

# Create lock file
echo $$ > "$LOCK_FILE"

# Only sync if Obsidian is NOT running
if pgrep -f "Obsidian" > /dev/null 2>&1; then
    exit 0
fi

cd "$LOCAL_VAULT" || exit 1

# Get GitHub token from gh CLI (never echo it)
GH_TOKEN=$(gh auth token 2>/dev/null)
if [ -z "$GH_TOKEN" ]; then
    exit 1
fi

# Redirect all output to log file with token redaction
exec > >(sed "s/$GH_TOKEN/**REDACTED**/g" >> "$LOG_FILE") 2>&1

# Get today's date for branch name
TODAY=$(date +%Y-%m-%d)
BRANCH_NAME="obsidian-$TODAY"

# Set up remote URL and fetch
git remote set-url origin https://Ardae1:$GH_TOKEN@github.com/Ardae1/my-obsidian-vault.git > /dev/null 2>&1
git fetch origin > /dev/null 2>&1

# Check if we should be on the daily branch
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null)
if [ "$CURRENT_BRANCH" != "$BRANCH_NAME" ]; then
    # Check if daily branch exists remotely
    if git ls-remote --heads origin "$BRANCH_NAME" | grep -q "$BRANCH_NAME"; then
        echo "[$(date)] Switching to daily branch $BRANCH_NAME" >> "$LOG_FILE"
        if git branch --list "$BRANCH_NAME" | grep -q "$BRANCH_NAME"; then
            git checkout "$BRANCH_NAME" > /dev/null 2>&1
        else
            git checkout -b "$BRANCH_NAME" "origin/$BRANCH_NAME" > /dev/null 2>&1
        fi
    else
        echo "[$(date)] Daily branch $BRANCH_NAME doesn't exist yet, staying on current branch" >> "$LOG_FILE"
    fi
fi

# Now check for changes based on current branch
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null)
if [ "$CURRENT_BRANCH" = "$BRANCH_NAME" ]; then
    # We're on the daily branch, compare with remote daily branch
    LOCAL=$(git rev-parse HEAD 2>/dev/null)
    REMOTE=$(git rev-parse "origin/$BRANCH_NAME" 2>/dev/null)
    BASE=$(git merge-base HEAD "origin/$BRANCH_NAME" 2>/dev/null)
else
    # We're on main or another branch, compare with main
    LOCAL=$(git rev-parse HEAD 2>/dev/null)
    REMOTE=$(git rev-parse origin/main 2>/dev/null)
    BASE=$(git merge-base HEAD origin/main 2>/dev/null)
fi

if [ "$LOCAL" != "$REMOTE" ] && [ "$LOCAL" = "$BASE" ]; then
    # Local is behind remote - safe to pull
    echo "[$(date)] Local is behind remote - pulling updates from other devices" >> "$LOG_FILE"
    if [ "$CURRENT_BRANCH" = "$BRANCH_NAME" ]; then
        git reset --hard "origin/$BRANCH_NAME" >> "$LOG_FILE" 2>&1
    else
        git reset --hard origin/main >> "$LOG_FILE" 2>&1
    fi
elif [ "$LOCAL" != "$REMOTE" ] && [ "$REMOTE" = "$BASE" ]; then
    # Local is ahead of remote - do NOT pull (would lose local changes)
    echo "[$(date)] Local is ahead of remote - skipping pull (local changes not pushed yet)" >> "$LOG_FILE"
elif [ "$LOCAL" != "$REMOTE" ]; then
    # Diverged - attempt automatic rebase with conflict resolution
    echo "[$(date)] Local and remote have diverged - attempting automatic rebase" >> "$LOG_FILE"
    
    # Attempt rebase
    if git rebase origin/main >> "$LOG_FILE" 2>&1; then
        echo "[$(date)] Rebase successful - local changes applied on top of remote" >> "$LOG_FILE"
    else
        echo "[$(date)] Rebase conflicts detected - resolving automatically by keeping local changes" >> "$LOG_FILE"
        
        # Get list of conflicted files
        CONFLICTED_FILES=$(git diff --name-only --diff-filter=U 2>/dev/null)
        if [ -n "$CONFLICTED_FILES" ]; then
            echo "[$(date)] Conflicted files: $CONFLICTED_FILES" >> "$LOG_FILE"
            
            # Resolve conflicts by keeping our (local) version
            for file in $CONFLICTED_FILES; do
                git checkout --ours "$file" >> "$LOG_FILE" 2>&1
                git add "$file" >> "$LOG_FILE" 2>&1
                echo "[$(date)] Resolved conflict in $file by keeping local version" >> "$LOG_FILE"
            done
            
            # Continue rebase
            git rebase --continue >> "$LOG_FILE" 2>&1
            echo "[$(date)] Rebase completed with local changes preserved" >> "$LOG_FILE"
        else
            # If no conflicted files, abort rebase and reset
            git rebase --abort >> "$LOG_FILE" 2>&1
            echo "[$(date)] Rebase aborted - unexpected issue" >> "$LOG_FILE"
        fi
    fi
fi
