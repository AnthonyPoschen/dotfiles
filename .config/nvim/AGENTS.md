# Neovim Agent Notes

This Neovim config is actively used on macOS and Linux. Keep changes
cross-platform and prefer existing plugin/config patterns.

For system-wide keymap work, read `../KEYMAPS.md` before changing Neovim
bindings. Terminal, tmux, shell, and window-manager layers can intercept keys
before Neovim sees them.

## Dependency Management

- `nvim-treesitter` is intentionally on the `main` branch.
- Treesitter parsers are configured in `lua/plugins/treesitter.lua`.
- Do not add `jsonc` to the Treesitter parser install list. `nvim-treesitter`
  `main` maps the `jsonc` filetype to the `json` parser.
- `tree-sitter-cli` should be provided by Mason, not Homebrew, pacman, or a
  hardcoded PATH tweak.
- Mason non-LSP tools are allowlisted and installed from `lua/plugins/lsp.lua`.
- Leave Mason and lazy.nvim/LuaRocks behavior alone unless the task explicitly
  asks to change it.

## Diagnostics And Navigation

- Diagnostics use shortened virtual text plus full details on hover/float.
  Avoid returning to unlimited virtual text because long messages run offscreen.
- Current diagnostic/list convention:
  - `<leader>x...` opens Trouble/problem list views.
  - `<leader>s...` opens Telescope search views.
  - `[d` and `]d` move between diagnostics.
  - `[q` and `]q` move between Trouble/quickfix items.
- `<leader>e` opens the current line diagnostic float.

## Keymap Conventions

- Keep Neovim mappings inside the terminal/editor layer. Do not introduce
  macOS `Command` or Linux `Super`/`Window` assumptions in Neovim mappings.
- `<leader>` is Space. Prefer mnemonic leader groups over scattered one-off
  mappings when adding new features.
- `<leader>x...` is the Trouble/problem-list namespace and `<leader>s...` is
  the Telescope/search namespace.
- `[` and `]` mappings are used for navigation between diagnostics, quickfix
  items, hunks, functions, classes, blocks, and text sections.
- Option/Alt line movement exists in two forms: macOS terminal characters
  `∆`/`˚`, and portable `<A-j>`/`<A-k>`. Preserve both unless deliberately
  changing terminal behavior.
- Harpoon uses several `<C-...>` keys. Check `lua/plugins/navigation.lua`
  before adding new control-key navigation.

## Plugin Migration Notes

- `nvim-surround` v4 no longer accepts keymaps in `setup()`. Custom surround
  keys should be mapped to the plugin `<Plug>` mappings, with default mappings
  disabled through `vim.g.nvim_surround_no_*_mappings` before the plugin loads.
- Prefer Neovim's built-in LSP APIs (`vim.lsp.config`, `vim.lsp.enable`) over
  deprecated `lspconfig[server].setup(...)` patterns.
