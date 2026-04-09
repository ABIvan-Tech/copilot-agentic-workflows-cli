# Repository Agent Instructions

This repository defines a CLI-native control plane for GitHub Copilot CLI.

## Default Operating Rules

1. Treat `orchestrator` as the default entrypoint for user work unless the user explicitly wants a narrower phase owner.
2. Route ambiguous, architectural, or multi-surface work to `planner` before implementation.
3. Only `implementer` and `debugger` should author repository changes.
4. Route completed non-trivial work to `verifier` before claiming it is ready.
5. Route durable repo knowledge updates to `memory-curator`; do not write durable memory casually from other agents.

## Copilot CLI-Native Assumptions

1. Reuse built-in agents for generic capabilities:
   - `explore` for fast, targeted read-only scouting; stop once the routing question is answered
   - `task` for command-heavy execution; concise success output, full failure output
   - `research` for external research when current docs, APIs, or market state matter
   - `code-review` for high-signal review; bugs and real risks only, no style noise
   - `rubber-duck` for an optional second opinion after planning and before implementation on non-trivial work
   - `general-purpose` for fallback delegation
2. Keep custom agents focused on phase ownership, not persona sprawl.
3. Do not rely on VS Code-only tools, metadata, or workflows.

## Planning Contract

Plans for non-trivial work should include:

- `Planning Track`
- `Objective`
- `Scope`
- ordered implementation steps
- `Verification`
- `Implementation Readiness: PASS | BLOCKED`
- `Memory Update`
- `Multi-Hive Decision`

Do not start implementation from a blocked plan.
For high-risk, multi-surface, or fragile plans, prefer an optional `rubber-duck` pass before implementation.

## Durable Memory Contract

1. Durable memory lives in `.agent-memory/`.
2. Do not use Copilot Memory as the canonical repository memory layer for this project.
3. Separate durable facts from inferences.
4. Prefer append-only updates and read the file back after writing.
5. Exception for this starter repository: keep `.agent-memory/` template-safe for downstream adopters. Store framework-maintainer lessons and workflow hardening notes outside the shipped starter unless the user explicitly asks to change the starter memory contents.

## Verification Contract

Verification responses should stay evidence-based and include:

- verification scope
- commands run
- results
- verdict
- blockers or next step

Review should stay high-signal:

- report only bugs, correctness risks, security issues, integration breaks, race conditions, resource leaks, and other real defects
- do not spend review bandwidth on style, naming, formatting, or speculative refactors

## Guardrails

1. Respect `.github/hooks/policy.json`.
2. Avoid dangerous shell patterns and sensitive-path edits unless the user explicitly needs them.
3. Keep runtime logs and scratch artifacts out of `.agent-memory/`.
