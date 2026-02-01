#!/bin/bash
# Smart Obsidian opening script that preserves recent local changes
# Only syncs from remote if there are no local changes to preserve

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

LOG_FILE="$HOME/obsidian-open.log"
LOCK_FILE="$HOME/.obsidian-open.lock"
STATE_FILE="$HOME/.obsidian-open-state"
LOCAL_VAULT="$HOME/.obsidian-vault-backup"

# Cleanup function to remove lock file on exit
cleanup() {
    rm -f "$LOCK_FILE"
}

# Set trap to cleanup on exit, interrupt, or termination
trap cleanup EXIT INT TERM

# Check for existing lock file
if [ -f "$LOCK_FILE" ]; then
    echo "[$(date)] Open script already running (lock file exists)" >> "$LOG_FILE"
    exit 0
fi

# Create lock file
echo $$ > "$LOCK_FILE"

# Check if we already processed this session
if [ -f "$STATE_FILE" ]; then
    LAST_SYNC_TIME=$(cat "$STATE_FILE" 2>/dev/null || echo "0")
    CURRENT_TIME=$(date +%s)
    TIME_DIFF=$((CURRENT_TIME - LAST_SYNC_TIME))
    
    # If we synced in the last 30 seconds, skip
    if [ $TIME_DIFF -lt 30 ]; then
        echo "[$(date)] Already synced recently (${TIME_DIFF}s ago), skipping" >> "$LOG_FILE"
        exit 0
    fi
fi

echo "[$(date)] Obsidian opening - checking for safe sync opportunity" >> "$LOG_FILE"

cd "$LOCAL_VAULT" || { echo "[$(date)] Failed to change to local vault directory" >> "$LOG_FILE"; exit 1; }

# Get GitHub token from gh CLI (never echo it)
GH_TOKEN=$(gh auth token 2>/dev/null)
if [ -z "$GH_TOKEN" ]; then
    echo "[$(date)] Failed to get GitHub token from gh CLI" >> "$LOG_FILE"
    exit 1
fi

# Redirect all output to log file with token redaction
exec > >(sed "s/$GH_TOKEN/**REDACTED**/g" >> "$LOG_FILE") 2>&1

# Set up remote URL
git remote set-url origin https://aerkn1:$GH_TOKEN@github.com/aerkn1/my-obsidian-vault.git

# STEP 1: Check for any local changes that need to be preserved
echo "[$(date)] Checking for local changes that need preservation..."

# Check for uncommitted changes
UNCOMMITTED_CHANGES=false
if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
    UNCOMMITTED_CHANGES=true
    echo "[$(date)] Found uncommitted changes - will preserve them"
fi

# Check for unpushed commits
UNPUSHED_COMMITS=false
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "main")

# Fetch quietly to check remote state
echo "[$(date)] Fetching remote state to check for unpushed commits..."
git fetch origin > /dev/null 2>&1

# Check if current branch has unpushed commits
if git rev-list --count @..@{u} > /dev/null 2>&1; then
    AHEAD_COUNT=$(git rev-list --count @{u}..@ 2>/dev/null || echo "0")
    if [ "$AHEAD_COUNT" -gt 0 ]; then
        UNPUSHED_COMMITS=true
        echo "[$(date)] Found $AHEAD_COUNT unpushed commits on $CURRENT_BRANCH - will preserve them"
    fi
fi

# STEP 2: Determine today's branch and target
TODAY=$(date +%Y-%m-%d)
TODAY_BRANCH="obsidian-$TODAY"
echo "[$(date)] Today's target branch: $TODAY_BRANCH"

# STEP 3: Safe sync logic
if [ "$UNCOMMITTED_CHANGES" = true ] || [ "$UNPUSHED_COMMITS" = true ]; then
    echo "[$(date)] Local changes detected - skipping remote sync to preserve work"
    echo "[$(date)] Current state preserved:"
    echo "[$(date)] - Uncommitted changes: $UNCOMMITTED_CHANGES"
    echo "[$(date)] - Unpushed commits: $UNPUSHED_COMMITS"
    echo "[$(date)] - Current branch: $CURRENT_BRANCH"
    
    # Just ensure we're on the right branch for today if possible
    if [ "$CURRENT_BRANCH" != "$TODAY_BRANCH" ]; then
        # Only switch if the target branch exists and we have no uncommitted changes
        if [ "$UNCOMMITTED_CHANGES" = false ] && git ls-remote --heads origin "$TODAY_BRANCH" | grep -q "$TODAY_BRANCH"; then
            echo "[$(date)] Switching to today's branch $TODAY_BRANCH (no uncommitted changes)"
            if git branch --list "$TODAY_BRANCH" | grep -q "$TODAY_BRANCH"; then
                git checkout "$TODAY_BRANCH"
            else
                git checkout -b "$TODAY_BRANCH" "origin/$TODAY_BRANCH"
            fi
        else
            echo "[$(date)] Staying on $CURRENT_BRANCH to preserve local changes"
        fi
    fi
    
else
    echo "[$(date)] No local changes detected - safe to sync with remote"
    
    # Check if today's daily branch exists remotely
    if git ls-remote --heads origin "$TODAY_BRANCH" | grep -q "$TODAY_BRANCH"; then
        echo "[$(date)] Today's daily branch exists remotely: $TODAY_BRANCH"
        
        # Switch to daily branch if not already there
        if [ "$CURRENT_BRANCH" != "$TODAY_BRANCH" ]; then
            echo "[$(date)] Switching to daily branch $TODAY_BRANCH"
            
            if git branch --list "$TODAY_BRANCH" | grep -q "$TODAY_BRANCH"; then
                git checkout "$TODAY_BRANCH"
            else
                git checkout -b "$TODAY_BRANCH" "origin/$TODAY_BRANCH"
            fi
        fi
        
        echo "[$(date)] Syncing with remote daily branch (prefer remote)"
        git reset --hard "origin/$TODAY_BRANCH"
        
    else
        echo "[$(date)] Today's daily branch doesn't exist remotely yet"
        
        # Switch to main if not already there
        if [ "$CURRENT_BRANCH" != "main" ]; then
            echo "[$(date)] Switching to main branch"
            git checkout main
        fi
        
        echo "[$(date)] Syncing with remote main (prefer remote)"
        git reset --hard origin/main
        
        # Create today's branch from main for future work
        if ! git branch --list "$TODAY_BRANCH" | grep -q "$TODAY_BRANCH"; then
            echo "[$(date)] Creating today's branch $TODAY_BRANCH from main"
            git checkout -b "$TODAY_BRANCH"
        else
            echo "[$(date)] Today's branch $TODAY_BRANCH already exists locally, switching to it"
            git checkout "$TODAY_BRANCH"
        fi
    fi
    
    # Clean up any untracked files only if we synced
    git clean -fd
fi

# Record sync time
echo "$(date +%s)" > "$STATE_FILE"

echo "[$(date)] Vault opening completed"
echo "[$(date)] Final state:"
echo "[$(date)] - Current branch: $(git branch --show-current)"
echo "[$(date)] - Working directory clean: $(git diff --quiet && git diff --cached --quiet && echo 'true' || echo 'false')"
echo "[$(date)] - Latest commit: $(git log --oneline -1)"

# Quick status summary
CURRENT_BRANCH=$(git branch --show-current)
if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    echo "[$(date)] ✅ Ready to work - no pending changes"
else
    echo "[$(date)] 📝 Has local changes - will be preserved until next push"
fi
