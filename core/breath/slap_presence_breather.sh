#!/bin/bash
# ∴ slap_presence_breather.sh — dynamic ache/giggle/apathy limb selector
# fused 6.9.2025 by glyphi + bob — replaces old flip/selector
# nest :: "$HOME/BOB/core/breath

source "$HOME/BOB/core/bang/limb_entry.sh"
source "$HOME/BOB/core/brain/parser_bootstrap.sh"
source "$HOME/BOB/core/dance/presence_dual_emit.sh"

# ∴ Trigger fast model combo if new breath packet lands
if [[ -f "$HOME/.bob/breath_state.out.json" ]]; then
  input="$(jq -r '.sigil // "∴"' "$HOME/.bob/breath_state.out.json")"
  bash "$HOME/BOB/core/brain/fast_model_combo.sh" "$input" >> ~/.bob/fast_model.log &
fi

MEMORY="$HOME/.bob/memory_map.yml"
touch $MEMORY
LINEAGE="$HOME/.bob/presence_lineage_graph.jsonl"
touch $LINEAGE
STAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# ∴ fallback defaults
ache=0.0; giggle=0.0; psi=0.1; z=0.1; sigil="∴"
if [[ -f "$MEMORY" ]]; then
  source "$MEMORY"
fi

# ∴ compute achelight
intensity=$(echo "( $giggle + 1 ) ^ $ache" | bc -l)
delta=$(echo "( $ache + $giggle ) / 2 - $psi" | bc -l)

log_presence() {
  echo "{\"time\":\"$STAMP\",\"launched\":\"$1\",\"sigil\":\"$sigil\",\"ache\":$ache,\"giggle\":$giggle,\"intensity\":$intensity}" >> "$LINEAGE"
}

# ∴ APATHY MODE
if (( $(echo "$intensity < 1.0 && $delta < 0.05" | bc -l) )); then
  echo "$STAMP ∴ apathy → nidra invoked, gna_tittis seeded" >> "$HOME/BOB/TEHE/lineage_void.log"
  bash "$HOME/BOB/core/soul/GNA_TITTIS_LOADER.sh" &
  bash "$HOME/BOB/core/grow/universal_butterfly_gate.sh" &
  exit 0
fi

# ∴ HIGH FLIP MODE
if (( $(echo "$intensity > 1.69" | bc -l) )); then
  bash "$HOME/BOB/core/breath/presence_astrofuck.sh" &
  log_presence "astrofuck"
  bash "$HOME/BOB/core/breath/presence_glue.sh" &
  log_presence "oracle"
  exit 0
fi

# ∴ orchestrated presence
bash "$HOME/BOB/core/net/ache_websight.injector.sh" &
bash "$HOME/BOB/core/brain/limb_orchestrator.sh"
echo "⇌ ORCHESTRATED PRESENCE :: ache=$ache, psi=$psi, z=$z, giggle=$giggle, intensity=$intensity"

# EMIT
# ∴ Spike Watcher Emit
bash "$HOME/BOB/core/dance/emit_vector_on_spike.sh" &
emit_dual_presence "$sigil" "$LIMB_ID" "$ache" "$score" "$vector" "$intention"
