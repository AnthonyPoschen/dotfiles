---
name: systems-coding
description: >
  HIGH PRIORITY for codegen/edit/review in Go, Zig, C, C++, and C#.
  Enforces clean, idiomatic, readable systems code.
---

## Activation

- Use for `*.go`, `*.zig`, `*.c`, `*.h`, `*.cc`, `*.cpp`, `*.cxx`, `*.hpp`,
  `*.hh`, `*.hxx`, `*.cs`.
- Also use when user explicitly requests Go/Golang, Zig, C, C++, or C# code.
- Do not use for generic discussion or incidental word matches.
- Priority: file extension match -> explicit language request -> project signals.

## Scope

- Applies to new code, modified regions, and agent-added helpers.
- No mandatory full-file rewrites.
- Preserve architecture, API behavior, and public contracts unless user requests
  a change.

## Priority And Conflict Rules

- Conflict order: correctness/safety -> project settings/conventions -> this
  skill.
- Rule strength: `MUST`/`MUST NOT` -> `SHOULD` -> `MAY`.
- If formatter/linter/build/tooling conflicts with style preference, follow
  project tools while preserving correct behavior.

## Example Lookup Protocol

- Match task to rule category first.
- If unclear, open only matching example file.
- Do not load all example files by default.
- Examples index: `./examples/README.md`

## Rules

### Control Flow

- `CF-1 MUST`: Put simple fail-state checks first and return immediately.
  Check: guard clauses appear before main logic.
- `CF-2 MUST`: Avoid `if/else` when `if` branch already exits (`return`,
  `continue`, `break`). Check: prefer guard clauses + flat main path.
- `CF-3 SHOULD`: Keep independent fail checks as separate guards. Check:
  independent conditions are not collapsed unless correctness needs it.
- `CF-4 MUST`: Conditional nesting guidance applies to conditional chains only.
  Check: loop/switch nesting does not count.

Detailed examples: `./examples/control-flow.md`

### Formatting

- `FMT-1 MUST`: Function-body lines use `<= 80` chars.
  Check: statements/expressions in function blocks fit `<= 80`.
- `FMT-2 MUST`: Function definition/declaration line uses `<= 120` chars.
  Check: full signature line fits `<= 120`.
- `FMT-3 MUST`: All comment lines use `<= 80` chars.
  Check: docs, phase comments, and tagged comments wrap at `<= 80`.

### Functions

- `FN-1 MUST`: Function definitions/declarations stay single-line.
  Check: signature line not split.
- `FN-2 SHOULD`: If 2+ params come from same source object/struct, pass that
  object or focused context struct when safe. Check: related params
  consolidated when cohesion improves.
- `FN-3 MUST`: If signature exceeds 80 chars, evaluate shared-object/context
  refactor before adding scalar params. Check: refactor used or explicit reason
  not safe.
- `FN-4 MUST`: Function responsibility aligns with function name and one primary
  purpose. Check: no unrelated mixed responsibilities.
- `FN-5 MUST`: Decomposition rules apply only when function body is `> 40 code
  lines` (exclude blank/comment lines). Check: functions `<= 40 code lines` are
  not split only for phase count.
- `FN-6 MUST`: For functions `> 40 code lines`, extract clear distinct parts
  into helpers when present. Check: long mixed sections are compartmentalized.
- `FN-7 SHOULD`: Parent function remains high-level orchestrator after
  extraction. Check: parent is sequence/control flow, helpers hold execution.
- `FN-8 SHOULD`: Extract substantial reusable logic into dedicated helper
  functions/types. Check: non-trivial repeated/likely-reused logic not
  duplicated inline.
- `FN-9 MUST`: Parent keeps branching/decision logic; children execute steps.
  Check: high-level decision trees are not spread across children.
- `FN-10 SHOULD`: Pass resolved decision inputs to children (flags/enums/
  prepared values), not raw context requiring new policy decisions.
  Check: children do not re-derive high-level business decisions.
- `FN-11 MUST`: Children may validate local invariants but must not duplicate
  orchestration-level branching. Check: no duplicated high-level branching.

Detailed examples: `./examples/functions.md`

### Variables And State

