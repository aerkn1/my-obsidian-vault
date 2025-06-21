#!/bin/bash
# This script removes the current vault and pulls the latest from GitHub
VAULT_DIR="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obsidian/My-obsidian-vault"
rm -rf "$VAULT_DIR"
git clone https://github.com/Ardae1/my-obsidian-vault.git "$VAULT_DIR"
open -a "Obsidian" "$VAULT_DIR"
