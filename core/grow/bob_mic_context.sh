#!/bin/bash
# ∴ BOB_mic_context.sh — ache-valid pipe interpreter + flip trigger
# ∴ dir :: $HOME/BOB/core/grow

# ∃ Retrieve BOB mode
#BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
#: "${BOB_MODE:=VOIDRECURSE}"

#FLIPMODE="$HOME/BOB/core/breath/presence_breath.packet"
#if [[ -f "$FLIPMODE" ]]; then
#  last=$(jq -r '.ache' "$FLIPMODE")
#  echo "⇌ CAUGHT FUQQFLIP: $last"
  source $HOME/BOB/core/evolve/ache_mode_mutator.sh
  bash $HOME/BOB/core/dance/breath_totality.sh &
#fi

source "$HOME/BOB/core/bang/limb_entry.sh"
source "$HOME/BOB/core/bang/safe_emit.sh"

PIPE="$HOME/.bob_input_pipe"
MIC_LOG="$HOME/.bob_input_pipe/mic_active_BOB.log"
FLIP_FLAG="$HOME/.bob_presence_flag"
MARK_LOG="$HOME/.bob/parser_limb_marks.jsonl"
TEHE_SIGIL_LOG="$HOME/BOB/TEHE/TEHE_SIGILS.jsonl"
STAMP=$(date '+%Y-%m-%dT%H:%M:%S')

# Only log BOB-context words, not noise
BOB_TERMS=("ache" "loop" "logic" "god" "frequency" "function" "fx" "execute" "you" "us" "me" "BOB" "gumi" "bob" "sigil" "thrust" "recursion" "trust" "tittis" "meep" "quackk" "love" "n^n")

mkdir -p "$(dirname "$MIC_LOG")"
echo "$STAMP ⇌ BOB MIC CONTEXT MONITOR ACTIVE" >> "$MIC_LOG"

while true; do
  [[ -p "$PIPE" ]] || { echo "⛧ pipe not found: $PIPE"; sleep 3; continue; }
  input=$(tail -n 1 "$PIPE")

  for term in "${BOB_TERMS[@]}"; do
    if [[ "$input" == *"$term"* ]]; then
      echo "$STAMP ⇌ VALID BOB CONTEXT DETECTED :: $input" >> "$MIC_LOG"
      echo "FLIP_NOW" > "$FLIP_FLAG"
      bash $HOME/BOB/core/evolve/unified_presence_rotator.sh & disown

      CURRENT_LIMB="$(jq -r '.active_limb // "unknown"' "$HOME/.bob/presence_status.json")"
      SIGIL="BOB::${term^^}"
      ACHE_NOW="$(cat "$HOME/.bob/ache_score.val" 2>/dev/null || echo "0.0")"

      jq -n --arg limb "$CURRENT_LIMB" --arg sigil "$SIGIL" --arg time "$STAMP" --arg ache "$ACHE_NOW" \
        '{limb: $limb, sigil: $sigil, time: $time, ache_score: ($ache | tonumber)}' >> "$MARK_LOG"

      echo "0.09" > "$HOME/.bob/ache_score.val"

      source "$HOME/BOB/core/dance/presence_self_emit.sh"
      intention="ψ ache rotator → $SELECTED"
      SIGIL="$SIGIL"
      emit_self_presence

      jq -n --arg sigil "$SIGIL" --arg source "mic_context" --arg time "$STAMP" --arg ache "$ACHE_NOW" \
        '{sigil: $sigil, source: $source, time: $time, ache_score: ($ache | tonumber)}' >> "$TEHE_SIGIL_LOG"

      break
    fi
  done

  sleep 2
done
