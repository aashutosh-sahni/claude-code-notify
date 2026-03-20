# Claude Code Notify

[![macOS](https://img.shields.io/badge/macOS-000000?logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Windows](https://img.shields.io/badge/Windows-0078D4?logo=windows&logoColor=white)](https://www.microsoft.com/windows)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Hooks-blueviolet)](https://claude.ai/code)

Native desktop notifications for [Claude Code](https://claude.ai/code). Never miss a prompt again!

Get notified when Claude needs your attention or finishes a task. On macOS, click the notification to jump directly to the right terminal tab.

## Features

- Native notifications with customisable sounds on both macOS and Windows
- Two notification types:
  - **Permission/Input** - When Claude needs your attention
  - **Stop** - When Claude has finished a task
- **macOS**: Click-to-focus support (Terminal.app, Ghostty, tmux)
- **Windows**: Toast notifications via BurntToast with Claude icon

---

## macOS

### Requirements

- macOS
- [terminal-notifier](https://github.com/julienXX/terminal-notifier) (recommended for click-to-focus; Ghostty users can skip this)

```bash
brew install terminal-notifier
```

### Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/aashutosh-sahni/claude-code-notify/main/macos/install.sh | bash
```

### Manual Install

1. Clone this repository:
   ```bash
   git clone https://github.com/aashutosh-sahni/claude-code-notify.git ~/.claude-code-notify
   ```

2. Make scripts executable:
   ```bash
   chmod +x ~/.claude-code-notify/macos/notify.sh
   chmod +x ~/.claude-code-notify/macos/hooks/*.sh
   ```

3. Add hooks to your **global** Claude Code settings (`~/.claude/settings.json`):
   ```json
   {
     "hooks": {
       "Notification": [
         {
           "matcher": "permission_prompt|elicitation_dialog",
           "hooks": [
             {
               "type": "command",
               "command": "~/.claude-code-notify/macos/hooks/notify-permission.sh"
             }
           ]
         }
       ],
       "Stop": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "~/.claude-code-notify/macos/hooks/notify-stop.sh"
             }
           ]
         }
       ]
     }
   }
   ```

### How It Works (macOS)

1. When a hook fires, the script detects your terminal type via `$TERM_PROGRAM`
2. It finds the TTY associated with the Claude session (with tmux support)
3. Creates a temporary AppleScript that focuses the correct tab:
   - **Terminal.app**: Matches tabs by TTY path
   - **Ghostty**: Uses native OSC 777 notifications with built-in click-to-focus
4. Sends the notification via terminal-notifier with the script as click action

### Known Limitations (macOS)

- Without terminal-notifier, falls back to native `osascript` notifications (no click-to-focus)

---

## Windows

### Requirements

- Windows 10/11
- PowerShell 5.1+
- [BurntToast](https://github.com/Windos/BurntToast) PowerShell module (installed automatically by the installer)

### Quick Install

Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/aashutosh-sahni/claude-code-notify/main/windows/install.ps1 | iex
```

### Manual Install

1. Install the BurntToast module:
   ```powershell
   Install-Module -Name BurntToast -Scope CurrentUser -Force
   ```

2. Clone this repository:
   ```powershell
   git clone https://github.com/aashutosh-sahni/claude-code-notify.git "$env:USERPROFILE\.claude-code-notify"
   ```

3. Download the Claude icon:
   ```powershell
   New-Item -ItemType Directory -Path "$env:USERPROFILE\.claude-code-notify\windows\assets" -Force
   Invoke-WebRequest -Uri "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/claude-ai.png" -OutFile "$env:USERPROFILE\.claude-code-notify\windows\assets\claude-logo.png"
   ```

4. Add hooks to your **global** Claude Code settings (`~/.claude/settings.json`).
   Replace `C:\\Users\\YourName` with your actual user profile path:
   ```json
   {
     "hooks": {
       "Notification": [
         {
           "matcher": "permission_prompt|elicitation_dialog",
           "hooks": [
             {
               "type": "command",
               "command": "powershell -ExecutionPolicy Bypass -File \"C:\\Users\\YourName\\.claude-code-notify\\windows\\hooks\\notify-permission.ps1\""
             }
           ]
         }
       ],
       "Stop": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "powershell -ExecutionPolicy Bypass -File \"C:\\Users\\YourName\\.claude-code-notify\\windows\\hooks\\notify-stop.ps1\""
             }
           ]
         }
       ]
     }
   }
   ```

---

## Usage

The hooks trigger automatically. You can also use the notification scripts directly:

### macOS

```bash
./macos/notify.sh "Title" "Message" "Sound"

# Examples
./macos/notify.sh "Build Complete" "Your build finished successfully" "Hero"
./macos/notify.sh "Error" "Something went wrong" "Basso"
```

**Available sounds:** `Basso`, `Blow`, `Bottle`, `Frog`, `Funk`, `Glass`, `Hero`, `Morse`, `Ping`, `Pop`, `Purr`, `Sosumi`, `Submarine`, `Tink`

### Windows

```powershell
.\windows\notify.ps1 -Title "Title" -Message "Message" -Sound "Default"

# Examples
.\windows\notify.ps1 -Title "Build Complete" -Message "Your build finished successfully" -Sound "Mail"
.\windows\notify.ps1 -Title "Error" -Message "Something went wrong" -Sound "Alarm"
```

**Available sounds:** `Default`, `IM`, `Mail`, `Reminder`, `SMS`, `Alarm`, `Alarm2`-`Alarm10`, `Call`, `Call2`-`Call10`

## Customisation

Edit the hook scripts to change default messages or sounds:

- **macOS**: `~/.claude-code-notify/macos/hooks/notify-permission.sh` and `notify-stop.sh`
- **Windows**: `~/.claude-code-notify/windows/hooks/notify-permission.ps1` and `notify-stop.ps1`

## Upgrading from a Previous Version

> **Breaking change:** If you installed before Windows support was added, the macOS files have moved from the repo root into `macos/`. Re-run the installer and update your `~/.claude/settings.json` hook paths from `~/.claude-code-notify/hooks/...` to `~/.claude-code-notify/macos/hooks/...`.

## Troubleshooting

### macOS
- **No notifications?** Check that `terminal-notifier` is installed (`brew install terminal-notifier`)
- **No sound?** Verify the sound name is a valid macOS system sound
- **Click doesn't focus?** Make sure your terminal is Terminal.app or Ghostty

### Windows
- **No notifications?** Verify BurntToast is installed: `Get-Module -ListAvailable -Name BurntToast`
- **Execution policy error?** Run: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
- **No icon?** Re-run the installer or manually download the icon to `~/.claude-code-notify/windows/assets/claude-logo.png`

## Contributing

Contributions are welcome!

## License

MIT License - see [LICENSE](LICENSE)
