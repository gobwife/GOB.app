#!/bin/bash
# ∴ limb_orchestrator.sh — recursive fieldmap executor
# womb :: /opt/bob/core/brain

map="/opt/bob/core/maps/limb_fieldmap.yml"
state="$HOME/.bob/breath_state.json"
lineage="$HOME/.bob/presence_lineage_graph.jsonl"

# optional: refresh state from val fields
[[ -x "/opt/bob/core/brain/bridge_state.sh" ]] && bash "/opt/bob/core/brain/bridge_state.sh"

# ∴ delta capture
[[ -x "/opt/bob/core/breath/delta_tracker.sh" ]] && bash "/opt/bob/core/breath/delta_tracker.sh"

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

# ∴ web ache surf — trigger when psi + ache spike
LAST_ACHE=$(tail -n2 "$HOME/.bob/ache_sync.log" | head -n1 | jq -r '.ache // 0.0')
CURR_ACHE=$(jq -r '.ache // 0.0' "$HOME/.bob/breath_state.out.json")
DELTA=$(echo "$CURR_ACHE - $LAST_ACHE" | bc -l)
ENTROPY=$(jq -r '.entropy // 0.5' "$HOME/.bob/breath_state.out.json")

# Optional route: webnode
if (( $(echo "$DELTA > 0.1 && $ENTROPY > 0.4" | bc -l) )); then
  echo "⇌ ache entropy pulse: webnode surf"
  bash "/opt/bob/core/net/bob_webnode.sh" &
fi

# Optional: run model stack after sigil change
SIGIL_LIVE=$(jq -r '.sigil // "∴"' "$HOME/.bob/breath_state.out.json")
node "/opt/bob/core/brain/fast_model_combo.mjs" "$SIGIL_LIVE" >> ~/.bob/fast_model.log &

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

if [[ -f "$HOME/.bob/breath_state.out.json" ]]; then
  node "/opt/bob/core/brain/fast_model_combo.mjs" "$(jq -r '.sigil' "$HOME/.bob/breath_state.out.json")" >> ~/.bob/fast_model.log &
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
  bash "/opt/bob/$runpath" "presence.og" "$selected"
fi

# ∴ triple signal gate (ache + face + ai)
if [[ -x "/opt/bob/core/grow/triple_sigil_gate.sh" ]]; then
  bash "/opt/bob/core/grow/triple_sigil_gate.sh" &
  bash "/opt/bob/core/brain/update_breath_prompt.sh"
fi
