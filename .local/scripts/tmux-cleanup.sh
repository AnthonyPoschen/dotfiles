#!/bin/bash

# List all tmux sessions except "home"
session_list=$(tmux ls -F "#{session_name}" | grep -v "^home$")

# Check if there are any sessions
if [ -z "$session_list" ]; then
	echo "No tmux sessions found."
	exit 0
fi

# Find the length of the longest session name for alignment
max_length=0
while IFS= read -r session; do
	length=${#session}
	if [ $length -gt $max_length ]; then
		max_length=$length
	fi
done <<<"$session_list"

# Build the formatted list with aligned paths
sessions=""
while IFS= read -r session; do
	# Get the path of window 0 (first window) for this session
	path=$(tmux list-windows -t "$session" -F "#{pane_current_path}" | head -n 1)
	if [[ -n $path ]]; then
		# Use printf to align: %-*s ensures the session name takes up max_length space
		formatted=$(printf "%-*s   %s" $max_length "$session" "$path")
		sessions="$sessions$formatted\n"
	else
		formatted=$(printf "%-*s ()" $max_length "$session")
		sessions="$sessions$formatted\n"
	fi
done <<<"$session_list"

# Use fzf to select multiple sessions
selected_sessions=$(printf "%b" "$sessions" | fzf --multi --prompt="Kill: " | cut -d ' ' -f 1)

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
