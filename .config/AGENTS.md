# Agent Notes

This directory is a cross-platform dotfiles/config workspace. Prefer small,
targeted edits that preserve the existing conventions of each tool.

For any keymap work, start with `KEYMAPS.md`. It lists the OS, terminal, tmux,
shell, and Neovim files that participate in the same key flow.

## Platform And Keybinding Conventions

- This config is used on both macOS and Linux. Do not assume macOS-only paths
  such as `/opt/homebrew/bin` exist on Linux.
- If a platform-specific path or command is needed, guard it with an existence
  or platform check.
- The macOS `Command` key and the Linux `Window`/`Super` key are reserved for
  OS-specific hotkeys and tmux/window-manager integration. Avoid reassigning
  those meanings casually inside terminal/editor config.
- tmux is part of the intended workflow. Terminal, window-manager, and editor
  keybindings should be considered together rather than optimized in isolation.

## Hyprland

- Hyprland uses Omarchy defaults first, then personal overrides from
  `~/.config/hypr/*.conf`. Edit the personal files in this repo, not the
  Omarchy defaults under `~/.local/share/omarchy/default`.
- `SUPER` is the Linux window-manager layer. It is used heavily for launching
  apps, web apps, screenshots, and terminal/tmux entry points.
- `SUPER ALT, RETURN` launches a tmux terminal. `SUPER, X` launches a terminal
  in the current cwd. Preserve that terminal/tmux relationship.
- Some terminal keys are intentionally passed through Hyprland, for example
  `SUPER, Q` for Ghostty. Check pass-through rules before reusing a `SUPER`
  chord.

## tmux

- tmux prefix is `C-a`; `C-b` is unbound as prefix and reused for last-client
  switching.
- Root tmux bindings include `C-f`, `C-g`, and `C-t` for session scripts.
  Treat these as part of the terminal workflow, not generic spare keys.
- Copy mode is vi-style. Clipboard commands are platform-specific:
  `pbcopy` on macOS and `wl-copy`/`wl-paste` on Linux.
- The config enables extended keys. Be cautious when changing terminal, tmux,
  or Neovim key handling because they interact.

## Shell

- Interactive zsh auto-attaches to tmux when not already inside tmux or Vim.
  Avoid changing startup flow without considering nested terminal/editor cases.
- `~/.zshrc` is outside this `.config` directory, but it is part of the same
  workflow. Keep shell edits cross-platform.
- Existing shell setup has macOS/Homebrew paths guarded in some places and
  unguarded in others. Do not add new unguarded `/opt/homebrew` assumptions.
- `EDITOR` is `nvim`; shell history and vi-mode bindings are intentional.

## Maintenance Preferences

- Prefer tool-managed dependencies over per-machine bootstrap assumptions when
  possible. For Neovim, Mason is preferred for editor tooling that can be
  installed by Mason.
- Keep platform package-manager requirements explicit when they really are
  needed, but do not add them as hidden runtime assumptions.
- Avoid broad cleanup of existing warnings or generated/plugin state unless the
  task is specifically about that area.
