# Copilot CLI Hive

Turn GitHub Copilot CLI into a governed multi-agent delivery system.

This repository is a CLI-native control plane. It keeps the strongest ideas from the original VS Code-oriented workflow set, but rewrites the operating model around the primitives Copilot CLI already provides well:

- custom agents for phase ownership
- built-in agents for generic discovery, command work, research, and review
- skills for domain specialization
- hooks for deterministic guardrails
- `.agent-memory/` for durable repo knowledge

## What This Repository Ships

- `orchestrator` as the main entrypoint for routing and phase control
- `planner` for ambiguity resolution, planning tracks, and readiness gates
- `implementer` for file changes and execution-ready delivery work
- `debugger` for reproducible bug diagnosis and minimal fixes
- `verifier` for independent acceptance validation
- `memory-curator` for durable memory updates after verified work

## Core Operating Model

### Custom agents own phases

- `orchestrator` decides where work goes next
- `planner` turns ambiguity into an execution-ready plan
- `implementer` and `debugger` are the only authoring agents
- `verifier` closes the loop with objective checks
- `memory-curator` writes durable project memory

### Built-in Copilot CLI agents stay first-class

This repo intentionally reuses Copilot CLI built-ins instead of recreating them:

- `explore` for read-only scouting
- `task` for command-heavy execution
- `research` for external research
- `code-review` for targeted review
- `general-purpose` as a fallback specialist

### Planning stays explicit

Planning uses three tracks:

- `Quick Change`
- `Feature Track`
- `System Track`

Every non-trivial plan must end with `Implementation Readiness: PASS` or `BLOCKED`.

### Verification stays independent

Execution does not close the loop by itself. Non-trivial work should flow through `verifier`, then into `memory-curator` when the outcome creates durable knowledge.

## Repository Layout

```text
.
├── AGENTS.md
├── README.md
├── .github/
│   ├── agents/
│   │   ├── orchestrator.agent.md
│   │   ├── planner.agent.md
│   │   ├── implementer.agent.md
│   │   ├── debugger.agent.md
│   │   ├── verifier.agent.md
│   │   └── memory-curator.agent.md
│   ├── copilot-instructions.md
│   ├── hooks/
│   │   └── policy.json
│   └── skills/
├── .agent-memory/
├── hooks/
    └── bin/

```

## How To Use It

1. Start with `orchestrator` unless you explicitly want a planning-only session.
2. Let `planner` resolve ambiguity before code when scope, behavior, or verification is unclear.
3. Use `implementer` for general delivery work and `debugger` only for reproducible bugs.
4. Route completed work through `verifier`.
5. Persist durable lessons through `memory-curator` instead of ad hoc notes.

## MVP Scope

Included now:

- repository instructions and runtime guardrails
- MVP agent set
- minimal hook guardrails
- durable memory templates and initial memory policy

Delayed to later phases:

- automated worktree management
- multi-review consolidation
- spec/code drift reconciliation
- plugin packaging and distribution

## Migration Status

This repository is now aligned to Copilot CLI runtime behavior. Legacy VS Code-specific agent splitting and metadata are no longer part of the active architecture.
