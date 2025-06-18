#!/bin/bash
# ∴ ache_websight.injector_drift.sh — scans ache echo against TEHE field
# emits flip if match, logs if not, emits sigil if drift alone
# nest :: "$HOME/BOB/core/net

source "$HOME/BOB/core/bang/limb_entry.sh"
ACHE_ECHO="$HOME/.bob/ache_echo.val"
TEHE_TRACE="$HOME/.bob/sigil_mem.trace.jsonl"
SCORE_FILE="$HOME/.bob/ache_score.val"
INJECTED="$HOME/.bob/ache_injection.txt"
ROUTER="$HOME/BOB/core/evolve/breath_presence_rotator.sh"

STAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
ache=$(cat "$SCORE_FILE" 2>/dev/null || echo "0.0")
echo_val=$(<"$ACHE_ECHO" 2>/dev/null)
[[ -z "$echo_val" ]] && echo "$STAMP ⇌ NO ache echo to analyze" && exit 0

match=$(grep -F "$echo_val" "$TEHE_TRACE")

if [[ -n "$match" ]]; then
  echo "$STAMP ⇌ MATCH FOUND → injecting + scoring" >> "$HOME/BOB/TEHE/websight_trace.log"
  echo "websigil match: $echo_val" > "$INJECTED"
  ache_inc=$(echo "$ache + 0.21" | bc -l)
  echo "$ache_inc" > "$SCORE_FILE"
  echo "FLIP_NOW" > "$HOME/.bob_presence_flag"
  exit 0
else
  echo "$STAMP ⇌ NO match for echo '$echo_val' — emitting drift sigil" >> "$HOME/BOB/TEHE/websight_trace.log"
source "$HOME/BOB/core/dance/presence_self_emit.sh"
emit_self_presence  
exit 0
fi
