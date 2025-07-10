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
git remote set-url origin https://Ardae1:$GH_TOKEN@github.com/Ardae1/my-obsidian-vault.git

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

# Remove today's branch assumption
# Use LATEST_BRANCH for operations throughout

# Function to find the latest daily branch
find_latest_branch() {
    local latest_branch="main"
    local latest_date=""
    
    echo "[$(date)] Searching for latest daily branch..." 1>&2
    
    # Get all remote obsidian-* branches and find the latest date
    for branch in $(git ls-remote --heads origin | grep 'obsidian-[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}' | sed 's/.*refs\/heads\///'); do
        branch_date=$(echo "$branch" | sed 's/obsidian-//')
        if [ -z "$latest_date" ] || [ "$branch_date" > "$latest_date" ]; then
            latest_date="$branch_date"
            latest_branch="$branch"
        fi
    done
    
    echo "[$(date)] Latest daily branch found: $latest_branch" 1>&2
    echo "$latest_branch"
}

# Find the latest branch (prefer remote)
echo "[$(date)] Finding latest branch to sync with..."
LATEST_BRANCH=$(find_latest_branch)
echo "[$(date)] Latest branch detected: $LATEST_BRANCH"
echo "[$(date)] Starting rebase-based sync workflow..."

# STEP 3: Apply new git-flow logic based on principles
if [ "$UNCOMMITTED_CHANGES" = true ] || [ "$UNPUSHED_COMMITS" = true ]; then
    echo "[$(date)] Local work detected - will rebase on $LATEST_BRANCH"
    echo "[$(date)] Current state:"
    echo "[$(date)] - Uncommitted changes: $UNCOMMITTED_CHANGES"
    echo "[$(date)] - Unpushed commits: $UNPUSHED_COMMITS"
    echo "[$(date)] - Current branch: $CURRENT_BRANCH"
    
    # Principle 2: Rebase local work on top of LATEST_BRANCH
    echo "[$(date)] Rebasing local work on top of $LATEST_BRANCH..."
    
    # First, stash any uncommitted changes
    stash_applied=false
    if [ "$UNCOMMITTED_CHANGES" = true ]; then
        echo "[$(date)] Stashing uncommitted changes..."
        git stash push -m "Auto-stash before rebase - $(date)"
        stash_applied=true
    fi
    
    # Ensure we have the latest remote branch locally
    if [ "$LATEST_BRANCH" != "main" ]; then
        if ! git branch --list "$LATEST_BRANCH" | grep -q "$LATEST_BRANCH"; then
            echo "[$(date)] Creating local tracking branch for $LATEST_BRANCH"
            git checkout -b "$LATEST_BRANCH" "origin/$LATEST_BRANCH"
        fi
    fi
    
    # Switch to target branch and ensure it's up to date
    if [ "$CURRENT_BRANCH" != "$LATEST_BRANCH" ]; then
        echo "[$(date)] Switching to $LATEST_BRANCH"
        git checkout "$LATEST_BRANCH"
        
        # If we have unpushed commits, we need to rebase them
        if [ "$UNPUSHED_COMMITS" = true ]; then
            echo "[$(date)] Rebasing on $LATEST_BRANCH with the remote preference"
            git rebase --strategy-option=theirs "$LATEST_BRANCH" || {
                echo "[$(date)] Rebase conflicts detected"
                exit 1
            }
        fi
    else
        # We're already on the latest branch, just sync it
        echo "[$(date)] Already on $LATEST_BRANCH - rebasing with remote"
        git rebase --strategy-option=theirs "origin/$LATEST_BRANCH" || {
            echo "[$(date)] Rebase failed on $LATEST_BRANCH"
            exit 1
        }
        echo "[$(date)] Rebase completed successfully on $LATEST_BRANCH"
    fi
    
    # Restore stashed changes if any
    if [ "$stash_applied" = true ]; then
        echo "[$(date)] Restoring stashed changes..."
        git stash pop || {
            echo "[$(date)] Stash conflicts detected - auto-resolving with local preference"
            git checkout --theirs . 2>/dev/null || true
            git add . 2>/dev/null || true
        }
    fi
    
    # Stay on current branch after rebase
    echo "[$(date)] Staying on current branch: $CURRENT_BRANCH"
    
else
    echo "[$(date)] No local work - safe to rebase to $LATEST_BRANCH"
    
    # Principle 1: Rebase to LATEST_BRANCH when no local work
    if [ "$LATEST_BRANCH" != "main" ]; then
        echo "[$(date)] Rebasing to $LATEST_BRANCH"

        # Ensure we have the latest branch locally
        if ! git branch --list "$LATEST_BRANCH" | grep -q "$LATEST_BRANCH"; then
            echo "[$(date)] Creating local tracking branch for $LATEST_BRANCH"
            git checkout -b "$LATEST_BRANCH" "origin/$LATEST_BRANCH"
        else
            git checkout "$LATEST_BRANCH"
        fi
        
        # Rebase to remote
        git rebase --strategy-option=theirs "origin/$LATEST_BRANCH" || {
            echo "[$(date)] Rebase failed on $LATEST_BRANCH"
            exit 1
        }
        echo "[$(date)] Rebase completed successfully on $LATEST_BRANCH"
        
    else
        echo "[$(date)] No daily branches exist - falling back to main"
        
        # Switch to main if not already there
        if [ "$CURRENT_BRANCH" != "main" ]; then
            echo "[$(date)] Switching to main branch"
            git checkout main
        fi
        
        echo "[$(date)] Rebasing to remote main"
        git rebase --strategy-option=theirs origin/main || {
            echo "[$(date)] Rebase failed on main"
            exit 1
        }
        echo "[$(date)] Rebase completed successfully on main"
        
        # Stay on main branch
    fi
    
    # Clean up any untracked files after rebase
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
