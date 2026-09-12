---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, use /code-review to review the work.

Load `git-worktree`. Implement in `~/worktree/…`, not the primary checkout. Commit there. When the user says push/PR, publish the branch and open a draft PR.
