#!/bin/bash
# This script syncs vault from GitHub when Obsidian is launched
# Log file for monitoring
LOG_FILE="$HOME/obsidian-sync.log"
LOCK_FILE="$HOME/.obsidian-sync-lock"
VAULT_DIR="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/my-obsidian-vault"
REPO_URL="https://github.com/Ardae1/my-obsidian-vault.git"
TMP_PATH="$HOME/obsidian-temp"

# Check if Obsidian is running
if ! pgrep -f "Obsidian" > /dev/null 2>&1; then
    # Obsidian is not running, clean up lock file if it exists
    rm -f "$LOCK_FILE"
    exit 0
fi

# Check if we already synced for this Obsidian session
if [ -f "$LOCK_FILE" ]; then
    # Already synced for this session
    exit 0
fi

# Create lock file to prevent multiple syncs
touch "$LOCK_FILE"

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
    rm -f "$LOCK_FILE"  # Remove lock on failure so it can retry
fi
