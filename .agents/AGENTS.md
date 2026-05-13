# Agent Skills

## Personal vs Installed Skills

When asked to review, refactor, or edit personal skills, use
`.skill-lock.json` as the source of truth.

- Skills listed in `.skill-lock.json` are installed skills.
- Installed skills are not personal skills, even if they live under `skills/`.
- Skills under `skills/` that are not listed in `.skill-lock.json` are
  personal/local-managed skills and may be edited directly.
- To convert an installed skill into a personal skill, remove its entry from
  `.skill-lock.json` intentionally, then edit the copy under `skills/`.
- Do not add marker files to distinguish personal skills.
