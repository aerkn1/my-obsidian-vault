# 🔧 Automation Setup for Obsidian Vault Sync

This folder contains the scripts and shortcuts needed to keep your vault in sync across **Mac** and **iPhone**.

---

## 💻 Mac Setup

1. Ensure Git and Obsidian Git plugin are installed.
2. Use the scripts below:
   - `mac/open_obsidian.sh`: Pulls latest vault and opens Obsidian
   - `mac/close_obsidian.sh`: Commits changes on close

## 📱 iPhone Setup

1. Install Working Copy, Scriptable, and Shortcuts.
2. Use:
   - `iphone/open_obsidian.shortcut.md`: Pulls and opens vault
   - `iphone/close_obsidian.shortcut.md`: Commits changes

## 📂 Folder Structure Reference

- `commit-messages.json`: Commit templates per device
- All logic files live inside your vault and are synced via Git

---

You can extend this with automatic plugin installs, workspace setup, and visual configs.
