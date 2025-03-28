#!/bin/bash

# List all tmux sessions except "home"
sessions=$(tmux list-sessions -F "#{session_name}" | grep -v "^home$")

# Check if there are any sessions
if [ -z "$sessions" ]; then
	echo "No tmux sessions found."
	exit 0
fi

# Use fzf to select multiple sessions
selected_sessions=$(echo "$sessions" | fzf --multi --prompt="Kill: ")

# Check if any sessions were selected
if [ -z "$selected_sessions" ]; then
	echo "No sessions selected."
	exit 0
fi

# Switch to "home" session if the current session is being killed
current_session=$(tmux display-message -p '#S')
if echo "$selected_sessions" | grep -q "^$current_session$"; then
	# Ensure "home" session exists
	if ! tmux has-session -t home 2>/dev/null; then
		tmux new-session -d -s home
	fi
	tmux switch-client -t home
fi

# Kill the selected sessions
for session in $selected_sessions; do
	tmux kill-session -t "$session"
	echo "Killed tmux session: $session"
done
