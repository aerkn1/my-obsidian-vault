#!/bin/bash
# Script to detect when Obsidian opens and sync from GitHub

LOG_FILE="$HOME/obsidian-backup.log"
STATE_FILE="$HOME/.obsidian-open-state"
LOCAL_VAULT="$HOME/.obsidian-vault-backup"

# Check if Obsidian is running
if ! pgrep -f "Obsidian" > /dev/null 2>&1; then
    # Obsidian is not running, clean up state
    rm -f "$STATE_FILE"
    exit 0
fi

# Check if we already synced for this session
if [ -f "$STATE_FILE" ]; then
    # Already synced this session, exit
    exit 0
fi

# Mark that we're syncing for this session
echo "$(date +%s)" > "$STATE_FILE"

echo "[$(date)] Obsidian opened - quick sync from GitHub" >> "$LOG_FILE"

cd "$LOCAL_VAULT" || { echo "[$(date)] Failed to change to local vault directory" >> "$LOG_FILE"; exit 1; }

# Get GitHub token from gh CLI
GH_TOKEN=$(gh auth token 2>/dev/null)
if [ -z "$GH_TOKEN" ]; then
    echo "[$(date)] Failed to get GitHub token from gh CLI" >> "$LOG_FILE"
    exit 1
fi

# Quick check for remote changes (fast operation)
git remote set-url origin https://Ardae1:$GH_TOKEN@github.com/Ardae1/my-obsidian-vault.git > /dev/null 2>&1
git fetch origin > /dev/null 2>&1

# Check if local is behind remote (very fast)
LOCAL=$(git rev-parse @ 2>/dev/null)
REMOTE=$(git rev-parse @{u} 2>/dev/null)

if [ "$LOCAL" != "$REMOTE" ] && [ -n "$REMOTE" ]; then
    echo "[$(date)] Pulling latest changes from GitHub" >> "$LOG_FILE"
    git reset --hard origin/main >> "$LOG_FILE" 2>&1
    echo "[$(date)] Successfully synced vault from GitHub" >> "$LOG_FILE"
else
    echo "[$(date)] Vault already up-to-date" >> "$LOG_FILE"
fi
