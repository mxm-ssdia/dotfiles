#!/usr/bin/env bash
# tmux-nav.sh
# FZF-based session & window navigation with rename, delete, and create
# Ctrl+r = rename
# Ctrl+S new session
# Ctrl+T new tab
# Alt+backspace deletes

while true; do
    # List all sessions and windows together
    items=$(tmux list-windows -a -F "#{session_name}:#{window_index}:#{window_name}#{?window_active,*,}")

    # FZF interface with new keybindings
    selection=$(echo "$items" | fzf --ansi \
        --prompt="Select session/window> " \
        --height=50% --reverse \
        --expect=ctrl-r,alt-backspace,ctrl-s,ctrl-t \
        --preview 'echo "Session: {1}, Window: {2}, Name: {3}"' \
        --preview-window=up:1:wrap)

    [ -z "$selection" ] && exit 0

    key=$(head -n1 <<<"$selection")
    line=$(tail -n1 <<<"$selection")

    session=$(echo "$line" | cut -d':' -f1)
    window_index=$(echo "$line" | cut -d':' -f2)
    window_name=$(echo "$line" | cut -d':' -f3)

    case "$key" in
    ctrl-r)
        # Rename
        if [ -z "$window_index" ]; then
            read -rp "New session name: " new_name
            [ -n "$new_name" ] && tmux rename-session -t "$session" "$new_name"
        else
            read -rp "New window name: " new_name
            [ -n "$new_name" ] && tmux rename-window -t "${session}:${window_index}" "$new_name"
        fi
        continue
        ;;
    alt-backspace)
        # Delete
        if [ -z "$window_index" ]; then
            tmux kill-session -t "$session"
        else
            tmux kill-window -t "${session}:${window_index}"
        fi
        continue
        ;;
    ctrl-s)
        # New session
        read -rp "New session name: " new_name
        [ -n "$new_name" ] && tmux new-session -d -s "$new_name"
        continue
        ;;
    ctrl-t)
        # New window in current session
        read -rp "New window name: " new_name
        [ -n "$new_name" ] && tmux new-window -t "$session" -n "$new_name"
        continue
        ;;
    *)
        # If Enter pressed on a line
        if [ -z "$window_index" ]; then
            # User pressed Enter on session without specifying window → select first window
            first_win=$(tmux list-windows -t "$session" -F "#{window_index}" | head -n1)
            tmux switch-client -t "$session"
            tmux select-window -t "${session}:${first_win}"
        else
            tmux switch-client -t "$session"
            tmux select-window -t "${session}:${window_index}"
        fi
        break
        ;;
    esac
done
