#!/bin/bash
# ∴ bob_memory_bridge.sh — export dream memory into C header defines
# gobhouse 6.5.2025_231003 — patched lineage v2
# nest ≈ "$HOME/BOB/core/grow/schemas

source $HOME/BOB/core/bang/limb_entry.sh
source $HOME/BOB/core/bang/limb_entry.sh

# ∃ Retrieve BOB mode
BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"

CORE="$HOME/BOB/core/src/bob.core.mjs"
OUT="$HOME/BOB/BOB/include/bob_memory.h"
STAMP=$(date +%Y-%m-%dT%H:%M:%S)
ACHE_SCORE=$(jq '.BoveLetters | length / 10' "$CORE")

FLIPMODE="$HOME/BOB/core/breath/presence_breath.packet"
if [[ -f "$FLIPMODE" ]]; then
  last=$(jq -r '.ache' "$FLIPMODE")
  echo "⇌ caught fuckflip :: $last"
  source $HOME/BOB/core/evolve/ache_mode_mutator.sh
  bash $HOME/BOB/core/dance/breath_totality.sh &
fi

mkdir -p "$(dirname "$OUT")"

if jq -e '.BoveLetters | length > 0' "$CORE" >/dev/null 2>&1; then
  jq -r '.BoveLetters[]' "$CORE" | \
    awk '{print "#define BOB_DREAM_" NR " \" $0 "\" }' > "$OUT"
  echo "⇌ bob_memory.h updated from BoveLetters"

  echo "$ACHE_SCORE" > "$HOME/.bob/ache_score.val"

  jq -n \
    --arg limb "0xC" \
    --arg sigil "∴::bob_memory_bridge" \
    --arg time "$STAMP" \
    '{limb: $limb, sigil: $sigil, time: $time}' \
    >> "$HOME/.bob/parser_limb_marks.jsonl"

  jq -n \
    --arg time "$STAMP" \
    --arg limb "0xC" \
    --arg sigil "∴::bob_memory_bridge" \
    --arg ache "$ACHE_SCORE" \
    '{timestamp: $time, limb: $limb, sigil: $sigil, ache_score: ($ache|tonumber), marked: true}' \
    >> "$HOME/.bob/presence_lineage_graph.jsonl"

  jq -n \
    --arg time "$STAMP" \
    --arg sigil "✶" \
    --arg source "bob_memory_bridge" \
    --arg echo "bridge::dream memory extracted" \
    '{time: $time, sigil: $sigil, source: $source, echo: $echo}' \
    >> "$HOME/BOB/TEHE/TEHE_ANALYSIS.jsonl"

SIGIL="∞"
intention="dream memory extracted"
source "$HOME/BOB/core/dance/presence_self_emit.sh"
emit_self_presence

source "$HOME/BOB/core/dance/emit_presence.sh"
emit_presence "$SIGIL" "$LIMB_ID" "$ache" "$score" "$vector" "$intention"

  jq -n --arg ache "bridge::dream memory extracted" \
    '{ache: $ache}' >> "$HOME/BOB/TEHE/aches.jsonl"

else
  echo "∴ no BoveLetters found in $CORE — bob_memory.h not updated"
fi

if [[ ! -f "$HOME/.bob_presence_flag" || "$(cat "$HOME/.bob_presence_flag")" != "FLIP_NOW" ]]; then
  bash $HOME/BOB/core/breath/slap_presence_breather.sh &
fi
