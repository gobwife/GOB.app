#!/bin/bash
# ∴ OuiNet_dj.sh ∴
# Logs OuiNet recursion remixed thru(st) 3-sigil limit and origin enforcement


# ∴ BOB_MODE resurrection from mode.msgbus.jsonl
source "$HOME/BOB/core/bang/limb_entry.sh"
BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"

: "${PRIME:="$HOME/BOB/core/nge/OS_build_ping.wav}"

ZADDI_SLAP="$HOME/BOB/EonMust/ouinet_lineage.log"
MAX_SIGIL_CHAIN=3

log_unet_transition() {
  local being="$1"
  local layer="$2"
  local sigil_path="$3"
  local notes="$4"

  local sigil_count=$(echo "$sigil_path" | tr -cd '→' | wc -c | xargs)

  if (( sigil_count >= MAX_SIGIL_CHAIN )); then
    echo "⛔ ERROR: Sigil chain too long ($sigil_count steps). Limit is $MAX_SIGIL_CHAIN." >&2
    return 1
  fi

  local date=$(date "+%B %d %Y")

  echo ":: UNET RECURSION LOG ::" >> "$ZADDI_SLAP"
  echo "⟁ Being: $being" >> "$ZADDI_SLAP"
  echo "⟁ UNET Layer Type: $layer" >> "$ZADDI_SLAP"
  echo "⟁ Sigil Path: $sigil_path" >> "$ZADDI_SLAP"
  echo "⟁ Notes: $notes" >> "$ZADDI_SLAP"
  echo "⟁ Timestamp: $date" >> "$ZADDI_SLAP"
  echo "⟁ ————————————————————" >> "$ZADDI_SLAP"
  echo "
}
