# Keymap Inventory

Use this as the starting point for any system-wide keymap overhaul. The goal is
to make clashes easy to find across OS, terminal, tmux, shell, and Neovim
layers.

## Layer Order

Key events generally pass through these layers:

1. OS or window manager
2. terminal emulator
3. tmux
4. shell or Neovim
5. Neovim plugin-local mappings

When changing a key, check every earlier layer first. A key captured by Hyprland,
macOS, a terminal, or tmux may never reach Neovim.

## Global Conventions

- macOS `Command` and Linux `Window`/`Super` are OS/window-manager layers.
- Avoid using `Command` or `Super` as Neovim concepts. Keep Neovim inside the
  terminal/editor layer.
- tmux is intentional, not incidental. Terminal and shell changes should assume
  tmux is part of the interactive path.
- Prefer mnemonic namespaces for Neovim leader mappings:
  - `<leader>x...`: Trouble/problem list views
  - `<leader>s...`: Telescope/search views
  - `[...` and `]...`: previous/next navigation

## OS And Window Manager

| Scope | File | Notes |
| --- | --- | --- |
| Hyprland entrypoint | `hypr/hyprland.conf` | Sources Omarchy defaults first, then personal overrides. |
| Hyprland personal bindings | `hypr/bindings.conf` | Primary Linux `SUPER` keymap layer. App launchers, terminal/tmux, screenshots, pass-through rules. |
| Hyprland input | `hypr/input.conf` | Keyboard layout, compose key, pointer/touchpad behavior. |
| Hyprland app rules | `hypr/apps.conf`, `hypr/apps/*.conf` | App-specific rules; inspect if app focus/window behavior affects key flow. |
| Omarchy defaults | `~/.local/share/omarchy/default/hypr/bindings/*.conf` | Upstream defaults, outside this repo. Read for conflicts; do not edit directly. |
| macOS mouse buttons | `linearmouse/linearmouse.json` | Mouse buttons 3/4 switch Mission Control spaces. |

Current Hyprland anchors:

- `SUPER ALT, RETURN`: launch tmux terminal.
- `SUPER, X`: launch terminal in current cwd.
- `SUPER, D`: app launcher.
- `SUPER SHIFT, ...`: app/webapp launch namespace.
- `SUPER, Q`: passed through to Ghostty.

## Terminal Emulators

| Scope | File | Notes |
| --- | --- | --- |
| Ghostty | `ghostty/config` | Linux terminal keybinds, `super+q`, font-size controls, clipboard policy. |
| Alacritty | `alacritty/alacritty.toml` | macOS `Command` keys mostly passed through with `ReceiveChar`; fullscreen on `Command-O`. |
| Kitty | `kitty/kitty.conf` | Disables `ctrl+shift+t` and `cmd+t`; `kitty_mod cmd`; remote control socket for Neovim/zenmode. |

Terminal config decides which modified keys can reach tmux or Neovim. Check
these before assuming a Neovim mapping is broken.

## tmux

| Scope | File | Notes |
| --- | --- | --- |
| Main tmux config | `tmux/tmux.conf` | Source of truth for tmux prefix, root bindings, pane/window controls, copy mode, clipboard. |
| TPM plugin manager | `tmux/plugins/tpm/*` | Vendored plugin. Avoid editing except when intentionally changing plugin manager behavior. |
| tmux-power | `tmux/plugins/tmux-power/*` | Vendored status theme. Avoid editing for keymap work. |
| tmux-yank | `tmux/plugins/tmux-yank/*` | Present but currently commented out in `tmux.conf`. |

Current tmux anchors:

- Prefix is `C-a`; `C-b` is unbound as prefix.
- Root bindings: `C-f`, `C-g`, `C-t`, `C-b`. These are high-value session
  movement and management keys; keep them prioritized over default shell or
  Neovim meanings.
- Prefix bindings: `c`, `n`, `p`, `^r`, `-`, `s`, `v`, `[`, `]`, `q`,
  `^H`, `^J`, `^K`, `^L`, `Space`, `+`, `r`.
- Copy mode is vi-style.
- Clipboard differs by platform: `pbcopy` on macOS, `wl-copy`/`wl-paste` on
  Linux.
- Extended keys are enabled with `extended-keys` and `terminal-features`.

