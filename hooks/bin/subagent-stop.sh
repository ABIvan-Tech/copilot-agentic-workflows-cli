#!/bin/sh
set -eu

INPUT=$(cat || true)
LOG_DIR=".tmp/copilot-hooks"

mkdir -p "$LOG_DIR"
printf '%s\n' "$INPUT" >> "$LOG_DIR/subagent-stop.jsonl"

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

block() {
  jq -nc --arg reason "$1" '{decision:"block", reason:$reason}'
  exit 0
}

AGENT_NAME=$(printf '%s' "$INPUT" | jq -r '.agentName // .subagentName // .agent.name // ""')
ALL_TEXT=$(printf '%s' "$INPUT" | jq -r '[.. | strings] | join("\n")')
AGENT_NAME_LC=$(printf '%s' "$AGENT_NAME" | tr '[:upper:]' '[:lower:]')

if printf '%s' "$AGENT_NAME_LC" | grep -q 'planner'; then
  if ! printf '%s' "$ALL_TEXT" | grep -Eq 'Clarification Status:[[:space:]]+(COMPLETE|INCOMPLETE)'; then
    block "Planner output must include `Clarification Status: COMPLETE` or `Clarification Status: INCOMPLETE`."
  fi
fi

if printf '%s' "$AGENT_NAME_LC" | grep -q 'verifier'; then
  if ! printf '%s' "$ALL_TEXT" | grep -Eq 'Verification Verdict:[[:space:]]+(PASS|BLOCKED)'; then
    block "Verifier output must include `Verification Verdict: PASS` or `Verification Verdict: BLOCKED`."
  fi
fi

if printf '%s' "$AGENT_NAME_LC" | grep -q 'memory'; then
  if ! printf '%s' "$ALL_TEXT" | grep -Eq 'Memory Transaction Successful:|Memory Update:[[:space:]]+SKIP'; then
    block "Memory-curator output must include a successful memory transaction or an explicit skip."
  fi
fi

if printf '%s' "$ALL_TEXT" | grep -q 'Implementation Readiness:'; then
  if ! printf '%s' "$ALL_TEXT" | grep -Eq 'Implementation Readiness:[[:space:]]+(PASS|BLOCKED)'; then
    block "Readiness output must include `Implementation Readiness: PASS` or `Implementation Readiness: BLOCKED`."
  fi
fi

if printf '%s' "$ALL_TEXT" | grep -q 'Verification Verdict:'; then
  if ! printf '%s' "$ALL_TEXT" | grep -Eq 'Verification Verdict:[[:space:]]+(PASS|BLOCKED)'; then
    block "Verification output uses the verdict marker but not an allowed value."
  fi
fi

exit 0
