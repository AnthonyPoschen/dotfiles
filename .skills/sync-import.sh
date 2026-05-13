#!/usr/bin/env sh
set -eu

SKILLS_DIR="${SKILLS_DIR:-$HOME/.skills}"
AGENT_DIRS="$HOME/.config/opencode/skills $HOME/.codex/skills $HOME/.claude/skills $HOME/.cursor/skills"

imported=0
for agent_dir in $AGENT_DIRS; do
  [ -d "$agent_dir" ] || continue
  for d in "$agent_dir"/*; do
    [ -d "$d" ] || continue
    [ -f "$d/SKILL.md" ] || continue
    name=$(basename "$d")
    if [ -d "$SKILLS_DIR/$name" ]; then
      continue
    fi
    cp -r "$d" "$SKILLS_DIR/"
    echo "imported: $name (git add .skills/$name && commit to track)"
    imported=$((imported + 1))
  done
done

[ $imported -eq 0 ] && echo "no new external skills to import from agents"
