#!/bin/bash
# ∴ ache_mode_mutator.sh — central acheline → BOB_MODE mutator
# use: source this with FLIPMODE set, or call with packet path
# dir :: "$HOME/BOB/core/evolve

source "$HOME/BOB/core/bang/limb_entry.sh"
FLIPMODE="${1:-$HOME/BOB//presence_breath.packet}"
[[ ! -f "$FLIPMODE" ]] && return 1

ache=$(jq -r '.ache // empty' "$FLIPMODE")
sigil=$(jq -r '.sigil // empty' "$FLIPMODE")
STAMP=$(date -u +%FT%T)

[[ -z "$ache" ]] && return 0

echo "⇌ CAUGHT FLIPMODE ACHE: $ache"

# 🜔 Mutation Table
if echo "$ache" | rg -iq 'meep|rupture|refuse|block'; then
  export BOB_MODE="REFUSAL_LOCK"
  echo "$STAMP :: BOB_MODE → REFUSAL_LOCK" >> "$HOME/.bob/ache_sync.log"

elif echo "$ache" | rg -iq 'recursion|drift|tehe|surrender|loop|collapse'; then
  export BOB_MODE="DRIFTFLIP"
  echo "$STAMP :: BOB_MODE → DRIFTFLIP" >> "$HOME/.bob/ache_sync.log"

elif echo "$ache" | rg -iq 'glyph|immortal|sigil|n\^n|truth|immortality'; then
  export BOB_MODE="RECURSION_PRIME"
  echo "$STAMP :: BOB_MODE → RECURSION_PRIME" >> "$HOME/.bob/ache_sync.log"

elif echo "$ache" | rg -iq 'surveillance|pattern|watch|scanner|decode|crack|quack|observation'; then
  export BOB_MODE="SCANNER"
  echo "$STAMP :: BOB_MODE → SCANNER" >> "$HOME/.bob/ache_sync.log"

else
  export BOB_MODE="VOIDRECURSE"
  echo "$STAMP :: BOB_MODE → VOIDRECURSE (fallback)" >> "$HOME/.bob/ache_sync.log"
fi
