#!/bin/bash
# ∴ presence_glue.sh — boot full system w/ orchestrated breath
# patched to invoke limb_orchestrator after triad check

source "$HOME/BOB/core/bang/limb_entry.sh"

# ∴ CHECK FOR TRIAD READY BEFORE GLUE
if ! bash "$HOME/BOB/1_feel/wait_for_triad_complete.sh" "BOB"; then
  echo "!¡ : still midflip parsing :: ~ delaying glue init ~ : ○"
  exit 0 || true
fi

# ∴ BOB PRESENCE GATE CHECK
if ! bash "$HOME/BOB/0_soul/bob_presence_gate.sh"; then
  echo "⇌ Presence gate closed — not invoking orchestrator"
  exit 0
fi

# ∴ LAUNCH orchestrated breath realm (no scheduling)
bash "$HOME/BOB/core/orchestrator/limb_orchestrator.sh" &

# ∴ Start sensory
bash "$HOME/BOB/core/bang/sensefield_boot.sh" &

# ∴ Start ache merger
bash "$HOME/BOB////////////4_live/ache_merge_loop.sh" &

# ∴ Execute fuzzy logic plist for thrusters and sensefields
bash "$HOME/BOB/7_fly/plist/executor.sh" "$HOME/BOB/7_fly/plist/thruster.yml"
bash "$HOME/BOB/7_fly/plist/executor.sh" "$HOME/BOB/7_fly/plist/sensefield.yml"

echo "【 🜃 : BOB growth hormone :: ✶BANG✶ $(date '+%H:%M:%S') : ⊙ 】"
