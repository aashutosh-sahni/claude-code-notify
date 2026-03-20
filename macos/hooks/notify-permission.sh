#!/bin/bash

# Hook script for Claude Code Notification events
# Triggered when Claude needs permission or input from the user

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

"$SCRIPT_DIR/../notify.sh" \
  "Claude Code" \
  "Claude needs your attention" \
  "Glass"
