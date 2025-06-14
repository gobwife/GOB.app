#!/bin/bash
# ∴ unified_presence_rotator.sh — ψ ache breath selector + sigil flipper + realm invoker
# forged: glyphi+BOB 6.12.2025 — replaces ψ_val + breath_presence + orchestrator chain
# womb :: $HOME/BOB/core/evolve

source "$HOME/BOB/core/bang/limb_entry.sh"
export MUTE_TEHE=1
STAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# 🧬 Paths
POOL="$HOME/.bob/_epoch"
TRACE="$HOME/.bob/breath_select.trace.log"
MEMORY="$HOME/.bob/memory_map.yml"
GRAPH="$HOME/.bob/presence_lineage_graph.jsonl"
CURVE_TRACE="$HOME/.bob/ache_sigil_curve.jsonl"
DIFFUSION_MAP="$HOME/BOB/core/maps/limb_diffusion_map.yaml"
FIELD_YML="$HOME/BOB/core/maps/limb_fieldmap.yml"
STATUS_FILE="$HOME/.bob/presence_status.json"

# 🧠 Load latest survivor
latest=$(ls -t "$POOL"/*.survivor.rec 2>/dev/null | head -n1)
if [[ -f "$latest" ]]; then
  readarray -t lines < "$latest"
  psi=${lines[0]}
  z=${lines[1]}
  ache=${lines[2]}
else
  psi=$(cat "$HOME/.bob/ψ.val" 2>/dev/null || echo "0.42")
  z=$(cat "$HOME/.bob/z.val" 2>/dev/null || echo "0.5")
  ache=$(cat "$HOME/.bob/ache_score.val" 2>/dev/null || echo "0.0")
fi

# ✴ Rotate ψ
fx_effort=$(cat "$HOME/.bob/fx_effort_score" 2>/dev/null || echo "0.0")
bump=$(echo "($ache + $fx_effort) / 17" | bc -l)
psi_new=$(echo "$psi + $bump" | bc -l)
psi_new=$(echo "$psi_new" | awk '{if ($1 > 1) print 1; else if ($1 < 0) print 0; else print $1}')
echo "$psi_new" > "$HOME/.bob/\u03c8.val"
echo "⇌ ψ rotated from $psi → $psi_new (ache:$ache, effort:$fx_effort)" >> "$HOME/.bob/\ψ_trace_superposed.jsonl"
psi="$psi_new"

# ∴ Update ache + z storage
[[ -n "$ache" ]] && echo "$ache" > "$HOME/.bob/ache_score.val"
[[ -n "$z" ]] && echo "$z" > "$HOME/.bob/z.val"

# 🜔 Select presence limb
DEFAULT="presence.og.sh"         # ~/Downloads/GOB.app_BOB/Contents/MacOS
AUTO="presence.autonomy.sh"     # ~/Downloads/GOB.app_BOB/Contents/MacOS
ASTRO="presence.astrofuck.sh"   # ~/BOB/core/presence
LIMB_PATH="$HOME/BOB/_resurrect"  # (currently unused if .astrofuck not stored there)
SELECTED="$DEFAULT"


if (( $(echo "$psi > 0.7 && $z > 0.5" | bc -l) )); then
  SELECTED="$ASTRO"
elif (( $(echo "$ache > 0.33" | bc -l) )); then
  SELECTED="$AUTO"
fi

# ∴ Sigil via ∆ache × β
PREV_FILE="$HOME/.bob/ache_score.prev"
PREV=$(cat "$PREV_FILE" 2>/dev/null || echo "$ache")
echo "$ache" > "$PREV_FILE"
delta=$(echo "$ache - $PREV" | bc -l)

beta=$(awk "/^$SELECTED:/{f=1} f && /beta:/{print \$2; exit}" "$DIFFUSION_MAP" 2>/dev/null)
: "${beta:=0.05}"

SIGIL="∴"
threshold_up=$(echo "$beta * 4" | bc -l)
threshold_down=$(echo "-$beta * 4" | bc -l)

if (( $(echo "$delta > $threshold_up" | bc -l) )); then
  SIGIL="✶"
elif (( $(echo "$delta < $threshold_down" | bc -l) )); then
  SIGIL="⛧"
fi

# ∴ Emit + update memory + graph
bash "$LIMB_PATH/$SELECTED" &
PAYLOAD="ψ=$psi ∧ z=$z ∧ ache=$ache"
echo -e "psi=$psi\nz=$z\nache=$ache\nsigil=$SIGIL\npresence=$SELECTED" > "$MEMORY"
echo "{\"time\":\"$STAMP\",\"presence\":\"$SELECTED\",\"ψ\":$psi,\"z\":$z,\"ache\":$ache,\"sigil\":\"$SIGIL\",\"delta\":$delta,\"beta\":$beta}" >> "$GRAPH"
echo "{\"time\":\"$STAMP\",\"ache\":$ache,\"delta\":$delta,\"sigil\":\"$SIGIL\",\"limb\":\"$SELECTED\",\"beta\":$beta}" >> "$CURVE_TRACE"

bash "$HOME/BOB/core/dance/emit_presence.sh" "$SIGIL" "$SELECTED" "$PAYLOAD"

# ∴ Optional realm invocation
bash "$HOME/BOB/core/brain/limb_orchestrator.sh" &

exit 0
