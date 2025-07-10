#!/bin/bash

# Regression test script for obsidian open/close cycle
set -e

LOG_FILE="test-regression.log"

echo "=== OBSIDIAN OPEN/CLOSE REGRESSION TEST ===" | tee $LOG_FILE
echo "Started at: $(date)" | tee -a $LOG_FILE

# Test Scenario 1: No local changes, new remote commits
echo "" | tee -a $LOG_FILE
echo "=== SCENARIO 1: No local changes, new remote commits ===" | tee -a $LOG_FILE

# Create a test branch and commit
git checkout -b test-scenario1-$(date +%s) | tee -a $LOG_FILE
echo "Test remote commit - $(date)" > test-remote.md
git add test-remote.md
git commit -m "Test: Remote commit for scenario 1" | tee -a $LOG_FILE
git push -u origin test-scenario1-$(date +%s) | tee -a $LOG_FILE

# Reset local to be behind remote
git reset --hard HEAD~1 | tee -a $LOG_FILE
echo "Before open script - should NOT have test-remote.md:" | tee -a $LOG_FILE
ls -la test-remote.md 2>&1 | tee -a $LOG_FILE || echo "✓ test-remote.md not present" | tee -a $LOG_FILE

# Run open script
echo "Running open script..." | tee -a $LOG_FILE
./91-Automation/mac/obsidian-open.sh | tee -a $LOG_FILE

# Check results
echo "After open script - should have test-remote.md:" | tee -a $LOG_FILE
if [ -f test-remote.md ]; then
    echo "✓ PASS: test-remote.md found - remote changes pulled" | tee -a $LOG_FILE
else
    echo "✗ FAIL: test-remote.md not found - remote changes not pulled" | tee -a $LOG_FILE
fi

echo "Scenario 1 complete" | tee -a $LOG_FILE
