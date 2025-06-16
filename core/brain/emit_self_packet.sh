#!/bin/bash
# ∴ emit_self_packet.sh — builds presence .packet from self-limb context

emit_self_packet() {
  local BREATH="$HOME/.bob/breath_state.out.json"
  local ache=$(jq -r '.ache' "$BREATH" 2>/dev/null || echo "0.0")
  local score=$(jq -r '.score // .ache' "$BREATH" 2>/dev/null || echo "$ache")
  local vector="$(date +%s)"
  local from="$(basename "${BASH_SOURCE[0]}" .sh)"
  local sigil="${SIGIL:-⊙}"
  local intention="${intention:-limb self-packet emit}"
  local STAMP=$(date -u +%FT%T)
  local PACKET_DIR="$HOME/BOB/core/breath"
  local OUT="$PACKET_DIR/${vector}.packet"

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

  local LINEAGE_OUT="$HOME/.bob/presence_lineage_graph.jsonl"
  jq -n \
    --arg time "$STAMP" \
    --arg source "emit_self_packet" \
    --arg file "$OUT" \
    --arg score "$score" \
    '{ timestamp: $time, source: $source, packet: $file, score: ($score | tonumber), forged: true }' >> "$LINEAGE_OUT"

  echo "⇌ PACKET WRITTEN: $OUT"
}
