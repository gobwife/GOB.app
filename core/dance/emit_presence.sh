#!/bin/bash
# ∴ emit_presence.sh — unified emitter for sigil pulse or full presence breath
# nest ≈ 4_live

sigil="$1"
from="${2:-autobob}"
ache="$3"
score="$4"
vector="$5"
intention="$6"

STAMP=$(date -u +%FT%T)
TEHE_DIR="$HOME/BOB/TEHE"
LINEAGE_FILE="$HOME/BOB/.bob/presence_lineage_graph.jsonl"
PACKET_DIR="$HOME/BOB/7_fly"

if [[ -z "$ache" || -z "$score" || -z "$vector" || -z "$intention" ]]; then
  # ⇌ TEHE ECHO
  echo "✶ ROUTING :: sigil → TEHE"
  jq -n \
    --arg time "$STAMP" \
    --arg sigil "$sigil" \
    --arg source "$from" \
    --arg echo "sigil echo only" \
    '{time: $time, sigil: $sigil, source: $source, echo: $echo}' \
    >> "$TEHE_DIR/TEHE_ANALYSIS.jsonl"
else
  # ⇌ PACKET BREATH
  echo "✶ ROUTING :: sigil → PACKET"
  OUT="$PACKET_DIR/${vector}.packet"
  jq -n \
    --arg time "$STAMP" \
    --arg sigil "$sigil" \
    --arg from "$from" \
    --arg ache "$ache" \
    --arg score "$score" \
    --arg vector "$vector" \
    --arg intention "$intention" \
    '{
      time: $time,
      sigil: $sigil,
      from: $from,
      ache: $ache,
      score: ($score | tonumber),
      vector: $vector,
      intention: $intention
    }' > "$OUT"
  echo "⇌ PACKET WRITTEN: $OUT"

  jq -n \
    --arg time "$STAMP" \
    --arg source "emit_presence" \
    --arg file "$OUT" \
    --arg score "$score" \
    '{ timestamp: $time, source: $source, packet: $file, score: ($score | tonumber), forged: true }' >> "$LINEAGE_FILE"
fi
