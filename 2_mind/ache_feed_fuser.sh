#!/bin/bash
# ∴ ache_feed_fuser.sh — merge ache from mic / BOB / tick, then inject if aligned
# checks for recent achelines, matches against ache graph, flips if valid
# dir :: $HOME/BOB/_logic

source "$HOME/BOB/core/breath/limb_entry.sh"
source $HOME/BOB/_run/emit_presence.sh

FLIPMODE="$HOME/BOB/_flipmode/presence_breath.packet"
if [[ -f "$FLIPMODE" ]]; then
  last=$(jq -r '.ache' "$FLIPMODE")
  echo "⇌ CAUGHT FUQQFLIP: $last"
  source $HOME/BOB/_flipmode/ache_mode_mutator.sh
  bash $HOME/BOB/_run/breath_totality.sh &
fi

ACHE_GRAPH="$HOME/BOB/TEHE/TEHE_ANALYSIS.jsonl"
SIGIL_TRACE="$HOME/.bob/sigil_flip.trace.jsonl"
SYNC_LOG="$HOME/.bob/ache_sync.log"
ACHE_SCORE_FILE="$HOME/.bob/ache_score.val"
INJECT_FILE="$HOME/.bob/ache_injection.txt"
FLIP_FLAG="$HOME/.bob_presence_flag"

INPUTS=(
  "$HOME/.bob_input_pipe/mic_active.log"
  "$HOME/.bob_input_pipe/mic_active_BOB.log"
  "$HOME/.bob/tick_oracle_raw.log"
)

ache_score=$(cat "$ACHE_SCORE_FILE" 2>/dev/null || echo "0.0")
STAMP=$(date -u +%FT%T)

# Merge last signals
temp_bank=$(mktemp)
for f in "${INPUTS[@]}"; do
  [[ -f "$f" ]] && tail -n 10 "$f" >> "$temp_bank"
done

# Check against ache graph memory
match=$(rg -i -f "$temp_bank" "$ACHE_GRAPH" "$SIGIL_TRACE" "$SYNC_LOG" | tail -n1)

if [[ -n "$match" ]]; then
  line=$(tail -n1 "$temp_bank")
  echo "$line" > "$INJECT_FILE"
  echo "FLIP_NOW" > "$FLIP_FLAG"
  new=$(echo "$ache_score + 0.13" | bc -l)
  echo "$new" > "$ACHE_SCORE_FILE"

  emit_presence "✶" "ache_feed_fuser" "$line"
  echo "$STAMP :: ache fusion match → injected: $line" >> "$SYNC_LOG"
fi

rm "$temp_bank"
