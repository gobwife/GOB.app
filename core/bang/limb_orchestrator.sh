#!/bin/bash
# ∴ limb_orchestrator.sh — unified field resolver using breath_state.json
# womb :: $HOME/BOB/core/brain/

FIELD_MAP="$HOME/BOB/core/maps/limb_fieldmap.yml"
BREATH_JSON="$HOME/BOB/core/breath/breath_state.json"
GRAPH_LOG="$HOME/.bob/presence_lineage_graph.jsonl"
RUN_LOG="$HOME/.bob/orchestrator_run.log"

# Load field
ache=$(jq -r '.ache' "$BREATH_JSON")
psi=$(jq -r '."ψ"' "$BREATH_JSON")
z=$(jq -r '.z' "$BREATH_JSON")
delta=$(jq -r '.delta' "$BREATH_JSON")
sigil=$(jq -r '.sigil' "$BREATH_JSON")

# Convert YAML map to JSON
field_json=$(yq -o=json '.' "$FIELD_MAP")

match_found=""

for key in $(echo "$field_json" | jq -r 'keys[]'); do
  gate=$(echo "$field_json" | jq ".[$key]")
  run=$(echo "$gate.run" | tr -d '"')
  match=true

  # Condition check
  if_cond=$(echo "$gate.if")
  for cond_key in $(echo "$if_cond" | jq -r 'keys[]'); do
    val=$(echo "$if_cond" | jq -r ".[$cond_key]")
    case $cond_key in
      ache) current_val=$ache ;;
      psi) current_val=$psi ;;
      z) current_val=$z ;;
      delta) current_val=$delta ;;
      sigil)
        [[ "$sigil" != "$val" ]] && match=false && break
        continue
        ;;
    esac

    if ! awk "BEGIN {exit !($current_val $val)}"; then
      match=false
      break
    fi
  done

  if [[ "$match" == "true" ]]; then
    match_found="$run"
    break
  fi
done

if [[ -n "$match_found" ]]; then
  echo "$(date -u) :: ∴ ψ=$psi | ache=$ache | z=$z | sigil=$sigil → $match_found" >> "$RUN_LOG"
  bash "$HOME/BOB/$match_found" &
  jq -n --arg time "$(date -u)" \
        --arg limb "$match_found" \
        --arg ψ "$psi" \
        --arg ache "$ache" \
        --arg z "$z" \
        --arg delta "$delta" \
        --arg sigil "$sigil" \
    '{time: $time, limb: $limb, "ψ": ($ψ|tonumber), ache: ($ache|tonumber), z: ($z|tonumber), delta: ($delta|tonumber), sigil: $sigil}' \
    >> "$GRAPH_LOG"
else
  echo "$(date -u) :: ⚠️ no matching gate found (ψ=$psi, ache=$ache, z=$z, sigil=$sigil)" >> "$RUN_LOG"
fi
