#!/usr/bin/env sh
set -eu

# One-time setup: symlink central AGENTS.md to CLI tools
ln -sf "$HOME/.agents/AGENTS.md" "$HOME/.codex/AGENTS.md"
ln -sf "$HOME/.agents/AGENTS.md" "$HOME/.config/opencode/AGENTS.md"

echo "AGENTS.md symlinked to ~/.codex/ and ~/.config/opencode/"
