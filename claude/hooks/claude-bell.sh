#!/usr/bin/env bash
# Ring the bell in this tmux pane when Claude Code stops with no background agent still running.
set -u

running="$(jq '[.background_tasks // [] | .[] | select(.status == "running" and .type != "shell")] | length' 2>/dev/null)" || exit 0
[ "${running:-1}" -eq 0 ] || exit 0
[ -n "${TMUX_PANE:-}" ] || exit 0
tty="$(tmux display-message -p -t "$TMUX_PANE" '#{pane_tty}')" && printf '\a' > "$tty"
exit 0
