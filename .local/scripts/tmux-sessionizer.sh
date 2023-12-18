#!/bin/sh -
defaultFolders=~/
if [[ ! -f ~/.project-paths.sh ]]; then
	echo "No .project-paths.sh file found. Please create one in your home directory and set the variable 'Folders' to a list of paths"
	exit 1
fi
source ~/.project-paths.sh
if [[ $# -eq 1 ]]; then
	selected=$1
else
	selected=$(find "$Folders" "$defaultFolders" -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
	exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
	tmux new-session -s $selected_name -c $selected
	exit 0
fi

if ! tmux has-session -t=$selected_name 2>/dev/null; then
	tmux new-session -ds $selected_name -c $selected
fi

tmux switch-client -t $selected_name
