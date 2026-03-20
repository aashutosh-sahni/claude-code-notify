# Brainstorm: Windows Notification Support

## Problem Statement

The claude-code-notify repo currently only supports macOS. We want to add Windows support so users get native Windows toast notifications when Claude Code needs attention or finishes a task.

## Decisions

### 1. Notification Engine — BurntToast

Use the **BurntToast** PowerShell module for Windows toast notifications.

- Simple API, well-documented, supports icons and sounds
- Installed via `Install-Module -Name BurntToast`
- De facto standard for PowerShell toast notifications

### 2. Click-to-Focus — Skip for v1

Not implementing click-to-focus on Windows for the initial release. Notifications will appear but clicking them won't focus the terminal. Can be added later.

### 3. Repo Structure — Platform Subdirectories (Breaking Change)

Move existing macOS files into `macos/` and add a `windows/` directory.

```
claude-code-notify/
├── macos/
│   ├── install.sh
│   ├── notify.sh
│   └── hooks/
│       ├── notify-permission.sh
│       └── notify-stop.sh
├── windows/
│   ├── install.ps1
│   ├── notify.ps1
│   ├── assets/
│   │   └── claude-logo.png  (downloaded by installer)
│   └── hooks/
│       ├── notify-permission.ps1
│       └── notify-stop.ps1
├── settings-example.json         (macOS)
├── settings-example-windows.json (Windows)
├── README.md
└── LICENSE
```

**Breaking change:** Existing macOS users will need to re-run the installer and update their `settings.json` hook paths from `~/.claude-code-notify/hooks/...` to `~/.claude-code-notify/macos/hooks/...`.

### 4. Install Script — Print Config Only

The Windows `install.ps1` will:

1. Install BurntToast module (if not already installed)
2. Download the Claude icon to `windows/assets/`
3. Clone/update the repo to `~/.claude-code-notify`
4. Print the settings.json hooks config with the user's actual path

It will NOT auto-merge into `~/.claude/settings.json` — just print the config for the user to copy. Same approach as macOS.

### 5. README — Single File with OS Sections

Single `README.md` with clear macOS and Windows sections. Users see both platforms are supported at a glance.

## Implementation Plan

1. Create `macos/` directory and move existing macOS files into it
2. Update `macos/install.sh` to reflect new paths
3. Create `windows/notify.ps1` — BurntToast notification script with icon and sound support
4. Create `windows/hooks/notify-permission.ps1` and `notify-stop.ps1`
5. Create `windows/install.ps1` — installs BurntToast, downloads icon, clones repo, prints config
6. Create `settings-example-windows.json`
7. Update `README.md` with both macOS and Windows sections
8. Update `macos/install.sh` paths (hooks now at `macos/hooks/`)
