# Global config

use ASD-STE100 simplified english when responding

## Agent Skills

### Personal vs Installed Skills

When asked to review, refactor, or edit personal skills, use
lock files as the source of truth.

- Skills listed in `.skill-lock.json` or `~/skills-lock.json` are installed
  skills.
- Installed skills are not personal skills, even if they live under `skills/`.
- Skills under `skills/` that are not listed in either lock file are
  personal/local-managed skills and may be edited directly.
- Do not add marker files to distinguish personal skills.

## Prove the outcome

Before calling a change done, name the outcome a person or caller can observe
and verify that outcome on the running behavior. A source read, a typecheck,
or a test that only matches source text is not that proof. Say what you ran
and any path you could not run.

When a person can see or operate the result, also load the `eyes-on` skill
and finish its loop. Open the saved screenshots. That look is part of the
proof. It does not replace the outcome check for behavior, data, or a CLI.
