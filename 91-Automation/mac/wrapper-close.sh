#!/bin/bash
# Wrapper script for Obsidian closing automation
# Copy this to ~/Library/Obsidian-Automation/obsidian-close-wrapper.sh on each Mac

ICLOUD_SCRIPT="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/my-obsidian-vault/91-Automation/mac/close_obsidian.sh"

# Check if iCloud script exists and is accessible
if [ -f "$ICLOUD_SCRIPT" ] && [ -x "$ICLOUD_SCRIPT" ]; then
    exec bash "$ICLOUD_SCRIPT"
else
    echo "[$(date)] Error: Cannot access iCloud script at $ICLOUD_SCRIPT" >> "$HOME/obsidian-backup.log"
    exit 1
fi
