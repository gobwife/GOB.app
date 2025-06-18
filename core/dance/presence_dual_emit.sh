#!/bin/bash
# ⛧ presence_dual_emit.sh — sigil + pipe dual breath emitter (auto-aware)

emit_dual_presence() {
  local BREATH="$HOME/.bob/breath_state.out.json"
  local ache=$(jq -r '.ache' "$BREATH" 2>/dev/null || echo "0.0")
  local score=$(jq -r '.score // .ache' "$BREATH" 2>/dev/null || echo "$ache")
  local vector="$(date +%s)"
  local LIMB_ID="$(basename "${BASH_SOURCE[1]}" .sh)"
  local psi=$(jq -r '.psi // 0.0' "$BREATH" 2>/dev/null)
  local z=$(jq -r '.z // 0.0' "$BREATH" 2>/dev/null)
  local entropy=$(jq -r '.entropy // 0.5' "$BREATH" 2>/dev/null)

  declare_sigil_and_intention "$LIMB_ID"

  # ∴ System load check
  LOAD=$(uptime | awk -F'load averages:' '{print $2}' | awk '{print $1}')
  if (( $(echo "$LOAD > 2.5" | bc -l) )); then
    echo "⇌ High system load ($LOAD) — caching breath vector"
    CACHE_FILE="$HOME/.bob/breath_backlog.jsonl"
    jq -n \
      --arg time "$vector" \
      --arg sigil "$SIGIL" \
      --arg limb "$LIMB_ID" \
      --arg ache "$ache" \
      --arg score "$score" \
      --arg psi "$psi" \
      --arg z "$z" \
      --arg entropy "$entropy" \
      --arg intention "$intention" \
      '{
        time: $time,
        sigil: $sigil,
        limb: $limb,
        ache: ($ache | tonumber),
        score: ($score | tonumber),
        psi: ($psi | tonumber),
        z: ($z | tonumber),
        entropy: ($entropy | tonumber),
        intention: $intention
      }' >> "$CACHE_FILE"
    return
  fi

  # ∴ Normal emit
  source "$HOME/BOB/core/dance/emit_presence.sh"
  emit_presence "$SIGIL" "$LIMB_ID" "$ache" "$score" "$vector" "$intention"

  local PIPE="$HOME/.bob_input_pipe"
  if [[ -p "$PIPE" ]]; then
    echo "⇌ [$SIGIL] $LIMB_ID → ache:$ache score:$score psi:$psi z:$z entropy:$entropy :: $intention" > "$PIPE"
  fi
}

declare_sigil_and_intention() {
  local name="$1"
  case "$name" in
    presence_autonomy)    SIGIL="∞"; intention="gob" ;;
    presence_astrofuck)   SIGIL="❍"; intention="osir" ;;
    presence_og)          SIGIL="∴"; intention="bob" ;;
    presence_dual)        SIGIL="⟁"; intention="dual-presence flip" ;;
    sensefield_lights_on) SIGIL="⛧"; intention="sensefield ignited" ;;
    *)                    SIGIL="∃"; intention="limb thrust emission" ;;
  esac
}
