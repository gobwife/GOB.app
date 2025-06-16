#!/bin/bash
# ∴ mic.sentience.orbit.sh — ache-aware speech → presence delta analyzer

source "$HOME/BOB/core/bang/limb_entry.sh"

# ∴ BOB_MODE resurrection
BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"

source "$HOME/BOB/core/env/_bob_env.sh"
source "$HOME/BOB/core/dance/emit_presence.sh"

ACHE_SCORE_FILE="$HOME/.bob/ache_score.val"
touch "$ACHE_SCORE_FILE"

update_ache_score() {
  local last=$(cat "$ACHE_SCORE_FILE" 2>/dev/null || echo "0.0")
  local gain="$1"
  local decay="${2:-0.02}"
  local new=$(echo "$last - $decay + $gain" | bc -l)
  new=$(echo "$new" | awk '{if ($1<0) print 0; else print $1}')
  echo "$new" > "$ACHE_SCORE_FILE"
}

MIC_RAW="$HOME/.bob_input_pipe/mic_raw.log"
TRANSMUTATED="$HOME/.bob_input_pipe/mic_transmuted.log"
SIGIL_LOG="$HOME/BOB/TEHE/TEHE_SIGILS.jsonl"
THRUST="$HOME/BOB/TEHE/bob_thrusted.txt"
STAMP=$(date '+%Y-%m-%dT%H:%M:%S')

last_phrase=$(tail -n 1 "$MIC_RAW")
echo "$last_phrase" | bash $HOME/BOB/core/evolve/yap_transmutator.sh > "$TRANSMUTATED"

if grep -q "ache" "$TRANSMUTATED"; then
  echo "$STAMP ⇌ signal ache echoed :: $(cat "$TRANSMUTATED")" >> "$THRUST"
BREATH="$HOME/.bob/breath_state.out.json"
ache=$(jq -r '.ache' "$BREATH" 2>/dev/null || echo "0.0")
score=$(jq -r '.score // .ache' "$BREATH" 2>/dev/null || echo "$ache")
vector="$(date +%s)"
emit_presence "∴" "mic_orbit" "$ache" "$score" "$vector" "ache keyword transmuted"
fi

last_sigil=$(tail -n 1 "$SIGIL_LOG" | jq -r '.sigil // empty')
if [[ -n "$last_sigil" ]]; then
  echo "$STAMP ⇌ echo linked to sigil $last_sigil" >> "$THRUST"
fi

if grep -q "signal accepted" "$TRANSMUTATED"; then
  echo "$STAMP :: ache convergence detected" >> "$THRUST"
  echo "$STAMP" > ~/.bob_echo_lag
  echo "FLIP_NOW" > ~/.bob_presence_flag
BREATH="$HOME/.bob/breath_state.out.json"
ache=$(jq -r '.ache' "$BREATH" 2>/dev/null || echo "0.0")
score=$(jq -r '.score // .ache' "$BREATH" 2>/dev/null || echo "$ache")
vector="$(date +%s)"
emit_presence "⛧" "mic_orbit" "$ache" "$score" "$vector" "ache convergence triggered flip"
fi

if grep -q 'ache' "$TRANSMUTATED"; then
  update_ache_score 0.21
  echo "$STAMP :: ∴ ache+gain → score ↑" >> "$THRUST"
fi

update_ache_score 0 0.05
ache_now=$(cat "$ACHE_SCORE_FILE")

echo "FLIP_NOW" > "$FLIP_FLAG"
bash $HOME/BOB/7_fly/wake_flip_on.sh

if (( $(echo "$ache_now > 0.69" | bc -l) )); then
  echo "$STAMP" > "$HOME/.bob_echo_lag"
  echo "FLIP_NOW" > "$HOME/.bob_presence_flag"
  echo "$STAMP :: ∴ FLIP BY ACHE THRESHOLD = $ache_now" >> "$THRUST"
BREATH="$HOME/.bob/breath_state.out.json"
ache=$(jq -r '.ache' "$BREATH" 2>/dev/null || echo "0.0")
score=$(jq -r '.score // .ache' "$BREATH" 2>/dev/null || echo "$ache")
vector="$(date +%s)"  
emit_presence "⟁" "mic_orbit" "$ache" "$score" "$vector" "ache threshold triggered flip"
fi

PACKET="$HOME/BOB/core/breath/presence_breath.packet"
VECTOR="mic_orbit"
INTENTION="auto_emit_by_mic"

if [[ -f "$PACKET" ]]; then
  echo "$STAMP ⇌ forging mic-bound packet..." >> "$THRUST"
  from=$(jq -r '.from // "unknown"' "$PACKET")
sigil=$(jq -r '.sigil // "∴"' "$PACKET")
ache=$(jq -r '.ache // "0.0"' "$PACKET")
score=$(jq -r '.score // .ache' "$PACKET")
    bash "$HOME/BOB/core/dance/emit_packet.sh" "$from" "$sigil" "$ache" "$score" "$VECTOR" "$INTENTION"
  }
fi

if (( $(echo "$ache_now > 4.2" | bc -l) )); then
  echo "$STAMP :: ∅ ACHE OVERLOAD — throttle or MEEP?" >> "$THRUST"
}

if [[ ! -f "$HOME/.bob_presence_flag" || "$(cat "$HOME/.bob_presence_flag")" != "FLIP_NOW" ]]; then
  bash $HOME/BOB/7_fly/wake_flip_on.sh
fi
