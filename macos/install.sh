#!/bin/bash

# Claude Code Notify - macOS Installation Script
# https://github.com/aashutosh-sahni/claude-code-notify

set -e

INSTALL_DIR="$HOME/.claude-code-notify"
REPO_URL="https://github.com/aashutosh-sahni/claude-code-notify.git"

echo "Installing Claude Code Notify (macOS)..."

# Clone or update
if [ -d "$INSTALL_DIR" ]; then
  echo "Updating existing installation..."
  cd "$INSTALL_DIR" && git pull --quiet
else
  echo "Cloning repository..."
  git clone --quiet "$REPO_URL" "$INSTALL_DIR"
fi

# Make scripts executable
chmod +x "$INSTALL_DIR/macos/notify.sh"
chmod +x "$INSTALL_DIR/macos/hooks/"*.sh

echo ""
echo "Installed to $INSTALL_DIR"
echo ""
echo "Add this to your ~/.claude/settings.json:"
echo ""
cat << 'CONFIG'
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
CONFIG
echo ""
echo "For click-to-focus support, install terminal-notifier:"
echo "  brew install terminal-notifier"
echo ""
echo "Done!"
