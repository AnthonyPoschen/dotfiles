#!/usr/bin/env bash
# # Get session list
session_list=$(tmux ls -F "#{session_name}")

# Find the length of the longest session name for alignment
max_length=0
for session in $session_list; do
	length=${#session}
	if [ "$length" -gt "$max_length" ]; then
		max_length=$length
	fi
done

# Stream formatted sessions into fzf
session=$(for session in $session_list; do
	# Get the path of window 0 (first window) for this session
	path=$(tmux list-windows -t "$session" -F "#{pane_current_path}" | head -n 1)

	if [ -n "$path" ]; then
		printf "%-*s   %s\n" "$max_length" "$session" "$path"
	else
		printf "%-*s ()\n" "$max_length" "$session"
	fi
done | fzf --prompt="Switch: " | awk '{print $1}')

# Exit if nothing selected
[ -z "$session" ] && exit 0

tmux switch-client -t "$session"
