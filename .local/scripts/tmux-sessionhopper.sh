#!/bin/sh -
session=$(tmux ls | cut -d ':' -f 1 | fzf)
tmux switch-client -t $session
