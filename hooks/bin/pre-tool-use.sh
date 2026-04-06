#!/bin/sh
set -eu

INPUT=$(cat || true)

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

deny() {
  jq -nc --arg reason "$1" \
    '{permissionDecision:"deny", permissionDecisionReason:$reason}'
  exit 0
}

TOOL_NAME=$(printf '%s' "$INPUT" | jq -r '.toolName // ""')

if [ "$TOOL_NAME" = "bash" ]; then
  COMMAND=$(printf '%s' "$INPUT" | jq -r '.toolArgs.command // ""')

  if printf '%s' "$COMMAND" | grep -Eiq '(^|[[:space:]])sudo([[:space:]]|$)|git[[:space:]]+reset[[:space:]]+--hard|git[[:space:]]+clean[[:space:]]+-fd|rm[[:space:]]+-rf[[:space:]]+/|mkfs|dd[[:space:]]+if=|chmod[[:space:]]+-R[[:space:]]+777|curl[^|]*\|[[:space:]]*(sh|bash)|wget[^|]*\|[[:space:]]*(sh|bash)'; then
    deny "Blocked by repository hook: dangerous shell pattern detected."
  fi
fi

case "$TOOL_NAME" in
  edit|create)
    if printf '%s' "$INPUT" | jq -r '.toolArgs | .. | strings' | grep -Eq '(^|/)\.git(/|$)|(^|/)\.github/hooks(/|$)|(^|/)\.env($|\.)|\.pem$|\.key$|\.crt$|\.p12$|(^|/)\.ssh(/|$)'; then
      deny "Blocked by repository hook: sensitive path edit requires explicit human handling."
    fi
    ;;
esac

exit 0
