#!/bin/bash

# Hook script for Claude Code Stop events
# Version: 1.0.0
# Triggered when Claude has finished a task
#
# Customize the title, message, and sound below:

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

"$SCRIPT_DIR/../notify.sh" \
  "Claude Code" \
  "Claude has finished" \
  "Hero"
