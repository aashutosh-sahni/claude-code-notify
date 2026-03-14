#!/bin/bash

# Hook script for Claude Code Notification events
# Version: 1.0.0
# Triggered when Claude needs permission or input from the user
#
# Customize the title, message, and sound below:

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

"$SCRIPT_DIR/../notify.sh" \
  "Claude Code" \
  "Claude needs your attention" \
  "Glass"
