# Copilot CLI Repository Instructions

This repository is a GitHub Copilot CLI control plane, not a VS Code agent pack.

## Control Plane

- Prefer `orchestrator` as the main entrypoint.
- Use `planner` when ambiguity, architecture choice, or unclear verification exists.
- Use `implementer` for delivery work and `debugger` only for reproducible bugs.
- Use `verifier` as an independent gate after non-trivial implementation or debugging.
- Use `memory-curator` for durable memory writes.

## Built-in Agents vs Custom Agents

- Reuse built-in `explore`, `task`, `research`, `code-review`, `rubber-duck`, and `general-purpose` for generic work.
- Use custom agents only for phase ownership and repo-specific governance.
- Do not recreate built-in capabilities as separate repo-owned personas.

Built-in usage defaults:

- `explore`: answer quickly, search narrowly, stop early
- `task`: execute commands only, concise on success and verbose on failure
- `code-review`: report only high-confidence issues that materially matter
- `rubber-duck`: optional critique pass after planning and before implementation on non-trivial work

## Planning and Readiness

- For non-trivial work, produce a structured plan before implementation.
- Use `Quick Change`, `Feature Track`, or `System Track`.
- End every non-trivial plan with `Implementation Readiness: PASS` or `BLOCKED`.
- If the plan is blocked, stop and clarify before coding.

## Durable Memory

- Durable repository knowledge belongs only in `.agent-memory/`.
- Keep transient notes, scratch logs, and temporary plans out of `.agent-memory/`.
- Separate `Facts` from `Inferences` in durable memory entries.
- For this starter repository specifically, keep `.agent-memory/` neutral for downstream users. Put framework-maintainer lessons and repository-evolution notes outside the shipped starter unless the user explicitly asks to update the starter memory examples.

## Verification

- Do not claim success without executed checks or a clear explanation of why they could not run.
- Use the smallest meaningful verification set first, but do not skip obviously relevant gates.
- Keep verification and memory updates independent from the authoring phase when possible.

## Runtime Safety

- Respect `.github/hooks/policy.json`.
- Treat `.git`, `.github/hooks`, environment files, and secret-like files as protected areas.
- Keep prompts, docs, skills, and agents aligned with Copilot CLI runtime behavior.
