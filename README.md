# 📚 My Obsidian Vault

A comprehensive knowledge management system built with Obsidian, featuring automated sync workflows across multiple devices and daily branch strategies for organized collaboration.

## 🗂️ Vault Structure

- **10-DSA-Notes**: Data Structures and Algorithms notes
- **11-System-Design**: System design patterns and concepts
- **12-Backend**: Backend development resources
- **13-Frontend**: Frontend development resources
- **14-AWS**: Amazon Web Services documentation
- **15-TUM-Masters**: Technical University of Munich coursework
- **20-Mock-Interviews**: Interview preparation materials
- **30-Projects**: Project documentation and code
- **40-Flashcards**: Spaced repetition learning materials
- **80-Personal**: Personal notes and reflections
- **90-Templates**: Obsidian templates
- **91-Automation**: Sync scripts and automation tools

---

## 🔄 Daily Branch Strategy

This vault uses a **daily branch workflow** to organize work and maintain clean synchronization across devices.

### How It Works

1. **Daily Branches**: Each day gets its own branch (`obsidian-YYYY-MM-DD`)
2. **Automatic Creation**: Branches are created automatically when you start working
3. **Device Sync**: All devices can work on the same daily branch simultaneously
4. **Conflict Resolution**: Automatic conflict resolution favors local changes

### Branch Lifecycle

```
main
├── obsidian-2024-01-15  (yesterday's work)
├── obsidian-2024-01-16  (today's active branch)
└── obsidian-2024-01-17  (tomorrow, if working ahead)
```

### Benefits

- **Isolation**: Each day's work is contained in its own branch
- **Collaboration**: Multiple devices can work on the same day without conflicts
- **History**: Easy to see what was accomplished each day
- **Recovery**: Simple to revert to any previous day's state

---

## 📊 GitHub Actions Workflow Monitoring

### Viewing Workflow Logs

1. **Via GitHub Web Interface**:
   ```
   https://github.com/[username]/[repo]/actions
   ```

2. **Via GitHub CLI**:
   ```bash
   # List recent workflow runs
   gh run list --limit 10
   
   # View specific run details
   gh run view [run-id]
   
   # View logs for a specific run
   gh run view [run-id] --log
   ```

3. **Via Local Logs**:
   ```bash
   # Background sync logs
   tail -f ~/obsidian-sync.log
   
   # Real-time monitoring
   watch -n 30 'tail -10 ~/obsidian-sync.log'
   ```

### Common Workflow Status Indicators

- ✅ **Success**: All sync operations completed successfully
- ⚠️ **Warning**: Sync completed with minor issues (e.g., no changes to commit)
- ❌ **Failure**: Sync failed due to conflicts or connection issues
- 🔄 **In Progress**: Sync operation currently running

---

## ⚡ Manual Force-Sync Commands

When automatic sync fails or you need to manually synchronize:

### Basic Force Sync

```bash
# Navigate to your vault
cd ~/.obsidian-vault-backup

# Fetch latest changes and reset to remote
git fetch origin
git reset --hard origin/main
```

### Daily Branch Force Sync

```bash
# For current daily branch
TODAY=$(date +%Y-%m-%d)
BRANCH_NAME="obsidian-$TODAY"

# Fetch and reset to daily branch
git fetch origin
git reset --hard origin/$BRANCH_NAME
```

### Feature Branch Force Sync

```bash
# For specific feature branch
BRANCH_NAME="feat/your-feature-name"

# Fetch and reset to feature branch
git fetch origin
git reset --hard origin/$BRANCH_NAME
```

### Emergency Recovery

```bash
# If you're completely lost, reset to main
git fetch origin
git checkout main
git reset --hard origin/main

# Then restart daily workflow
TODAY=$(date +%Y-%m-%d)
git checkout -b obsidian-$TODAY
```

### Advanced Sync Options

```bash
# Sync with conflict resolution (keeps local changes)
git fetch origin
git rebase origin/main

# Sync and show what changed
git fetch origin
git log --oneline HEAD..origin/main
git reset --hard origin/main
```

---

## 🔧 Troubleshooting Matrix

