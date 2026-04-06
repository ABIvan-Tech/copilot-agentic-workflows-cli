---
last_updated: 2026-04-03
purpose: "Durable project decisions and invariants for the Copilot CLI native control plane."
---

# Project Decisions

## How to Use

- Add entries only when a decision is durable and likely to matter in future sessions.
- Prefer linking to code/paths and stating invariants/constraints over narrative.
- If a decision is superseded, append an "Update" note to the original entry.
- Keep runtime scratch notes out of this file.
- Separate verified repo facts from assumptions or interpretations.

## Entry Template

```md
## <Decision Title> — YYYY-MM-DD

### Facts
- Verified repo facts with file/path references.

### Inferences
- Assumptions or interpretations that still need validation.

### Decision
- The durable rule, invariant, or operating choice.

### Consequences
- What this changes, constrains, or requires going forward.
```

## Onboarding Snapshot Template

Use this after project familiarization / onboarding runs:

```md
## Onboarding Snapshot — YYYY-MM-DD

### Facts
- Major modules / packages
- Run / build / test commands
- Key conventions and invariants
- Top risks or TODOs worth remembering

### Inferences
- Only if necessary, clearly marked
```

## Entries

## CLI-Native Control Plane Baseline — 2026-04-03

### Facts
- Repository-wide instructions now live in `AGENTS.md` and `.github/copilot-instructions.md`.
- The active custom agent set is `orchestrator`, `planner`, `implementer`, `debugger`, `verifier`, and `memory-curator` under `.github/agents/`.
- Hook configuration now lives in `.github/hooks/policy.json`, with supporting scripts in `hooks/bin/`.
- Architecture, delegation, memory, and hook policy documents now live under `docs/`.

### Inferences
- Built-in Copilot CLI agents are expected to cover generic scouting, research, task execution, and review better than repo-owned clones.

### Decision
- This repository is governed as a Copilot CLI-native control plane with phase-specific custom agents, built-in CLI delegation, hook-based guardrails, and `.agent-memory/` as the durable memory layer.

### Consequences
- Legacy VS Code-era agent splits such as separate coder and reviewer personas are not part of the active architecture.
- Future workflow changes should extend CLI-native docs, custom agents, skills, hooks, and durable memory instead of reintroducing VS Code-only assumptions.

### Citations
- `AGENTS.md`
- `.github/copilot-instructions.md`
- `.github/agents/orchestrator.agent.md`
- `.github/agents/planner.agent.md`
- `.github/agents/implementer.agent.md`
- `.github/agents/debugger.agent.md`
- `.github/agents/verifier.agent.md`
- `.github/agents/memory-curator.agent.md`
- `.github/hooks/policy.json`
- `docs/architecture.md`

### memory_meta
- timestamp: 2026-04-03
- author: memory-curator (bootstrapped)

## MVP Skill Scope Excludes Deferred Parallel Review and Worktree Playbooks — 2026-04-03

### Facts
- `.github/skills/README.md` no longer lists `git-worktree` or `multi-model-review` as shipped skills.
- Dedicated skill files for `git-worktree` and `multi-model-review` were removed from `.github/skills/`.
- `docs/delegation-model.md` now treats `/fleet` as an advanced runtime pattern and states that dedicated worktree guidance is not shipped in the MVP.

### Inferences
- Keeping deferred parallelization and multi-review playbooks in the shipped skill catalog would make the MVP look broader than the current validated workflow actually is.

### Decision
- The MVP skill surface should stay limited to planning, execution quality, verification, security, and durable memory. Parallel multi-review consolidation and worktree playbooks are deferred until there is a validated default operating model for them.

### Consequences
- Downstream repositories should add their own worktree or multi-review extensions only when they intentionally adopt those workflows.
- The default control plane remains legible and does not advertise non-MVP parallelization patterns as ready-to-use skills.

### Citations
- `.github/skills/README.md`
- `docs/delegation-model.md`

### memory_meta
- timestamp: 2026-04-03
- author: memory-curator (bootstrapped)
