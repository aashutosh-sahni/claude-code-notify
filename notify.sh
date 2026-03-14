#!/bin/bash

# Claude Code Notification Script
# Version: 1.0.0
# https://github.com/aashutosh-sahni/claude-code-notify
#
# Sends native macOS notifications with click-to-focus support
# Supports: Terminal.app, iTerm2, Ghostty, tmux
#
# Usage: ./notify.sh [title] [message] [sound]
#   title:   Notification title (default: "Claude Code")
#   message: Notification message (default: "Claude needs your attention")
#   sound:   Sound name (default: "Glass"). Options: Glass, Hero, Ping, Pop, etc.

TITLE="${1:-Claude Code}"
MESSAGE="${2:-Claude needs your attention}"
SOUND="${3:-Glass}"

# Detect which terminal we're running in
TERMINAL_APP="${TERM_PROGRAM:-Apple_Terminal}"

# Determine the TTY for focusing the correct tab
if [ -n "$TMUX" ]; then
  # Inside tmux - get the real client TTY from tmux
  MY_TTY=$(tmux display-message -p '#{client_tty}')
else
  # Get the tty by walking up the process tree
  MY_TTY="/dev/$(ps -o tty= -p $PPID | tr -d ' ')"
  if [ "$MY_TTY" = "/dev/??" ]; then
    GRANDPARENT=$(ps -o ppid= -p $PPID | tr -d ' ')
    MY_TTY="/dev/$(ps -o tty= -p $GRANDPARENT | tr -d ' ')"
  fi
  if [ "$MY_TTY" = "/dev/??" ]; then
    GREATGRAND=$(ps -o ppid= -p $GRANDPARENT | tr -d ' ')
    MY_TTY="/dev/$(ps -o tty= -p $GREATGRAND | tr -d ' ')"
  fi
fi

# Handle Ghostty - uses native OSC 777 notifications
if [ "$TERMINAL_APP" = "ghostty" ]; then
  # Ghostty handles click-to-focus automatically via OSC 777
  # No external dependencies needed!
  printf '\033]777;notify;%s;%s\007' "$TITLE" "$MESSAGE" > "$MY_TTY"
  exit 0
fi

# Handle iTerm2 - uses native OSC 9 notifications
if [ "$TERMINAL_APP" = "iTerm.app" ]; then
  # iTerm2 handles click-to-focus automatically via OSC 9
  # No external dependencies needed!
  printf '\033]9;%s\007' "$MESSAGE" > "$MY_TTY"
  exit 0
fi

# For other terminals, create a click-to-focus script
FOCUS_SCRIPT="/tmp/claude-focus-tab-$$.sh"
echo '#!/bin/bash' > "$FOCUS_SCRIPT"

if [ "$TERMINAL_APP" = "Apple_Terminal" ]; then
  # Terminal.app supports tab matching by TTY
  cat >> "$FOCUS_SCRIPT" << EOF
osascript -e 'tell application "Terminal"' \\
  -e 'activate' \\
  -e 'repeat with w in windows' \\
  -e 'repeat with t in tabs of w' \\
  -e 'if tty of t is "$MY_TTY" then' \\
  -e 'set selected tab of w to t' \\
  -e 'set index of w to 1' \\
  -e 'end if' \\
  -e 'end repeat' \\
  -e 'end repeat' \\
  -e 'end tell'
EOF
else
  # Fallback for other terminals
  echo "osascript -e 'tell application \"$TERMINAL_APP\" to activate'" >> "$FOCUS_SCRIPT"
fi

chmod +x "$FOCUS_SCRIPT"

# Send notification
# Try terminal-notifier first (supports click actions), fall back to osascript
if command -v terminal-notifier &> /dev/null; then
  terminal-notifier \
    -title "$TITLE" \
    -message "$MESSAGE" \
    -sound "$SOUND" \
    -execute "$FOCUS_SCRIPT" 2>/dev/null
elif [ -f /usr/local/homebrew/bin/terminal-notifier ]; then
  /usr/local/homebrew/bin/terminal-notifier \
    -title "$TITLE" \
    -message "$MESSAGE" \
    -sound "$SOUND" \
    -execute "$FOCUS_SCRIPT" 2>/dev/null
else
  # Fallback: use osascript (no click-to-focus support)
  osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\" sound name \"$SOUND\"" 2>/dev/null || true
fi