| Problem | Symptoms | Solution | Command |
|---------|----------|----------|---------|
| **Sync Not Working** | No recent commits, changes not appearing on other devices | Check background process, restart sync | `pkill -f obsidian-background-sync; ./obsidian-background-sync.sh &` |
| **Authentication Failed** | "fatal: Authentication failed" errors | Refresh GitHub token | `gh auth refresh` |
| **Merge Conflicts** | "conflict markers in file" messages | Manual conflict resolution or force reset | `git reset --hard origin/main` |
| **Wrong Branch** | Working on yesterday's branch | Switch to today's branch | `git checkout obsidian-$(date +%Y-%m-%d)` |
| **Missing Daily Branch** | Daily branch doesn't exist remotely | Create and push new daily branch | `git checkout -b obsidian-$(date +%Y-%m-%d); git push -u origin obsidian-$(date +%Y-%m-%d)` |
| **Obsidian Won't Open** | App crashes or fails to load vault | Check vault path and permissions | `ls -la ~/.obsidian-vault-backup` |
| **Changes Lost** | Work disappeared after sync | Check reflog for recovery | `git reflog; git checkout HEAD@{n}` |
| **Slow Sync** | Sync takes very long time | Large files or network issues | Check `.gitignore` and internet connection |
| **Lock File Issues** | "Another sync in progress" | Remove stale lock file | `rm -f ~/.obsidian-sync.lock` |
| **GitHub Rate Limit** | API rate limit exceeded | Wait or use different token | `gh auth status; sleep 3600` |

### Quick Diagnostics

```bash
# Check sync status
ps aux | grep obsidian-background-sync

# Check git status
cd ~/.obsidian-vault-backup && git status

# Check recent logs  
tail -20 ~/obsidian-sync.log

# Check GitHub connectivity
gh auth status && git remote -v
```

### Log Analysis

```bash
# Find sync errors in last 24 hours
grep -i error ~/obsidian-sync.log | tail -10

# Monitor real-time sync activity
tail -f ~/obsidian-sync.log | grep -E "(pulling|pushing|conflict)"

# Check branch switching activity
grep "Switching to daily branch" ~/obsidian-sync.log | tail -5
```

---

## 🧹 Cleanup Instructions for Legacy Files

### Safe Cleanup (Recommended)

```bash
# Navigate to vault
cd ~/.obsidian-vault-backup

# Remove old daily branches (older than 30 days)
git for-each-ref --format='%(refname:short) %(committerdate)' refs/heads/obsidian-* | \
  awk '$2 < "'$(date -d '30 days ago' '+%Y-%m-%d')'"' | \
  cut -d' ' -f1 | \
  xargs -r git branch -D

# Clean up remote tracking branches
git remote prune origin

# Remove old log entries (keep last 1000 lines)
tail -1000 ~/obsidian-sync.log > ~/obsidian-sync.log.tmp && \
  mv ~/obsidian-sync.log.tmp ~/obsidian-sync.log
```

### Legacy File Removal

```bash
# Remove old backup files
find ~/.obsidian-vault-backup -name "*.backup" -mtime +30 -delete
find ~/.obsidian-vault-backup -name "*.tmp" -delete

# Clean up Obsidian cache
rm -rf ~/.obsidian-vault-backup/.obsidian/workspace*
rm -rf ~/.obsidian-vault-backup/.obsidian/cache

# Remove old sync locks
rm -f ~/.obsidian-sync.lock*
rm -f ~/.obsidian-*.lock
```

### Archive Old Branches

```bash
# Create archive of old branches before deletion
git for-each-ref --format='%(refname:short)' refs/heads/obsidian-* | \
  grep -E "obsidian-202[0-3]" | \
  while read branch; do
    git tag "archive/$branch" "$branch"
    echo "Archived $branch as archive/$branch"
  done

# Push archives to remote
git push origin --tags
```

### Disk Space Recovery

```bash
# Clean up git objects and reduce repo size
cd ~/.obsidian-vault-backup
git gc --aggressive --prune=now
git repack -ad

# Remove unreferenced objects
git reflog expire --expire=now --all
git gc --prune=now
```

### Reset to Clean State (Nuclear Option)

⚠️ **Warning**: This will remove ALL local changes!

```bash
# Backup current work first
cp -r ~/.obsidian-vault-backup ~/obsidian-backup-$(date +%Y%m%d)

# Complete reset
cd ~/.obsidian-vault-backup
git fetch origin
git reset --hard origin/main
git clean -fdx

# Restart daily workflow
TODAY=$(date +%Y-%m-%d)
git checkout -b obsidian-$TODAY
```

---

## 🚀 Getting Started

1. **First Time Setup**:
   ```bash
   # Clone the vault
   git clone https://github.com/[username]/my-obsidian-vault.git ~/.obsidian-vault-backup
   
   # Start background sync
   ./obsidian-background-sync.sh &
   ```

2. **Daily Workflow**:
   - Open Obsidian (auto-switches to daily branch)
   - Work on your notes
   - Changes sync automatically in background
   - Close Obsidian (auto-commits and pushes)

3. **Cross-Device Sync**:
   - All devices automatically use the same daily branch
   - Conflicts resolved automatically (local changes preferred)
   - Manual sync available if needed

---

## 📞 Support

- **Issues**: Check troubleshooting matrix above
- **Logs**: `~/obsidian-sync.log`
- **Manual Sync**: Use force-sync commands
- **Recovery**: Follow cleanup instructions

For detailed automation setup, see [`91-Automation/README.md`](91-Automation/README.md).
