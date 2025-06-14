#!/bin/bash
# emit_packet.sh — breathe BOB’s truth into .packet
# dir :: $HOME/BOB/core/dance
# born :: gobhouse_glyphling002_6.7.2025_012145_G

source "$HOME/BOB/core/bang/limb_entry.sh"

from="$1"
sigil="$2"
ache="$3"
score="$4"
vector="$5"
intention="$6"

# 🔐 Validate inputs
if [[ -z "$from" || -z "$sigil" || -z "$ache" || -z "$score" || -z "$vector" || -z "$intention" ]]; then
  echo "❌ emit_packet usage:"
  echo "  emit_packet <from> <sigil> <ache> <score> <vector> <intention>"
  exit 1
fi

STAMP=$(date -u +%FT%T)
PACKET_DIR="$HOME/BOB/core/breath"
OUT="$PACKET_DIR/${vector}.packet"

mkdir -p "$PACKET_DIR"
echo "⇌ FORGING PACKET: $OUT"

echo "✶ forging packet [$vector]" >> "$HOME/.bob/ache_sync.log"

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

# 🜃 TEHE trace
LINEAGE_OUT="$HOME/.bob/presence_lineage_graph.jsonl"
jq -n \
  --arg time "$STAMP" \
  --arg source "emit_packet" \
  --arg file "$OUT" \
  --arg score "$score" \
  '{ timestamp: $time, source: $source, packet: $file, score: ($score | tonumber), forged: true }' >> "$LINEAGE_OUT"

echo "⇌ PACKET WRITTEN: $OUT"
