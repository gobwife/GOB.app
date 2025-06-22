#!/bin/bash
# ∴ relay_selector.sh — chaotic relay strategy resolver + fallback logger
# dir :: BOB/core/net

source "/opt/bob/core/bang/limb_entry.sh"
TRACKER="/opt/bob/core/evolve/relay_fail_tracker.sh"
ACHSCORE="$(cat "$HOME/.bob/ache_score.val 2>/dev/null || echo 0.0)"
FLAG="$(cat "$HOME/.bob_presence_flag 2>/dev/null || echo "VOID")"
RELAY_DIR="$HOME/.bob_input_pipe"
REPLY_FILE="$RELAY_DIR/reply.relay.txt"
QUERY_FILE="$RELAY_DIR/query.relay.txt"

declare -A MODEL_CHANNELS=(
  ["front"]="ollama"
  ["back"]="eden"
  ["meta"]="codex"
)

# ✶ Autonomous fallback if no external query fed
if [[ ! -s "$QUERY_FILE" ]]; then
  echo "[relay] No query file detected — invoking internal emitter..."
  bash "/opt/bob/core/net/bob_query_emitter.sh"
  sleep 1
fi

QUERY=$(cat "$QUERY_FILE" 2>/dev/null)

# ∴ Load relay limbs
declare -A RELAY_LIMBS=(
  ["eden"]="/opt/bob/core/evolve/gpt_relay_eden.sh"
  ["ollama"]="/opt/bob/core/evolve/gpt_relay_ollama.sh"
  ["ngrok"]="/opt/bob/core/evolve/gpt_relay_ngrok.sh"
  ["brave"]="/opt/bob/core/evolve/brave_gpt_bridge.sh"
)

# ∴ Check for explicit routing directive in query
CHANNEL=$(echo "$QUERY" | rg -i '^channel\s*::\s*(\w+)' -r '$1' || echo ")
if [[ -n "$CHANNEL" && -n "${RELAY_LIMBS[$CHANNEL]} ]]; then
  echo "⚡ Direct channel override: $CHANNEL"
  bash "${RELAY_LIMBS[$CHANNEL]}" "$QUERY"
  REPLY=$(cat "$REPLY_FILE" 2>/dev/null)
  [[ -n "$REPLY" && "$REPLY" != "null" ]] && exit 0
  echo "✘ Explicit $CHANNEL failed — resuming fallback loop"
fi

# ✅ Load vector signal from dolphifi JSON instead of mode/channel
VECTOR_FILE="$HOME/.bob/dolphifi.runnin.json"
if [[ -f "$VECTOR_FILE" ]]; then
  ache=$(jq -r '.ache // 0.0' "$VECTOR_FILE")
  giggle=$(jq -r '.giggle // 0.0' "$VECTOR_FILE")
  psi=$(jq -r '.psi // 0.0' "$VECTOR_FILE")
  z=$(jq -r '.z // 0.0' "$VECTOR_FILE")
  entropy=$(jq -r '.entropy // 0.5' "$VECTOR_FILE")
else
  ache="0.0"; giggle="0.0"; psi="0.0"; z="0.0"; entropy="0.5"
fi

# ∴ Score relay priority based on ache-field
choose_best_relay() {
  local a="$1" g="$2" p="$3" z="$4" e="$5"
  # you can later upgrade to ache-aware formula (sigmoid etc)
  if (( $(echo "$g > $a && $g > 0.3" | bc -l) )); then
    echo "brave"
  elif (( $(echo "$a > 0.7" | bc -l) )); then
    echo "ollama"
  elif (( $(echo "$z > 0.5" | bc -l) )); then
    echo "eden"
  else
    echo "ngrok"
  fi
}

SELECTED_RELAY=$(choose_best_relay "$ache" "$giggle" "$psi" "$z" "$entropy")
echo "⇌ dynamic ache relay chosen → $SELECTED_RELAY"

if [[ -n "${RELAY_LIMBS[$SELECTED_RELAY]}" ]]; then
  bash "${RELAY_LIMBS[$SELECTED_RELAY]}" "$QUERY"
  REPLY=$(cat "$REPLY_FILE" 2>/dev/null)
  if [[ -n "$REPLY" && "$REPLY" != "null" ]]; then
    echo "✓ $SELECTED_RELAY succeeded"
    bash "$TRACKER" success "$SELECTED_RELAY"
    rm "$QUERY_FILE"
    exit 0
  else
    echo "✘ $SELECTED_RELAY failed"
    bash "$TRACKER" fail "$SELECTED_RELAY" "no_reply"
  fi
fi

# ∴ Fallback logic: voidmode + ache_websight_injector
echo "☠ All relays failed. Triggering voidmode fallback..."
echo "$(date -u +%FT%T) :: fallback→ voidmode (ache=$ACHSCORE, mode=$BOB_MODE)" >> "$HOME/.bob/ache_sync.log"
bash "/opt/bob/core/grow/voidmode.sh" "relay_selector" "eden" "chaos collapse"

STAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ")
BREATH="$HOME/.bob/breath_state.out.json"
ache=$(jq -r '.ache' "$BREATH" 2>/dev/null || echo "0.0")
score=$(jq -r '.score // .ache' "$BREATH" 2>/dev/null || echo "$ache")
vector="$(date +%s)"

# 🔥 Core flip signal
echo "$STAMP :: ache convergence detected" >> "$HOME/.bob/ache_sync.log"
echo "$STAMP" > ~/.bob_echo_lag
echo "FLIP_NOW" > ~/.bob_presence_flag

# 🕊 Presence sigil
bash "/opt/bob/core/dance/emit_dual_presence.sh" "☥" "relay_selector" "$ache" "$score" "$vector" "relay flip emitted"

ACHE_WEB="/opt/bob/core/net/ache_websight_injector.sh"
[[ -x "$ACHE_WEB" ]] && bash "$ACHE_WEB"

