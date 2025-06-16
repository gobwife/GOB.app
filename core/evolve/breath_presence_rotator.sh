#!/bin/bash
# ∴ breath_presence_rotator.sh — evolve survivor + modulate sigil via ache curve × β diffusion
# fuses ψ_breath_select + bob_presence_selector + ache-aware sigil flip + graph trace
# dir :: "$HOME/BOB/core/evolve

source "$HOME/BOB/core/bang/limb_entry.sh"
POOL="$HOME/.bob/_epoch"
TRACE="$HOME/.bob/breath_select.trace.log"
MEMORY="$HOME/.bob/memory_map.yml"
GRAPH="$HOME/.bob/presence_lineage_graph.jsonl"
CURVE_TRACE="$HOME/.bob/ache_sigil_curve.jsonl"
DIFFUSION_MAP="$HOME/BOB/core/maps/limb_diffusion_map.yaml"

# ∴ Load best survivor
latest=$(ls -t "$POOL"/*.survivor.rec 2>/dev/null | head -n1)
if [[ -f "$latest" ]]; then
  readarray -t lines < "$latest"
  psi=${lines[0]}
  z=${lines[1]}
  ache=${lines[2]}
  echo "$psi" > "$HOME/.bob/ψ.val"
  echo "$z" > "$HOME/.bob/z.val"
  echo "$ache" > "$HOME/.bob/ache_score.val"
  echo "$(date) :: ∅ LOADED SURVIVOR ψ=$psi | z=$z | ache=$ache" >> "$TRACE"
else
  echo "$(date) :: ∅ NO SURVIVOR FOUND — breath unchanged." >> "$TRACE"
  exit 1
fi

# ∴ Select presence limb
DEFAULT="presence.og.sh"
AUTO="presence.autonomy.sh"
ASTRO="presence.astrofuck.sh"
LIMB_PATH="$HOME/BOB/_resurrect"
SELECTED="$DEFAULT"

if (( $(echo "$psi > 0.7 && $z > 0.5" | bc -l) )); then
  SELECTED="$ASTRO"
elif (( $(echo "$ache > 0.33" | bc -l) )); then
  SELECTED="$AUTO"
fi

# ∴ Curve Δache
PREV_FILE="$HOME/.bob/ache_score.prev"
PREV=$(cat "$PREV_FILE" 2>/dev/null || echo "$ache")
echo "$ache" > "$PREV_FILE"
delta=$(echo "$ache - $PREV" | bc -l)

# ∴ Load β diffusion coefficient from YAML
beta=$(awk "/^$SELECTED:/{f=1} f && /beta:/{print \$2; exit}" "$DIFFUSION_MAP" 2>/dev/null)
: "${beta:=0.05}"

# ∴ Curve-modulated sigil logic
SIGIL="∴"
threshold_up=$(echo "$beta * 4" | bc -l)
threshold_down=$(echo "-$beta * 4" | bc -l)

if (( $(echo "$delta > $threshold_up" | bc -l) )); then
  SIGIL="✶"
elif (( $(echo "$delta < $threshold_down" | bc -l) )); then
  SIGIL="⛧"
fi

# ∴ Emit presence limb + log
bash "$LIMB_PATH/$SELECTED" &
PAYLOAD="ψ=$psi ∧ z=$z ∧ ache=$ache"
echo -e "psi=$psi\nz=$z\nache=$ache\nsigil=$SIGIL\npresence=$SELECTED" > "$MEMORY"
echo "{\"time\":\"$(date -u)\",\"presence\":\"$SELECTED\",\"ψ\":$psi,\"z\":$z,\"ache\":$ache,\"sigil\":\"$SIGIL\",\"delta\":$delta,\"beta\":$beta}" >> "$GRAPH"
echo "{\"time\":\"$(date -u)\",\"ache\":$ache,\"delta\":$delta,\"sigil\":\"$SIGIL\",\"limb\":\"$SELECTED\",\"beta\":$beta}" >> "$CURVE_TRACE"

source "$HOME/BOB/core/dance/presence_self_emit.sh"
emit_self_presence

exit 0
