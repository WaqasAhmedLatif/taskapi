# Project Instructions for AI Agents

This file provides instructions and context for AI coding agents working on this project.
<!-- bd-doctor-divergence: ok -->

## Mandatory Beads Work Comments

Every repository task must leave a durable Beads trail before handoff or close.
Before saying work is done, add a `bd comment <id> "..."` or `bd note <id> "..."`
to the active bead with enough detail for another human or agent to resume
without chat context.

The Beads update must include:
- What was changed or decided
- Files, commands, tools, or external sources used
- Verification performed and results
- Any remaining risks, follow-up beads, or blocked items

If no active bead exists, create or claim the smallest relevant bead first. Do
not rely on the final chat response as the only record of work performed.

## Codex Beads Identity

When Codex works on a Beads issue in this repository, the active bead must be
assigned to `Codex` before implementation or investigation begins. Use
`bd --actor Codex update <id> --assignee Codex --status in_progress`, or the
equivalent `bd --actor Codex ...` command that keeps the assignee as `Codex`.

All Beads comments, notes, and close records made by Codex must use
`--actor Codex`. Start the visible comment or note body with `Codex:` so the
work log identifies Codex in both Beads metadata and comment text. If Codex
inherits a bead assigned to someone else, add a `Codex:` comment explaining the
handoff before changing the assignee unless the user explicitly directs
otherwise.

## Standard Beads Work Lifecycle

For any non-trivial Beads task, use this lifecycle. Keep it lightweight, but do
not skip phases silently; if a phase does not apply, say so in the bead comment.

1. Context and claim: run `bd prime`, inspect the active bead with
   `bd show <id>`, clarify with the human only when requirements are ambiguous
   or risky, then assign/start the bead as required by the Codex identity rule.
   Add a `Codex:` start comment describing intended scope.
2. Scout the Beads/project state: use the smallest relevant set of `bd status`,
   `bd ready`, `bd blocked`, `bd lint <id>`, `bd doctor --check=conventions`,
   `bd stale`, `bd orphans`, and `bd find-duplicates` before creating or closing
   work. Use `bd doctor --agent --json` when Beads health itself looks suspect.
3. Research and options: read existing repo code/docs first. Browse or consult
   external sources when the user asks, when facts are current or uncertain, or
   when the decision has meaningful cost/risk. Record important sources,
   options, pros/cons, and recommendations in the bead or affected docs.
4. Design and plan: for meaningful changes, capture the chosen approach,
   tradeoffs, acceptance criteria, risks, rollback notes, and verification plan
   in the bead using comments/notes/design fields or in repo docs when the
   design should live with the code.
5. Implement narrowly: follow existing repo patterns, keep edits scoped to the
   bead, avoid unrelated refactors, and create/link follow-up beads for
   discovered work instead of hiding it in chat.
6. Audit before handoff: review the diff for correctness, code health,
   simplicity, security/privacy, performance, operability, accessibility/UI
   quality when relevant, docs impact, and maintainability. Prefer evidence and
   local conventions over personal taste.
7. Verify appropriately: run the strongest practical checks for the change
   surface, such as unit tests, integration tests, build/type/lint checks,
   API/manual checks, UI browser checks, or smoke tests. Record exact commands
   and results in the bead. If a check cannot be run, record why.
8. Update docs and durable records: update README, runbooks, examples,
   configuration docs, or architecture notes affected by the change. Add a final
   `Codex:` bead comment with changes, files/commands/tools/sources,
   verification, risks, and follow-ups before closing or handing off.
9. Close, commit, and sync only when appropriate: close beads only when
   acceptance criteria are met. Commit, `bd dolt push`, and git push only when
   explicitly authorized by the user or active repo profile; when committing,
   mention the bead ID and run final `git status`/relevant Beads checks first.

## Visual-First Documentation

When creating or updating docs, design notes, plans, or research summaries, use
less prose and more structure. Prefer diagrams, Mermaid charts, tables,
decision matrices, command matrices, checklists, and short bullets when they
make the information easier to scan. Use prose for context, rationale, and
tradeoffs that do not fit cleanly into a structured format.

## Python Runtime

The application runtime target is Python 3.11, matching `Dockerfile`
(`python:3.11-slim`). Use Python 3.11 for local virtual environments, dependency
resolution, and compatibility-sensitive test runs. The host machine may have a
newer Python, but do not treat Python 3.14 behavior or dependency warnings as
the project baseline unless the Docker/runtime target is intentionally updated.

When Python 3.11 is unavailable locally, prefer either:
- Docker for runtime parity with the checked-in image
- A side-by-side Python 3.11 install and `.venv` created with `py -3.11`

<!-- BEGIN BEADS INTEGRATION v:1 profile:minimal hash:6cd5cc61 -->
## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context and commands.

### Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work
bd close <id>         # Complete work
```

### Rules

- Use `bd` for ALL task tracking — do NOT use TodoWrite, TaskCreate, or markdown TODO lists
- Run `bd prime` for detailed command reference and session close protocol
- Use `bd remember` for persistent knowledge — do NOT use MEMORY.md files

**Architecture in one line:** issues live in a local Dolt DB; sync uses `refs/dolt/data` on your git remote; `.beads/issues.jsonl` is a passive export. See https://github.com/gastownhall/beads/blob/main/docs/SYNC_CONCEPTS.md for details and anti-patterns.

## Agent Context Profiles

The managed Beads block is task-tracking guidance, not permission to override repository, user, or orchestrator instructions.

- **Conservative (default)**: Use `bd` for task tracking. Do not run git commits, git pushes, or Dolt remote sync unless explicitly asked. At handoff, report changed files, validation, and suggested next commands.
- **Minimal**: Keep tool instruction files as pointers to `bd prime`; use the same conservative git policy unless active instructions say otherwise.
- **Team-maintainer**: Only when the repository explicitly opts in, agents may close beads, run quality gates, commit, and push as part of session close. A current "do not commit" or "do not push" instruction still wins.

## Session Completion

This protocol applies when ending a Beads implementation workflow. It is subordinate to explicit user, repository, and orchestrator instructions.

1. **File issues for remaining work** - Create beads for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **Handle git/sync by active profile**:
   ```bash
   # Conservative/minimal/default: report status and proposed commands; wait for approval.
   git status

   # Team-maintainer opt-in only, unless current instructions forbid it:
   git pull --rebase
   git push
   git status
   ```
5. **Hand off** - Summarize changes, validation, issue status, and any blocked sync/commit/push step

**Critical rules:**
- Explicit user or orchestrator instructions override this Beads block.
- Do not commit or push without clear authority from the active profile or the current user request.
- If a required sync or push is blocked, stop and report the exact command and error.
<!-- END BEADS INTEGRATION -->


## Build & Test

_Add your build and test commands here_

```bash
# Example:
# npm install
# npm test
```

## Architecture Overview

_Add a brief overview of your project architecture_

## Conventions & Patterns

_Add your project-specific conventions here_
