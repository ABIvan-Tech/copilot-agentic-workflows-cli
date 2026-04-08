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
    block "Planner output must include Clarification Status: COMPLETE or Clarification Status: INCOMPLETE."
  fi
  if printf '%s' "$ALL_TEXT" | grep -Eq 'Clarification Status:[[:space:]]+COMPLETE'; then
    if ! printf '%s' "$ALL_TEXT" | grep -Eq 'User-Equivalent Verification'; then
      block "Planner output marked complete must include User-Equivalent Verification."
    fi
    if ! printf '%s' "$ALL_TEXT" | grep -Eq 'Execution Path / Causal Path'; then
      block "Planner output marked complete must include Execution Path / Causal Path."
    fi
    if printf '%s' "$ALL_TEXT" | grep -Eq 'Parallelization Decision:[[:space:]]*/fleet|Status:[[:space:]]*ENABLED'; then
      if ! printf '%s' "$ALL_TEXT" | grep -Eq 'Ownership Plan'; then
        block "Planner output enabling parallel work must include Ownership Plan."
      fi
    fi
  fi
fi

if printf '%s' "$AGENT_NAME_LC" | grep -q 'implementer'; then
  if ! printf '%s' "$ALL_TEXT" | grep -Eq 'Changes Made'; then
    block "Implementer output must include Changes Made."
  fi
  if ! printf '%s' "$ALL_TEXT" | grep -Eq 'Validation'; then
    block "Implementer output must include Validation."
  fi
  if ! printf '%s' "$ALL_TEXT" | grep -Eq 'Files Owned'; then
    block "Implementer output must include Files Owned."
  fi
fi

if printf '%s' "$AGENT_NAME_LC" | grep -q 'debugger'; then
  if ! printf '%s' "$ALL_TEXT" | grep -Eq 'Reproduction'; then
    block "Debugger output must include Reproduction."
  fi
  if ! printf '%s' "$ALL_TEXT" | grep -Eq 'Proof of Reachability'; then
    block "Debugger output must include Proof of Reachability."
  fi
  if ! printf '%s' "$ALL_TEXT" | grep -Eq 'Root Cause'; then
    block "Debugger output must include Root Cause."
  fi
fi

if printf '%s' "$AGENT_NAME_LC" | grep -q 'verifier'; then
  if ! printf '%s' "$ALL_TEXT" | grep -Eq 'Verification Verdict:[[:space:]]+(PASS|BLOCKED)'; then
    block "Verifier output must include Verification Verdict: PASS or Verification Verdict: BLOCKED."
  fi
  if ! printf '%s' "$ALL_TEXT" | grep -Eq 'Primary Verification Path'; then
    block "Verifier output must include Primary Verification Path."
  fi
  if ! printf '%s' "$ALL_TEXT" | grep -Eq 'Commands Run'; then
    block "Verifier output must include Commands Run."
  fi
  if ! printf '%s' "$ALL_TEXT" | grep -Eq 'Parity With User Workflow'; then
    block "Verifier output must include Parity With User Workflow."
  fi
fi

if printf '%s' "$AGENT_NAME_LC" | grep -q 'memory'; then
  if ! printf '%s' "$ALL_TEXT" | grep -Eq 'Memory Transaction Successful:|Memory Update:[[:space:]]+SKIP'; then
    block "Memory-curator output must include a successful memory transaction or an explicit skip."
  fi
fi

if printf '%s' "$ALL_TEXT" | grep -q 'Implementation Readiness:'; then
  if ! printf '%s' "$ALL_TEXT" | grep -Eq 'Implementation Readiness:[[:space:]]+(PASS|BLOCKED)'; then
    block "Readiness output must include Implementation Readiness: PASS or Implementation Readiness: BLOCKED."
  fi
fi

if printf '%s' "$ALL_TEXT" | grep -q 'Verification Verdict:'; then
  if ! printf '%s' "$ALL_TEXT" | grep -Eq 'Verification Verdict:[[:space:]]+(PASS|BLOCKED)'; then
    block "Verification output uses the verdict marker but not an allowed value."
  fi
fi

exit 0
