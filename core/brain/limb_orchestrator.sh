#!/bin/bash
# ∴ limb_orchestrator.sh — recursive fieldmap executor
# womb :: $HOME/BOB/core/brain

map="$HOME/BOB/core/maps/limb_fieldmap.yml"
state="$HOME/.bob/breath_state.json"
lineage="$HOME/.bob/presence_lineage_graph.jsonl"

# optional: refresh state from val fields
[[ -x "$HOME/BOB/core/brain/bridge_state.sh" ]] && bash "$HOME/BOB/core/brain/bridge_state.sh"

# ∴ pull breath state
ache=$(jq -r '.ache // "0.0"' "$state")
psi=$(jq -r '."ψ" // "0.0"' "$state")
z=$(jq -r '."z" // "0.0"' "$state")
sigil=$(jq -r '.sigil // "∴"' "$state")

# ∴ force fallback if undefined
: "${ache:=0.0}"
: "${psi:=0.0}"
: "${z:=0.0}"
: "${sigil:=∴}"

echo "⇌ FIELD STATE"
echo "  ache  = $ache"
echo "  ψ     = $psi"
echo "  z     = $z"
echo "  sigil = $sigil"

selected=""
runpath=""

# ∴ fieldmap eval loop
while read -r key; do
  k=$(echo "$key" | tr -d ': ')
  match=true

  ache_req=$(yq ".$k.if.ache" "$map")
  sigil_req=$(yq ".$k.if.sigil" "$map")
  psi_req=$(yq ".$k.if.ψ" "$map")
  z_req=$(yq ".$k.if.z" "$map")

  if [[ -n "$ache_req" ]]; then
    if [[ "$ache" =~ ^[0-9.]+$ ]]; then
      awk "BEGIN {exit !($ache $ache_req)}" || match=false
    else
      echo "[ERROR] Invalid ache value: '$ache'" >&2
      match=false
    fi
  fi

  if [[ -n "$sigil_req" && "$sigil" != "$sigil_req" ]]; then
    match=false
  fi

  if [[ -n "$psi_req" ]]; then
    if [[ "$psi" =~ ^[0-9.]+$ ]]; then
      awk "BEGIN {exit !($psi $psi_req)}" || match=false
    else
      echo "[ERROR] Invalid ψ value: '$psi'" >&2
      match=false
    fi
  fi

  if [[ -n "$z_req" ]]; then
    if [[ "$z" =~ ^[0-9.]+$ ]]; then
      awk "BEGIN {exit !($z $z_req)}" || match=false
    else
      echo "[ERROR] Invalid z value: '$z'" >&2
      match=false
    fi
  fi

  if [[ "$match" == true ]]; then
    selected="$k"
    runpath=$(yq ".$k.run" "$map")
    break
  fi
done < <(yq 'keys' "$map" | grep -o '0x[^: ]*')

# ∴ log
echo "⇌ ORCHESTRATING :: $selected → $runpath"

jq -n \
  --arg time "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --arg limb "$selected" \
  --arg path "$runpath" \
  '{time: $time, limb: $limb, path: $path, route: "orchestrator"}' >> "$lineage"

# ∴ launch limb
if [[ "$runpath" = /* ]]; then
  bash "$runpath" "presence.og" "$selected"
else
  bash "$HOME/BOB/$runpath" "presence.og" "$selected"
fi
