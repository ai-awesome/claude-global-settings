#!/usr/bin/env bash
LOCKDIR="/tmp/claude-say.lock"
trap 'rmdir "$LOCKDIR" 2>/dev/null' EXIT

command -v say &>/dev/null || exit 0
mkdir "$LOCKDIR" 2>/dev/null || exit 0

say "$@"
