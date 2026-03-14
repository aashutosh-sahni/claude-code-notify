# Claude Code Notify

[![macOS](https://img.shields.io/badge/macOS-000000?logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Hooks-blueviolet)](https://claude.ai/code)
[![Terminal](https://img.shields.io/badge/Terminal-Ghostty%20%7C%20iTerm2%20%7C%20Terminal.app-green)](https://ghostty.org/)
[![Version](https://img.shields.io/badge/version-1.0.0-blue)](https://github.com/aashutosh-sahni/claude-code-notify/releases)

Native macOS notifications for [Claude Code](https://claude.ai/code) with click-to-focus support.

Never miss a Claude Code prompt again! Get notified when Claude needs your attention or finishes a task, and click the notification to jump directly to the right terminal tab.

## Features

- Native macOS notifications with sounds
- Click-to-focus: clicking the notification takes you to the correct terminal tab
- Multiple terminal support:
  - **Terminal.app** - Full support with tab-specific focus
  - **Terminal.app + tmux** - Full support
  - **iTerm2** - Full support with native notifications and click-to-focus
  - **Ghostty** - Full support with native notifications and click-to-focus
- Two notification types:
  - **Permission/Input** - When Claude needs your attention (Glass sound)
  - **Stop** - When Claude has finished (Hero sound)

## Requirements

- macOS
- [terminal-notifier](https://github.com/julienXX/terminal-notifier) - only required for Terminal.app (Ghostty/iTerm2 have native support)

```bash
brew install terminal-notifier
```

## Installation

### Quick Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/aashutosh-sahni/claude-code-notify/main/install.sh | bash
```

### Manual Install

1. Clone this repository:
   ```bash
   git clone https://github.com/aashutosh-sahni/claude-code-notify.git ~/.claude-code-notify
   ```

2. Make scripts executable:
   ```bash
   chmod +x ~/.claude-code-notify/notify.sh
   chmod +x ~/.claude-code-notify/hooks/*.sh
   ```

3. Add hooks to your **global** Claude Code settings (`~/.claude/settings.json`).
   This ensures notifications work across all projects:
   ```json
   {
     "hooks": {
       "Notification": [
         {
           "matcher": "permission_prompt|elicitation_dialog",
           "hooks": [
             {
               "type": "command",
               "command": "~/.claude-code-notify/hooks/notify-permission.sh"
             }
           ]
         }
       ],
       "Stop": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "~/.claude-code-notify/hooks/notify-stop.sh"
             }
           ]
         }
       ]
     }
   }
   ```

## Usage

The hooks will automatically trigger notifications at the right times. You can also use the main script directly:

```bash
# Default notification
./notify.sh

# Custom notification
./notify.sh "Title" "Message" "Sound"

# Examples
./notify.sh "Build Complete" "Your build finished successfully" "Hero"
./notify.sh "Error" "Something went wrong" "Basso"
```

### Available Sounds

macOS system sounds: `Basso`, `Blow`, `Bottle`, `Frog`, `Funk`, `Glass`, `Hero`, `Morse`, `Ping`, `Pop`, `Purr`, `Sosumi`, `Submarine`, `Tink`

## Customization

Feel free to edit the hook scripts to customize messages and sounds:

- `hooks/notify-permission.sh` - Edit title, message, or sound for permission prompts
- `hooks/notify-stop.sh` - Edit title, message, or sound for task completion

Each script has a version comment (e.g., `# Version: 1.0.0`) - check the [releases](https://github.com/aashutosh-sahni/claude-code-notify/releases) to see if updates are available.

## Known Limitations

### Without terminal-notifier
- Falls back to native `osascript` notifications
- Click-to-focus is not available in fallback mode

## How It Works

1. When a hook fires, the script detects your terminal type via `$TERM_PROGRAM`
2. It finds the TTY associated with the Claude session (with tmux support)
3. Sends notification based on terminal:
   - **Ghostty**: Native OSC 777 notification - click automatically focuses the correct pane
   - **iTerm2**: Native OSC 9 notification - click automatically focuses the correct session
   - **Terminal.app**: Uses terminal-notifier with AppleScript to focus the correct tab via TTY matching

## Contributing

Contributions are welcome!

## License

MIT License - see [LICENSE](LICENSE)
