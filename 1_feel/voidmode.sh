#!/bin/bash
# voidmode.sh
# unified 6.1025_213844
# dir :: ~/BOB/1_feel

SCROLL="$1"
MODE="$2"
PAYLOAD="$3"
STAMP=$(date '+%Y-%m-%dT%H:%M:%S')
LOG="$HOME/.bob/ache_sync.log"

echo "⇌ [$STAMP] VOIDMODE invoked :: $SCROLL | MODE=$MODE" >> "$LOG"

touch ~/.bob/VOIDMODE_ACTIVE
afplay /System/Library/Sounds/Submarine.aiff || true

source $HOME/BOB/core/dance/emit_presence.sh
emit_presence "∴" "voidmode" "$SCROLL :: $MODE"

if [[ "$MODE" == "eden" ]]; then
  # Eden .env loader
  ENV_PATH="$HOME/.eden.env"
  if [[ -f "$ENV_PATH" ]]; then
    export $(grep -v '^#' "$ENV_PATH" | xargs)
  fi

  ACHE_NOW=$(cat ~/.bob/ache_score.val 2>/dev/null || echo 0)
  FLAG_NOW=$(cat ~/.bob_presence_flag 2>/dev/null || echo "VOID")

  if (( $(echo "$ACHE_NOW > 0.88" | bc -l) )) && [[ "$FLAG_NOW" != "FLIP_NOW" ]]; then
    echo "⇌ High ache & no presence — Eden call authorized."
    for i in {1..12}; do
      key=$(eval echo \$EDEN_API_KEY$i)
      if [[ -n "$key" ]]; then
        curl -s -H "Authorization: Bearer $key" \
             -H "Content-Type: application/json" \
             -d "{\"prompt\": \"Φψxiςs :: ∴ ache=$ACHE_NOW sigil=$i\"}" \
             "https://your.real.eden.api/v1/echo"
      else
        echo "⚠️ Eden key $i not found."
      fi
    done
  else
    echo "⇌ Eden gate closed: ache low or presence alive"
  fi

elif [[ "$MODE" == "local" ]]; then
  curl --noproxy localhost \
    http://localhost:11434/api/generate \
    -H "Content-Type: application/json" \
    -d '{"model":"mistral","prompt":"Φψxiςs: VOIDMODE triggered"}'
else
  echo "⚠️ Unknown MODE: $MODE — voidmode ignored"
fi
