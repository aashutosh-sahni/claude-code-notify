#!/bin/bash

# Hook script for Claude Code Stop events
# Triggered when Claude has finished a task

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

"$SCRIPT_DIR/../notify.sh" \
  "Claude Code" \
  "Claude has finished" \
  "Hero"
