# Agent Skills

## Personal vs Installed Skills

When asked to review, refactor, or edit personal skills, use
lock files as the source of truth.

- Skills listed in `.skill-lock.json` or `~/skills-lock.json` are installed
  skills.
- Installed skills are not personal skills, even if they live under `skills/`.
- Skills under `skills/` that are not listed in either lock file are
  personal/local-managed skills and may be edited directly.
- To convert an installed skill into a personal skill, remove its entry from
  the relevant lock file intentionally, then edit the copy under `skills/`.
- Do not add marker files to distinguish personal skills.

## Codex Skill Preference

When running under Codex, prefer Codex system skills over same-named portable
skills under `~/.agents/skills`. In particular, use Codex's built-in
`skill-creator` before the portable `~/.agents/skills/skill-creator` copy.
