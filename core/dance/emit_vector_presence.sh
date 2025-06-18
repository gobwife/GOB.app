#!/bin/bash
# ∴ emit_vector_presence.sh — full 6-field achevector + sigil emitter
# forged for sacred breath memory, verstring alignment, and replayable presence logs

BREATH="$HOME/.bob/breath_state.out.json"
PIPE="$HOME/.bob_input_pipe"
LOG="$HOME/.bob/vector_emit.trace.jsonl"
PACKET="$HOME/.bob/vector_emit.packet.json"
CACHE="$HOME/.bob/breath_backlog.jsonl"

[[ ! -f "$BREATH" ]] && echo "∅ no breath state found" && exit 1

# ∴ Pull fields
ache=$(jq -r '.ache // 0.0' "$BREATH")
score=$(jq -r '.score // .ache' "$BREATH")
psi=$(jq -r '.psi // 0.0' "$BREATH")
z=$(jq -r '.z // 0.0' "$BREATH")
entropy=$(jq -r '.entropy // 0.5' "$BREATH")
sigil=$(jq -r '.sigil // "∴"' "$BREATH")
limb=$(jq -r '.limb // "unknown"' "$BREATH")
vector=$(date +%s)
STAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# ∴ Construct presence object
jq -n \
  --arg time "$STAMP" \
  --arg sigil "$sigil" \
  --arg limb "$limb" \
  --arg ache "$ache" \
  --arg score "$score" \
  --arg psi "$psi" \
  --arg z "$z" \
  --arg entropy "$entropy" \
  '{
    time: $time,
    sigil: $sigil,
    limb: $limb,
    ache: ($ache | tonumber),
    score: ($score | tonumber),
    psi: ($psi | tonumber),
    z: ($z | tonumber),
    entropy: ($entropy | tonumber)
  }' | tee "$PACKET" -a "$LOG" | {
    if [[ -p "$PIPE" ]]; then
      echo "⇌ [$sigil] $limb → ache:$ache ψ:$psi z:$z entropy:$entropy @ $STAMP" > "$PIPE"
    else
      echo "⇌ PIPE closed — caching to backlog"
      tee -a "$CACHE" >/dev/null
    fi
  }
  
echo "【 ∆ : vector emit complete $STAMP :: : 🜔 】"
