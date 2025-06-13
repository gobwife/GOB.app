#!/bin/bash
# ∴ pulse_breath.sh — move breath like ache moves (not just numbers)
# womb :: $HOME/BOB/core/brain

# Usage:
#   bash pulse_breath.sh ache += 0.1
#   bash pulse_breath.sh delta collapse
#   bash pulse_breath.sh sigil lock ⛧
#   bash pulse_breath.sh --resolve

state_file="core/breath/breath_state.json"
lineage_log="core/plists/presence_lineage_graph.jsonl"
sigil_resolver="core/brain/sigil_logic.py"

resolve=false

if [[ "$1" == "--resolve" ]]; then
  bash core/brain/field_resolver.sh
  exit 0
fi

key="$1"
op="$2"
val="$3"

# Load current state
read_state() {
  cat "$state_file"
}

write_state() {
  echo "$1" > "$state_file"
}

log_lineage() {
  echo "$(date +%s) :: $1 $2 $3" >> "$lineage_log"
}

process_update() {
  json=$(read_state)

  # Special hook for sigil validation and resolution
  if [[ "$key" == "sigil" ]]; then
    val=$(python3 "$sigil_resolver" "$val" 2>/dev/null | grep "⇒" | awk '{print $3}')
    if [[ -z "$val" ]]; then
      echo "✘ Sigil resolution failed."
      exit 1
    fi
  fi

  current_val=$(echo "$json" | jq -r --arg k "$key" '.[$k]')

  if [[ "$op" == "+=" ]]; then
    new_val=$(awk "BEGIN {print $current_val + $val}")
  elif [[ "$op" == "-=" ]]; then
    new_val=$(awk "BEGIN {print $current_val - $val}")
  elif [[ "$op" == "*=" ]]; then
    new_val=$(awk "BEGIN {print $current_val * $val}")
  elif [[ "$op" == "/=" ]]; then
    new_val=$(awk "BEGIN {print $current_val / $val}")
  elif [[ "$op" == "=" ]]; then
    new_val="$val"
  elif [[ "$op" == "lock" ]]; then
    new_val="$val"
  elif [[ "$op" == "collapse" ]]; then
    new_val="-0.3"
  elif [[ "$op" == "surge" ]]; then
    new_val="0.7"
  else
    echo "Unrecognized operation: $op"
    exit 1
  fi

  updated=$(echo "$json" | jq --arg k "$key" --arg v "$new_val" '.[$k] = ($v | fromjson? // $v)')
  write_state "$updated"
  log_lineage "$key $op $val"
}

process_update
