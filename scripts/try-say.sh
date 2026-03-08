#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOCKDIR="/tmp/claude-say.lock"
TMPFILE=$(mktemp /tmp/claude-say-XXXXXX.aiff)
trap 'rm -f "$TMPFILE"; rmdir "$LOCKDIR" 2>/dev/null' EXIT

command -v say &>/dev/null || exit 0
mkdir "$LOCKDIR" 2>/dev/null || exit 0

VOL=$("$SCRIPT_DIR/solar-volume.sh" 2>/dev/null) || VOL=0.1

say -o "$TMPFILE" "$@"
afplay --volume "$VOL" "$TMPFILE"
