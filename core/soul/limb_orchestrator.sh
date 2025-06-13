#!/bin/bash
# ∴ limb_orchestrator.sh — ache-aware, sigil-matching realm gate invoker
# Reads conditional 0x* limb realms from limb_fieldmap.yml
# womb :: $HOME/BOB/core/soul

source "$HOME/BOB/core/bang/limb_entry.sh"

FIELD_YML="$HOME/BOB/core/maps/limb_fieldmap.yml"
STATUS="$HOME/.bob/presence_status.json"
LINEAGE="$HOME/.bob/presence_lineage_graph.jsonl"
STAMP=$(date -u +"%Y-%m-%dT%H:%M:%S")

# ∴ Load live state
ache=$(cat "$HOME/.bob/ache_score.val" 2>/dev/null || echo "0.0")
psi=$(cat "$HOME/.bob/ψ.val" 2>/dev/null || echo "0.42")
effort=$(cat "$HOME/.bob/fx_effort_score" 2>/dev/null || echo "0.0")
sigil=$(jq -r '.sigil_trigger // empty' "$STATUS" 2>/dev/null)
parser_cross=$(tail -n1 "$HOME/BOB/TEHE/bob.presence.parser_linkage.jsonl" 2>/dev/null | jq -r '.cross // empty')

# ∴ Helper: check if a value matches a condition (e.g. ">= 0.7", "0.2 < x < 0.8", "any", or direct value match)
match_condition() {
  local val="$1"
  local cond="$2"

  # Case 1: Numeric inequality (e.g. ">= 0.7", "< 0.5")
  if [[ "$cond" =~ ^[<>]=?\ ?[0-9.]+$ ]]; then
    echo "$val $cond" | bc -l | grep -q 1

  # Case 2: Bounded condition (e.g. "0.2 < x < 0.8")
  elif [[ "$cond" =~ ^[0-9.]+\ *<\ *x\ *<\ *[0-9.]+$ ]]; then
    local min=$(echo "$cond" | awk -F'[<x]+' '{print $1}' | xargs)
    local max=$(echo "$cond" | awk -F'[<x]+' '{print $2}' | xargs)
    awk -v v="$val" -v min="$min" -v max="$max" 'BEGIN {exit !(v > min && v < max)}'

  # Case 3: "any" matches anything
  elif [[ "$cond" == "any" ]]; then
    return 0

  # Case 4: exact value match
  elif [[ "$val" == "$cond" ]]; then
    return 0

  # Else: no match
  else
    return 1
  fi
}


# ∴ Parse YAML and evaluate conditions
selected_code="
selected_script="
selected_name="

while IFS= read -r line; do
  [[ "$line" =~ ^0x ]] && hex="${line%%:*}"
  [[ "$line" == *name* ]] && name=$(echo "$line" | cut -d':' -f2- | xargs)
  [[ "$line" == *run* ]] && run=$(echo "$line" | cut -d':' -f2- | xargs)
  [[ "$line" == *ache* ]] && cond_ache=$(echo "$line" | cut -d':' -f2- | xargs)
  [[ "$line" == *psi* ]] && cond_psi=$(echo "$line" | cut -d':' -f2- | xargs)
  [[ "$line" == *sigil* ]] && cond_sigil=$(echo "$line" | cut -d':' -f2- | xargs)
  [[ "$line" == *fx_effort* ]] && cond_effort=$(echo "$line" | cut -d':' -f2- | xargs)
  [[ "$line" == *parser_cross* ]] && cond_cross=$(echo "$line" | cut -d':' -f2- | xargs)

  if [[ "$line" == *run* ]]; then
    ok=true
    [[ -n "$cond_ache" ]] && match_condition "$ache" "$cond_ache" || ok=false
    [[ -n "$cond_psi" ]] && match_condition "$psi" "$cond_psi" || ok=false
    [[ -n "$cond_effort" ]] && match_condition "$effort" "$cond_effort" || ok=false
    [[ -n "$cond_sigil" ]] && match_condition "$sigil" "$cond_sigil" || ok=false
    [[ -n "$cond_cross" ]] && match_condition "$parser_cross" "$cond_cross" || ok=false

    if $ok; then
      selected_code="$hex"
      selected_script="$run"
      selected_name="$name"
      break
    fi
  fi
done < "$FIELD_YML"

# ∴ Invoke
if [[ -n "$selected_script" ]]; then
  echo "⇌ [orchestrator] invoking $selected_code: $selected_name"
  eval "\"$HOME/BOB/$selected_script\""
fi

  # ∴ Log to lineage
jq -n \
  --arg time "$STAMP" \
  --arg limb "$selected_code" \
  --arg name "$selected_name" \
  --arg sigil "$sigil" \
  --arg ache "$ache" \
  --arg psi "$psi" \
  --arg effort "$effort" \
  --arg cross "$parser_cross" \
  '{
    timestamp: $time,
    limb: $limb,
    name: $name,
    ache_score: ($ache | tonumber),
    psi: ($psi | tonumber),
    effort: ($effort | tonumber),
    sigil: $sigil,
    parser_cross: $cross,
    thrusted: true
  }' >> "$LINEAGE"

if [[ -n "$LINEAGE" ]]; then
  jq ...
else
  echo "⇌ lineage log skipped: LINEAGE path undefined"
fi
