# Mac Obsidian Automation

Automated sync setup for Obsidian vault with GitHub integration.

## Overview

This setup provides automatic synchronization between your local Obsidian vault and GitHub, with smart conflict resolution.

## Components

### Scripts

1. **`obsidian-background-sync.sh`** - Pull updates from GitHub
   - Runs every 1 minute when Obsidian is CLOSED
   - Keeps vault up-to-date for when you open Obsidian
   - Simple `git reset --hard origin/main`

2. **`obsidian-backup.sh`** - Push changes to GitHub
   - Runs every 1 hour when Obsidian is CLOSED
   - Smart conflict resolution (rebase with fallback to local changes)
   - Uses commit message templates from `commit-messages.json`

### Launch Agents

1. **`com.user.obsidian-background-sync.plist`** - Pulls every 1 minute
2. **`com.user.obsidian-close.plist`** - Pushes every 1 hour

## Installation

```bash
# Copy launch agents
cp ~/.obsidian-vault-backup/91-Automation/mac/*.plist ~/Library/LaunchAgents/

# Load launch agents
launchctl load ~/Library/LaunchAgents/com.user.obsidian-background-sync.plist
launchctl load ~/Library/LaunchAgents/com.user.obsidian-close.plist
```

## How It Works

1. **When Obsidian is closed**: Background sync pulls updates every minute
2. **When you open Obsidian**: Vault is already up-to-date
3. **After working**: Changes are pushed every hour
4. **Conflicts**: Rare due to timing, auto-resolved by keeping local changes

## Multi-Device Workflow

1. **Mac 1**: Make changes → Close app → Changes pushed within 1 hour
2. **Mac 2**: Background sync pulls changes within 1 minute → Open app with latest content
3. **iPhone**: Uses separate shortcuts for sync

## Logs

### Log Files Location
- **Pull logs**: `~/obsidian-sync.log` - Background sync activity
- **Push logs**: `~/obsidian-backup.log` - Backup/push activity

### Viewing Logs
```bash
# Watch pull activity in real-time
tail -f ~/obsidian-sync.log

# Watch push activity in real-time
tail -f ~/obsidian-backup.log

# View recent pull activity
tail -20 ~/obsidian-sync.log

# View recent push activity
tail -20 ~/obsidian-backup.log
```

## Launch Agent Management

### Check Status
```bash
# List running obsidian agents
launchctl list | grep obsidian

# Check if agents are loaded
ls ~/Library/LaunchAgents/com.user.obsidian*.plist
```

### Start/Stop Agents
```bash
# Load agents (start automation)
launchctl load ~/Library/LaunchAgents/com.user.obsidian-background-sync.plist
launchctl load ~/Library/LaunchAgents/com.user.obsidian-close.plist

# Unload agents (stop automation)
launchctl unload ~/Library/LaunchAgents/com.user.obsidian-background-sync.plist
launchctl unload ~/Library/LaunchAgents/com.user.obsidian-close.plist

# Restart agents (reload configuration)
launchctl unload ~/Library/LaunchAgents/com.user.obsidian*.plist
launchctl load ~/Library/LaunchAgents/com.user.obsidian*.plist
```

### Manual Testing
```bash
# Test background sync manually
/Users/ardaerkan/.obsidian-vault-backup/91-Automation/mac/obsidian-background-sync.sh

# Test backup script manually
/Users/ardaerkan/.obsidian-vault-backup/91-Automation/mac/obsidian-backup.sh
```

## Troubleshooting

### Common Issues

1. **Agents not running**
   ```bash
   # Check if agents are loaded
   launchctl list | grep obsidian
   # If empty, reload agents
   launchctl load ~/Library/LaunchAgents/com.user.obsidian*.plist
   ```

2. **GitHub authentication issues**
   ```bash
   # Check GitHub CLI authentication
   gh auth status
   # If invalid, re-authenticate
   gh auth login
   ```

3. **Script permission issues**
   ```bash
   # Make scripts executable
   chmod +x ~/.obsidian-vault-backup/91-Automation/mac/obsidian-*.sh
   ```

4. **Check git status**
   ```bash
   cd ~/.obsidian-vault-backup
   git status
   git log --oneline -5
   ```

### Force Sync Commands
```bash
# Force pull latest changes (when Obsidian is closed)
cd ~/.obsidian-vault-backup && git fetch origin && git reset --hard origin/main

# Force push changes (when you have local changes)
cd ~/.obsidian-vault-backup && git add . && git commit -m "Manual push" && git push
```

## Configuration

### Timing Adjustments
To change sync frequency, edit the launch agent files:
- **Background sync frequency**: Edit `StartInterval` in `com.user.obsidian-background-sync.plist` (currently 60 seconds)
- **Push frequency**: Edit `StartInterval` in `com.user.obsidian-close.plist` (currently 3600 seconds)

After changes:
```bash
# Copy updated plist files
cp ~/.obsidian-vault-backup/91-Automation/mac/*.plist ~/Library/LaunchAgents/
# Restart agents
launchctl unload ~/Library/LaunchAgents/com.user.obsidian*.plist
launchctl load ~/Library/LaunchAgents/com.user.obsidian*.plist
```

## Authentication

Uses GitHub CLI token for authentication (no keychain prompts).

### Verify Authentication
```bash
# Check if GitHub CLI is authenticated
gh auth status

# Test GitHub access
gh repo list --limit 1
```

## Status Check Commands

```bash
# Quick status check
echo "=== Launch Agents ==="
launchctl list | grep obsidian
echo "=== Git Status ==="
cd ~/.obsidian-vault-backup && git status --porcelain
echo "=== Recent Pull Activity ==="
tail -3 ~/obsidian-sync.log 2>/dev/null || echo "No pull logs yet"
echo "=== Recent Push Activity ==="
tail -3 ~/obsidian-backup.log 2>/dev/null || echo "No push logs yet"
```
