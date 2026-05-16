# Agent Notes

## Dotfiles Git Repository

This home directory is managed by a bare Git repository. The interactive shell
defines this alias in `~/.aliases`:

```sh
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

When checking dotfile status, diffs, or staged changes from non-interactive
commands, expand the alias explicitly:

```sh
git --git-dir="$HOME/.cfg/" --work-tree="$HOME" status
git --git-dir="$HOME/.cfg/" --work-tree="$HOME" diff
git --git-dir="$HOME/.cfg/" --work-tree="$HOME" diff --staged
```
