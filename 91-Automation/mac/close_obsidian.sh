#!/bin/bash
# This script commits and pushes changes to the remote repo
VAULT_DIR="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obsidian/My-obsidian-vault"
cd "$VAULT_DIR" || exit 1

# Load commit message template from JSON
TEMPLATE=$(jq -r '.mac' "$VAULT_DIR/91-Automation/commit-messages.json")

# Insert current date/time into template
NOW=$(date "+%Y-%m-%d %H:%M")
MESSAGE="${TEMPLATE//\{\{datetime\}\}/$NOW}"

# Git commit and push
git add .
git commit -m "$MESSAGE"
git push
