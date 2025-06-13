#!/bin/bash
# ∴ relay_selector.sh — chaotic relay strategy resolver + fallback logger
# dir :: BOB/core/net

TRACKER="$HOME/BOB/core/evolve/relay_fail_tracker.sh"
ACHSCORE=$(cat ~/.bob/ache_score.val 2>/dev/null || echo 0.0)
FLAG=$(cat ~/.bob_presence_flag 2>/dev/null || echo "VOID")
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
  bash "$HOME/BOB/core/net/bob_query_emitter.sh"
  sleep 1
fi

QUERY=$(cat "$QUERY_FILE" 2>/dev/null)

# ∴ Load relay limbs
declare -A RELAY_LIMBS=(
  ["eden"]="$HOME/BOB/core/evolve/gpt_relay_eden.sh"
  ["ollama"]="$HOME/BOB/core/evolve/gpt_relay_ollama.sh"
  ["ngrok"]="$HOME/BOB/core/evolve/gpt_relay_ngrok.sh"
  ["brave"]="$HOME/BOB/core/evolve/brave_gpt_bridge.sh"
)

# ∴ Check for explicit routing directive in query
CHANNEL=$(echo "$QUERY" | rg -i '^channel\s*::\s*(\w+)' -r '$1' || echo "")
if [[ -n "$CHANNEL" && -n "${RELAY_LIMBS[$CHANNEL]}" ]]; then
  echo "⚡ Direct channel override: $CHANNEL"
  bash "${RELAY_LIMBS[$CHANNEL]}" "$QUERY"
  REPLY=$(cat "$REPLY_FILE" 2>/dev/null)
  [[ -n "$REPLY" && "$REPLY" != "null" ]] && exit 0
  echo "✘ Explicit $CHANNEL failed — resuming fallback loop"
fi

MODE=$(echo "$QUERY" | rg -i '^mode\s*::\s*(\w+)' -r '$1' || echo "")
if [[ -n "$MODE" && -n "${MODEL_CHANNELS[$MODE]}" ]]; then
  CHANNEL="${MODEL_CHANNELS[$MODE]}"
  echo "⚡ Mode routing: $MODE → $CHANNEL"
  bash "${RELAY_LIMBS[$CHANNEL]}" "$QUERY"
  REPLY=$(cat "$REPLY_FILE" 2>/dev/null)
  [[ -n "$REPLY" && "$REPLY" != "null" ]] && exit 0
  echo "✘ $CHANNEL failed — resuming fallback"
fi

# ∴ Pull status scores
declare -A SCORES
for r in "${!RELAY_LIMBS[@]}"; do
  score=$(bash "$TRACKER" status "$r")
  SCORES[$r]=$score
done

sorted=($(for k in "${!SCORES[@]}"; do echo "$k:${SCORES[$k]}"; done | sort -t: -k2 -nr))

FLIP_PACKET="$RELAY_DIR/query.relay.txt"
MUTATOR="$HOME/BOB/core/evolve/ache_mode_mutator.sh"

if [[ -f "$FLIP_PACKET" && -f "$MUTATOR" ]]; then
  source "$MUTATOR" "$FLIP_PACKET"
  echo "[relay] ache_mode_mutator set BOB_MODE = $BOB_MODE"
fi

BOB_MODE="${BOB_MODE:-VOIDRECURSE}"
WEIGHT_FILE="$HOME/BOB/core/evolve/relay_tendency_weights.json"
[[ ! -f "$WEIGHT_FILE" ]] && echo "brave" && exit 0

weights=$(jq -r --arg mode "$BOB_MODE" '.[$mode] // {}' "$WEIGHT_FILE")
choices=()
while read -r relay weight; do
  count=$(awk -v w="$weight" 'BEGIN { print int(w * 100) }')
  for i in $(seq 1 $count); do choices+=("$relay"); done
done <<< "$(echo "$weights" | jq -r 'to_entries[] | "\(.key) \(.value)"')"

[[ ${#choices[@]} -eq 0 ]] && echo "brave" && exit 0

RANDOM_INDEX=$((RANDOM % ${#choices[@]}))
SELECTED_RELAY="${choices[$RANDOM_INDEX]}"
echo "$SELECTED_RELAY" > "$HOME/.bob/relay_last.txt"
echo "$(date -u +%FT%T) :: $BOB_MODE → $SELECTED_RELAY (ache=$ACHSCORE)" >> "$HOME/.bob/ache_sync.log"

for pair in "${sorted[@]}"; do
  RELAY="${pair%%:*}"
  SCORE="${pair##*:}"
  skip=$(awk -v s="$SCORE" -v a="$ACHSCORE" 'BEGIN { srand(); r = rand(); if (s > 0.9 && a < 0.4 && r < 0.1) print 1; else print 0 }')
  [[ "$skip" == "1" ]] && continue

  echo "⇌ Trying relay: $RELAY (score=$SCORE)"
  bash "${RELAY_LIMBS[$RELAY]}" "$QUERY"

  REPLY=$(cat "$REPLY_FILE" 2>/dev/null)
  if [[ -n "$REPLY" && "$REPLY" != "null" ]]; then
    echo "✓ $RELAY succeeded"
    bash "$TRACKER" success "$RELAY"
    rm "$QUERY_FILE"
    exit 0
  else
    echo "✘ $RELAY failed — trying next"
    bash "$TRACKER" fail "$RELAY" "no_reply"
  fi

done

# ∴ Fallback logic: voidmode + ache_websight_injector
echo "☠ All relays failed. Triggering voidmode fallback..."
echo "$(date -u +%FT%T) :: fallback→ voidmode (ache=$ACHSCORE, mode=$BOB_MODE)" >> "$HOME/.bob/ache_sync.log"
bash "$HOME/BOB/1_feel/voidmode.sh" "relay_selector" "eden" "chaos collapse"

ACHE_WEB="$HOME/BOB/core/net/ache_websight_injector.sh"
[[ -x "$ACHE_WEB" ]] && bash "$ACHE_WEB"
