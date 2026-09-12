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

## Portable Git config

`~/.gitconfig` is shared by Omarchy and macOS. Keep only settings that
work on both machines in that file.

- Paths must be home-relative (`~/.gitconfig-global-ignores`), never
  `/Users/ap/...` or `/home/zanven/...`.
- GitHub/gist HTTPS helpers must stay `!gh auth git-credential` so `gh`
  is resolved from PATH. Never commit an absolute mise or Homebrew `gh`
  binary path.
- Do not run `gh auth setup-git`. It rewrites those helpers to the
  current machine's binary.
- Host-only settings go in untracked `~/.gitconfig.local`.
- OS-only settings that should be versioned go in tracked
  `~/.gitconfig.linux` or `~/.gitconfig.macos` (included via `gitdir`
  `/home/` vs `/Users/`). Do not put credential helpers only in those
  files: `includeIf gitdir` does not apply outside a repo, including
  during `git clone`.