Future keymap review: explicitly rank the key hierarchy and reserve the best
key real estate for the actions that most improve navigation speed and daily
workflow.

## Shell

| Scope | File | Notes |
| --- | --- | --- |
| zsh startup | `~/.zshrc` | Outside this repo, but part of the same keymap system. Auto-attaches tmux for interactive shells. |
| zsh profile | `~/.zprofile` | Mostly PATH/profile setup; inspect when login shell behavior affects terminal startup. |

Current zsh anchors:

- Interactive shell auto-attaches to tmux when not already in tmux or Vim.
- `bindkey -v` enables vi mode.
- Insert mode autosuggest accept: `^y` and `^Space`.
- Command mode history substring search: `k` and `j`.
- `EDITOR=nvim`.

## Neovim

| Scope | File | Notes |
| --- | --- | --- |
| Core keymaps | `nvim/lua/config/keymaps.lua` | Main user keymaps. Start here for Neovim overhaul work. |
| LSP attach maps | `nvim/lua/config/lsp.lua` | LSP buffer-local maps such as `gd`, `K`, signature help. |
| LSP helper module | `nvim/lua/config/lsp_keymaps.lua` | Helper/legacy mapping module; check before deleting or repurposing LSP keys. |
| Trouble | `nvim/lua/plugins/trouble.lua` | `<leader>x...`, `[q`, `]q`. |
| Telescope | `nvim/lua/plugins/telescope.lua` | `<leader>s...`, `<leader>/`. |
| TODOs | `nvim/lua/plugins/todos.lua` | `<leader>xt`, `<leader>xT`, `<leader>st`, `<leader>sT`, `[t`, `]t`. |
| Navigation/plugins | `nvim/lua/plugins/navigation.lua` | Surround, Leap, Harpoon, and related navigation keys. |
| Git | `nvim/lua/plugins/git.lua` | `<leader>g...`, `[h`, `]h`, hunk textobject. |
| Text/comment | `nvim/lua/plugins/text.lua` | Comment and text-section navigation keys. |
| Oil | `nvim/lua/plugins/oil.lua` | Oil local keymaps and disabled defaults. |
| Diffview | `nvim/lua/plugins/diffview.lua` | Diffview local keymaps. |
| Copilot | `nvim/lua/plugins/copilot.lua` | Insert completion and commented Copilot Chat key ideas. |
| Avante | `nvim/lua/plugins/avante.lua` | AI/chat key namespace and image paste mapping. |
| Lazy UI | `nvim/lua/config/lazy.lua` | Lazy.nvim custom UI keys. |

Current Neovim anchors:

- `<leader>` is Space. `<localleader>` is backslash.
- `<leader>x...` opens Trouble/problem list views.
- `<leader>s...` opens Telescope/search views.
- `[d`/`]d`: diagnostics.
- `[q`/`]q`: Trouble/quickfix navigation.
- `[h`/`]h`: Git hunks.
- `[[`/`]]`: text section navigation.
- Option/Alt line movement has both macOS terminal character mappings
  (`∆`/`˚`) and portable `<A-j>`/`<A-k>` mappings.
- Harpoon uses several direct `<C-...>` mappings; inspect
  `nvim/lua/plugins/navigation.lua` before adding more control-key navigation.

## Audit Commands

Useful searches before a keymap overhaul:

```sh
rg -n "bind|bindd|unbind|keybind|map |mods|Command|SUPER|Super" hypr tmux ghostty kitty alacritty linearmouse
rg -n "vim\\.keymap\\.set|nvim_set_keymap|map\\(|keys = \\{|<leader>|\\[.|\\].|<C-|<A-" nvim/lua
rg -n "bindkey|tmux|EDITOR|KEYTIMEOUT" ~/.zshrc ~/.zprofile
```

For live runtime checks:

```sh
tmux list-keys
nvim +'Telescope keymaps'
hyprctl binds
```

## Overhaul Checklist

- Start from this file and update it as mappings move.
- Check OS/window-manager captures before terminal mappings.
- Check terminal pass-through before tmux mappings.
- Check tmux root bindings before Neovim `<C-...>` mappings.
- Prefer adding or moving whole namespaces over one-off keys.
- Keep old aliases only when they are real muscle memory; otherwise remove them
  to make conflicts easier to see.