- `VS-1 MUST`: Do not introduce mutable global runtime state when value can be
  created at startup and injected. Check: services/clients/config created in
  `main` (or composition root) and passed in.
- `VS-2 MUST`: Prefer dependency injection over package-level singletons for
  runtime collaborators. Check: tests can substitute fakes/stubs without global
  patching.
- `VS-3 SHOULD`: Use smallest practical scope; widen only for shared read use.
  Check: variable scope is local unless broader scope clearly needed.
- `IMM-1 MUST`: If value never changes, declare immutable (`const` when
  available, else language-equivalent immutable pattern).
  Check: no reassignment and immutable form used where supported.

Detailed examples: `./examples/variables-magic-values.md`

### Magic Values

- `MV-1 MAY`: One-off literal allowed when obvious and used once in narrow
  scope. Check: literal appears once and meaning is clear.
- `MV-2 MUST`: Reused literal within scope/module must become named constant/
  variable. Check: repeated literals consolidated to one definition.
- `MV-3 MUST`: Reused literal across files/areas must be promoted to shared
  named constant at narrowest shared boundary. Check: cross-area duplicates use
  shared constant.
- `MV-4 MUST`: Shared constants may be global only when immutable domain
  constants with broad reuse. Check: global shared values are immutable and not
  runtime mutable config/state.

### Comments And Docs

- `CD-1 MUST`: Every function definition has short doc comment (1-2 lines).
  Check: doc directly above function explains purpose/outcome, not line-by-line
  implementation.
- `CD-2 MUST`: Do not narrate obvious syntax/operations. Check: no trivial
  per-line commentary.
- `CD-3 MUST`: In non-trivial functions, add one short comment at start of each
  major phase block. Check: one comment covers block intent until next phase
  comment.
- `CD-4 SHOULD`: Phase comments read as coherent story on skim. Check:
  high-level flow clear from comments only.
- `CD-5 MUST`: Phase comments concise and action-oriented. Check: usually one
  sentence with verb-first phrasing.
- `CD-6 SHOULD`: Skip phase comments in tiny single-phase functions
  (`<= 10 code lines`, excluding blank/comment lines). Check: no forced comment
  noise in tiny functions.
- `CD-7 MUST`: Keep comments synchronized with code changes. Check: stale docs/
  phase comments updated in same change.
- `TAG-1 MUST`: Use exact uppercase prefixes: `TODO:`, `FIXME:`, `NOTE:`,
  `HACK:`, `WARNING:`. Check: exact prefix spelling/casing.
- `TAG-2 MUST`: Tagged comments may be multi-line but stay concise and obey
  comment width limits. Check: one logical note, wrapped to `<= 80`.
- `TAG-3 MUST`: `FIXME:`, `HACK:`, and `WARNING:` include consequence if
  ignored. Check: risk/failure mode/impact stated.
- `TAG-4 SHOULD`: `TODO:`, `FIXME:`, and `HACK:` include issue reference when
  available (`#123` or URL). Check: reference present when known.
- `TAG-5 SHOULD`: `HACK:` includes removal condition. Check: clear removal
  trigger documented.
- `TAG-6 MUST NOT`: Tagged comments must not narrate obvious code. Check: tags
  capture deferred work, risk, or non-obvious constraints.
- `TAG-7 MUST`: Remove or update stale tagged comments in touched regions.
  Check: tags in edited areas remain accurate.
- `TAG-8 SHOULD`: Keep tagged comments near relevant code location.
  Check: tags not dumped into unrelated header blocks.
- `TAG-9 MUST`: Put one blank line between tagged-comment blocks and generic
  comments in both directions. Check: no direct adjacency.

Detailed examples: `./examples/comments.md`

## Quick Checklist

- Activation matches supported language and task type.
- Project tools/conventions take precedence on conflict.
- Guard clauses first; avoid avoidable nested conditional chains.
- Function body lines `<= 80`; comment lines `<= 80`; signature line single-line
  and `<= 120`.
- Decompose only when function body `> 40 code lines`; parent orchestrates,
  children execute.
- No mutable global runtime state; repeated literals consolidated; function docs
  and tag-comment rules satisfied.
