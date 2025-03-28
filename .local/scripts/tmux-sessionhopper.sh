#!/bin/sh -
# Get session list
session_list=$(tmux ls -F "#{session_name}")

# Find the length of the longest session name for alignment
max_length=0
for session in $session_list; do
	length=${#session}
	if [ $length -gt $max_length ]; then
		max_length=$length
	fi
done

# Build the formatted list with aligned paths
sessions=""
for session in $session_list; do
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
done

# Pass the formatted list to fzf and extract the session name
session=$(echo "$sessions" | fzf --prompt="Switch: " | cut -d ' ' -f 1)
if [[ -z $session ]]; then
	exit 0
fi
tmux switch-client -t "$session"
