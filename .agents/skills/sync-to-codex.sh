#!/usr/bin/env sh
set -eu

SKILLS_DIR="${SKILLS_DIR:-$HOME/.agents/skills}"
OPENCODE_SKILLS_DIR="${OPENCODE_SKILLS_DIR:-$HOME/.config/opencode/skills}"
CODEX_SKILLS_DIR="${CODEX_SKILLS_DIR:-$HOME/.codex/skills}"

mkdir -p "$OPENCODE_SKILLS_DIR" "$CODEX_SKILLS_DIR"

changed=0
skipped=0

for skill_dir in "$SKILLS_DIR"/*; do
    [ -d "$skill_dir" ] || continue
    [ -f "$skill_dir/SKILL.md" ] || continue

    name="$(basename "$skill_dir")"

    if [ "$name" = ".system" ]; then
        printf 'skip %s: reserved Codex system skill name\n' "$name"
        skipped=$((skipped + 1))
        continue
    fi

    for target_dir in "$OPENCODE_SKILLS_DIR" "$CODEX_SKILLS_DIR"; do
        target="$target_dir/$name"

        if [ -L "$target" ]; then
            current="$(readlink "$target")"
            if [ "$current" = "$skill_dir" ]; then
                printf 'ok   %s -> %s\n' "$target" "$skill_dir"
                continue
            fi

            rm "$target"
        elif [ -e "$target" ]; then
            printf 'skip %s: exists and not our symlink (external from skills.sh?)\n' "$name"
            skipped=$((skipped + 1))
            continue
        fi

        ln -s "$skill_dir" "$target"
        printf 'link %s -> %s\n' "$target" "$skill_dir"
        changed=$((changed + 1))
    done
done

# Symlink AGENTS.md (central ~/.agents/AGENTS.md) to tool dirs
AGENTS_SRC="$HOME/.agents/AGENTS.md"
if [ -f "$AGENTS_SRC" ]; then
  for target_dir in "$OPENCODE_SKILLS_DIR" "$CODEX_SKILLS_DIR"; do
    target="$target_dir/AGENTS.md"
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$AGENTS_SRC" ]; then
      printf 'ok   %s -> %s\n' "$target" "$AGENTS_SRC"
      continue
    fi
    [ -L "$target" ] && rm "$target"
    [ -e "$target" ] && { printf 'skip AGENTS.md: exists\n'; continue; }
    ln -s "$AGENTS_SRC" "$target"
    printf 'link %s -> %s\n' "$target" "$AGENTS_SRC"
  done
fi

printf 'done: %s linked, %s skipped\n' "$changed" "$skipped"
