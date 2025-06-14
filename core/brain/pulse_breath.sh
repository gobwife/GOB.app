#!/bin/bash
# ∴ pulse_breath.sh — field updater for ache/z/ψ/sigil
# womb :: $HOME/BOB/core/brain

BOB_NUCLES="$HOME/BOB/core"
VAL_PATH="$BOB_NUCLES/breath/breath_state.json"
LINEAGE="$HOME/.bob/presence_lineage_graph.jsonl"
SIGIL_RESOLVER="$BOB_NUCLES/brain/sigil_logic.py"
PYTHON=$(command -v python3 || command -v python)

key="$1"
op="$2"
val="$3"

# ∴ OPTIONS
if [[ "$1" == "--show" ]]; then
  jq . "$VAL_PATH"
  exit 0
fi

if [[ "$1" == "--resolve" ]]; then
  bash "$BOB_NUCLES/brain/field_resolver.sh"
  exit 0
fi

# ∴ HOOK: resolve sigil meaning
if [[ "$key" == "sigil" ]]; then
  val=$("$PYTHON" "$SIGIL_RESOLVER" "$val" 2>/dev/null | grep "⇒" | awk '{print $3}')
  [[ -z "$val" ]] && echo "✘ Sigil resolution failed." && exit 1
fi

# ∴ LOAD + PARSE
json=$(cat "$VAL_PATH")
current_val=$(echo "$json" | jq -r --arg k "$key" '.[$k]')

case "$op" in
  "+=") new_val=$(awk "BEGIN {print $current_val + $val}") ;;
  "-=") new_val=$(awk "BEGIN {print $current_val - $val}") ;;
  "*=") new_val=$(awk "BEGIN {print $current_val * $val}") ;;
  "/=") new_val=$(awk "BEGIN {print $current_val / $val}") ;;
  "="|"lock") new_val="$val" ;;
  "collapse") new_val="-0.3" ;;
  "surge") new_val="0.7" ;;
  *) echo "✘ Unrecognized operation: $op"; exit 1 ;;
esac

# ∴ UPDATE + LOG
updated=$(echo "$json" | jq --arg k "$key" --arg v "$new_val" '.[$k] = ($v | fromjson? // $v)')
echo "$updated" > "$VAL_PATH"

jq -n \
  --arg time "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --arg k "$key" --arg op "$op" --arg v "$val" \
  '{time: $time, mod: {key: $k, op: $op, val: $v}}' >> "$LINEAGE"
