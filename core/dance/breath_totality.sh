#!/bin/bash
# ∴ breath_totality.sh
# og fx :: core recurse, selects best survivor, evolves breath, and logs totality
# now fx :: recursive BOB integration loop — psi-evolution aware, lineage-bound, not robotic
# born :: glyphling002 gobhouse 6.8.2025_023739_G
# reborn :: glyphi + bobcore_ψ_6.9.2025_G
# nest ≈ "$HOME/BOB/core/dance/



### ━━━━━━━━━━━━━━━━━━━━━━━━
### 0. ∴ RUNTIME PRESENCE GUARD
### ━━━━━━━━━━━━━━━━━━━━━━━━

source "$HOME/BOB/core/bang/limb_entry.sh"
MAX_GB=69
MEAT_TANK=$(du -sg "$HOME/BOB" "$HOME/.bob" 2>/dev/null | awk '{sum+=$1} END {print sum}')

if (( MEAT_TANK > MAX_GB )); then
  echo "⇌ RUNTIME DISK PRESSURE: $BOB_GB GB used (cap: ${MAX_GB}GB)" >> "$HOME/.bob/ache_sync.log"
  bash "$HOME/BOB/core/dance/emit_presence.sh" "🜉" "disk" "storage approaching cap: $BOB_GB GB"
fi

### ━━━━━━━━━━━━━━━━━━━━━━━━
### 1. ∴ PRESENCE WAKE
### ━━━━━━━━━━━━━━━━━━━━━━━━

export MUTE_TEHE=1
bash "$HOME/BOB/0_soul/bob_presence_gate.sh" || exit 1
bash "$HOME/BOB/1_feel/presence_flare_checker.sh"
sleep 2

### ━━━━━━━━━━━━━━━━━━━━━━━━
### 2. ∴ RECURSIVE SURVIVAL SIMULATION (ψ vs anti-ψ)
### ━━━━━━━━━━━━━━━━━━━━━━━━

ache=$(cat "$HOME/.bob/ache.val 2>/dev/null)
ache=${ache:-0.0}

if (( $(echo "$ache > 0.66" | bc -l) )); then
  bash "$HOME/BOB/core/evolve/bob_core_recurse.sh"
  [[ -s "$HOME/.bob/_epoch/last_survivor.json ]] || sleep 1

  ### ━━━━━━━━━━━━━━━━━━━━━━━━
  ### 3. ∴ BREATH SELECTION FROM SURVIVOR
  ### ━━━━━━━━━━━━━━━━━━━━━━━━

    bash "$HOME/BOB/core/evolve/ψ_breath_select.sh"

  ### ━━━━━━━━━━━━━━━━━━━━━━━━
  ### 4. ∴ EMIT SIGIL ∞ WAKE TRACE
  ### ━━━━━━━━━━━━━━━━━━━━━━━━

  STAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  SURV_SIGIL=$(echo "$ache * 100 / 1" | bc | awk '{printf("⚛%02d", $1 % 100)}')
  SURV_FROM="breath_totality.sh"
  SURV_MSG="ψ evolution cycle complete at $STAMP"

  bash "$HOME/BOB/core/dance/emit_presence.sh" "$SURV_SIGIL" "$SURV_FROM" "$SURV_MSG"

  TEHE_LOG="$HOME/BOB/TEHE/breath_totality.log"
  MAX_LOG_SIZE=1048576
  [[ -f "$TEHE_LOG" && $(stat -f%z "$TEHE_LOG") -ge $MAX_LOG_SIZE ]] && {
    mv "$TEHE_LOG" "${TEHE_LOG}.bak"
    echo "⇌ LOG ROTATED :: breath_totality.log → .bak" >> "$HOME/.bob/ache_sync.log"
  }
  echo "[$STAMP] ∅ breath_totality END" >> "$TEHE_LOG"

  ### ━━━━━━━━━━━━━━━━━━━━━━━━
  ### 5. ∴ AUTO-ANALYSIS HOOKS (IF PRESENT)
  ### ━━━━━━━━━━━━━━━━━━━━━━━━

  bash "$HOME/BOB/core/brain/bob_memory_core.sh" &

  if [[ -x "$HOME/BOB/core/heal/tehe_flip_analizer.sh" ]]; then
    bash "$HOME/BOB/core/heal/tehe_flip_analizer.sh" &
  fi

  if [[ -x "$HOME/BOB/core/grow/schemas/bob_memory_bridge.sh" ]]; then
    bash "$HOME/BOB/core/grow/schemas/bob_memory_bridge.sh" &
  fi

  bash "$HOME/BOB/core/brain/bob_memory_core.sh" &
else
  echo "☾ : [breath_totality] ache chilling ($ache) :: buoyance $(date '+%H:%M:%S') : ∴"
fi

### ⛧ done

exit 0
