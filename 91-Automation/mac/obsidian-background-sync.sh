#!/bin/bash
# Simple background sync - pulls updates when Obsidian is closed

LOG_FILE="$HOME/obsidian-sync.log"
LOCAL_VAULT="$HOME/.obsidian-vault-backup"

# Only sync if Obsidian is NOT running
if pgrep -f "Obsidian" > /dev/null 2>&1; then
    exit 0
fi

cd "$LOCAL_VAULT" || exit 1

# Get GitHub token
GH_TOKEN=$(gh auth token 2>/dev/null)
if [ -z "$GH_TOKEN" ]; then
    exit 1
fi

# Simple pull if there are remote changes
git remote set-url origin https://Ardae1:$GH_TOKEN@github.com/Ardae1/my-obsidian-vault.git > /dev/null 2>&1
git fetch origin > /dev/null 2>&1

# Check if we're behind remote (not ahead or diverged)
LOCAL=$(git rev-parse HEAD 2>/dev/null)
REMOTE=$(git rev-parse origin/main 2>/dev/null)
BASE=$(git merge-base HEAD origin/main 2>/dev/null)

if [ "$LOCAL" != "$REMOTE" ] && [ "$LOCAL" = "$BASE" ]; then
    # Local is behind remote - safe to pull
    echo "[$(date)] Local is behind remote - pulling updates from other devices" >> "$LOG_FILE"
    git reset --hard origin/main >> "$LOG_FILE" 2>&1
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
