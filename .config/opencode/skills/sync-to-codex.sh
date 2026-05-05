#!/usr/bin/env sh
set -eu

OPENCODE_SKILLS_DIR="${OPENCODE_SKILLS_DIR:-$HOME/.config/opencode/skills}"
CODEX_SKILLS_DIR="${CODEX_SKILLS_DIR:-$HOME/.codex/skills}"

mkdir -p "$CODEX_SKILLS_DIR"

changed=0
skipped=0

for skill_dir in "$OPENCODE_SKILLS_DIR"/*; do
    [ -d "$skill_dir" ] || continue
    [ -f "$skill_dir/SKILL.md" ] || continue

    name="$(basename "$skill_dir")"
    target="$CODEX_SKILLS_DIR/$name"

    if [ "$name" = ".system" ]; then
        printf 'skip %s: reserved Codex system skill name\n' "$name"
        skipped=$((skipped + 1))
        continue
    fi

    if [ -L "$target" ]; then
        current="$(readlink "$target")"
        if [ "$current" = "$skill_dir" ]; then
            printf 'ok   %s -> %s\n' "$target" "$skill_dir"
            continue
        fi

        rm "$target"
    elif [ -e "$target" ]; then
        printf 'skip %s: Codex path exists and is not a symlink\n' "$name"
        skipped=$((skipped + 1))
        continue
    fi

    ln -s "$skill_dir" "$target"
    printf 'link %s -> %s\n' "$target" "$skill_dir"
    changed=$((changed + 1))
done

printf 'done: %s linked, %s skipped\n' "$changed" "$skipped"
