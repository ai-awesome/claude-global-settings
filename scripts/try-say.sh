#!/usr/bin/env bash
command -v say &>/dev/null || exit 0

PIDFILE="/tmp/claude-say.pid"

if [[ -f "$PIDFILE" ]] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
  exit 0
fi

say "$@" &
echo $! > "$PIDFILE"
wait
