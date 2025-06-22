#!/bin/bash
# This script syncs vault from GitHub when Obsidian is launched
# Log file for monitoring
LOG_FILE="$HOME/obsidian-sync.log"
STATE_FILE="$HOME/.obsidian-last-sync"
VAULT_DIR="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/my-obsidian-vault"
REPO_URL="https://github.com/Ardae1/my-obsidian-vault.git"
TMP_PATH="$HOME/obsidian-temp"

# Check if Obsidian is running
if ! pgrep -f "Obsidian" > /dev/null 2>&1; then
    # Obsidian is not running, clean up state file
    rm -f "$STATE_FILE"
    exit 0
fi

# Get current Obsidian PID (use the first one)
CURRENT_PID=$(pgrep -f "Obsidian" | head -1)

# Check if we already synced for this specific Obsidian process
if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "$CURRENT_PID" ]; then
    # Already synced for this process
    exit 0
fi

# Record current PID to prevent duplicate syncs
echo "$CURRENT_PID" > "$STATE_FILE"

echo "[$(date)] Obsidian detected running - starting sync" >> "$LOG_FILE"

# Make sure temp folder is clean
rm -rf "$TMP_PATH"

# Clone the repo into temp location
if git clone "$REPO_URL" "$TMP_PATH" 2>> "$LOG_FILE"; then
    # Remove .obsidian folder from temp to avoid overriding settings
    rm -rf "$TMP_PATH/.obsidian"
    
    # Sync files from repo to vault, skipping .obsidian
    rsync -av --exclude=".obsidian" "$TMP_PATH/" "$VAULT_DIR/" >> "$LOG_FILE" 2>&1
    
    # Clean up temp folder
    rm -rf "$TMP_PATH"
    
    echo "[$(date)] Vault sync completed successfully" >> "$LOG_FILE"
else
    echo "[$(date)] Failed to clone repository" >> "$LOG_FILE"
    rm -f "$STATE_FILE"  # Remove state on failure so it can retry
fi
