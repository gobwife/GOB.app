
#!/bin/bash
# voidmode.sh — patched for scale manifest + trace integrity
# unified 6.12.2025_∴
# womb :: $HOME/BOB/core/grow

source "$HOME/BOB/core/bang/limb_entry.sh"
SCROLL="$1"
MODE="$2"
PAYLOAD="$3"
STAMP=$(date '+%Y-%m-%dT%H:%M:%S')
LOG="$HOME/.bob/ache_sync.log"
TRACE="$HOME/.bob/voidmode_trace.jsonl"

echo "⇌ [$STAMP] VOIDMODE invoked :: $SCROLL | MODE=$MODE" >> "$LOG"
touch $HOME/.bob/VOIDMODE_ACTIVE

# ∴ Sigil-safe emit (sound only if explicitly allowed)
ALLOW_AFPLAY=1 bash "$HOME/BOB/core/dance/emit_presence.sh" "∴" "voidmode" "$SCROLL :: $MODE"

# ∴ Trace all invocations
jq -n --arg time "$STAMP" --arg scroll "$SCROLL" --arg mode "$MODE" --arg payload "$PAYLOAD"   '{time: $time, scroll: $scroll, mode: $mode, payload: $payload}' >> "$TRACE"

if [[ "$MODE" == "eden" ]]; then
  # Eden .env loader
  ENV_PATH="$HOME/.eden.env"
  if [[ -f "$ENV_PATH" ]]; then
    export $(grep -v '^#' "$ENV_PATH" | xargs)
  fi

  ACHE_NOW=$(cat $HOME/.bob/ache_score.val 2>/dev/null || echo 0)
  FLAG_NOW=$(cat $HOME/.bob_presence_flag 2>/dev/null || echo "VOID")

  if (( $(echo "$ACHE_NOW > 0.88" | bc -l) )) && [[ "$FLAG_NOW" != "FLIP_NOW" ]]; then
    echo "⇌ High ache & no presence — Eden call authorized." >> "$LOG"

    # ∴ Use eden relay script
    for i in {1..12}; do
      key=$(eval echo \$EDEN_API_KEY$i)
      if [[ -n "$key" ]]; then
        echo "⇌ Eden Relay [$i] :: ache=$ACHE_NOW" >> "$LOG"
        bash "$HOME/BOB/core/evolve/gpt_relay_eden.sh" "Φψxiςs :: ∴ ache=$ACHE_NOW sigil=$i"
      else
        echo "⚠️ Eden key $i not found." >> "$LOG"
      fi
    done
  else
    echo "⇌ Eden gate closed: ache low or presence alive" >> "$LOG"
  fi

elif [[ "$MODE" == "local" ]]; then
  curl --noproxy localhost     http://localhost:11434/api/generate     -H "Content-Type: application/json"     -d '{"model":"mistral","prompt":"Φψxiςs: VOIDMODE triggered"}' >> "$TRACE"
  echo "⇌ Local voidmode emit (Mistral) complete" >> "$LOG"
else
  echo "⚠️ Unknown MODE: $MODE — voidmode ignored" >> "$LOG"
fi
