#!/usr/bin/env bash
set -euo pipefail

if ! command -v fzf >/dev/null; then
  tmux display-message 'Worktree picker needs fzf.'
  exit 1
fi

repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || {
  tmux display-message 'Worktree picker: current directory is not in a Git repository.'
  exit 0
}

primary=$(git -C "$repo_root" worktree list --porcelain | sed -n 's/^worktree //p' | sed -n '1p')

emit_entry() {
  local path=$1 branch=$2 kind=worktree
  if [ -z "$path" ]; then
    return 0
  fi
  [ "$path" = "$primary" ] && kind=repository
  [ -n "$branch" ] || branch='detached'
  printf '%s\t%s\t%s\n' "$path" "$kind" "$branch"
}

worktree_entries() {
  local line path='' branch=''
  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
      'worktree '*)
        emit_entry "$path" "$branch"
        path=${line#worktree }
        branch=''
        ;;
      'branch refs/heads/'*) branch=${line#branch refs/heads/} ;;
      '')
        emit_entry "$path" "$branch"
        path=''
        branch=''
        ;;
    esac
  done < <(git -C "$repo_root" worktree list --porcelain)
  emit_entry "$path" "$branch"
}

selected=$(worktree_entries |
  fzf --delimiter=$'\t' --with-nth=2,3,1 --prompt='Worktree: ' \
    --header='Select repository or worktree; Enter opens it in this tmux window.') || exit 0

target=${selected%%$'\t'*}
[ -d "$target" ] || {
  tmux display-message "Worktree picker: directory no longer exists: $target"
  exit 1
}

cd "$target"
tmux rename-window "$(basename "$target")"
exec "${SHELL:-/bin/sh}" -l
