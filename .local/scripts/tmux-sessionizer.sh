#!/bin/sh -
defaultFolders=(~/ ~/.local ~/.config)
if [[ ! -f ~/.project-paths.sh ]]; then
    echo "No .project-paths.sh file found. Please create one in your home directory and set the variable 'Folders' to a list of paths"
    exit 1
fi
source ~/.project-paths.sh
if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ${Folders[*]} ${defaultFolders[*]} -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

# If not in tmux and no tmux is running, start a new session with windows
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s "$selected_name" -n "nvim" -c "$selected" -d
    tmux send-keys -t "$selected_name:0" "nvim" C-m
    tmux new-window -t "$selected_name:1" -n "term" -c "$selected"
    tmux new-window -t "$selected_name:2" -n "aux" -c "$selected"
    tmux select-window -t "$selected_name:0"
    tmux attach-session -t "$selected_name"
    exit 0
fi

# If tmux is running, create the session with windows if it doesn’t exist
if ! tmux has-session -t="$selected_name" 2>/dev/null; then
    tmux new-session -s "$selected_name" -n "nvim" -c "$selected" -d
    tmux send-keys -t "$selected_name:0" "nvim" C-m
    tmux new-window -t "$selected_name:1" -n "term" -c "$selected"
    tmux new-window -t "$selected_name:2" -n "aux" -c "$selected"
    tmux select-window -t "$selected_name:0"
fi

# Switch to the session (and window 0, already selected)
tmux switch-client -t "$selected_name"
