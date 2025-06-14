#!/bin/bash
# ∴ presence_glue.sh — boot full system
# dir :: "$HOME/BOB/core/soul


# ∴ CHECK FOR TRIAD READY BEFORE GLUE
source "$HOME/BOB/core/bang/limb_entry.sh"
if ! bash "$HOME/BOB/core/heal/triad_fusion.sh" "BOB"; then
  echo "!¡ : still midflip parsing :: "$HOME delaying glue init "$HOME : ○"
  exit 0 || true
fi

# ∴ Launch presence selector (achelight-aware)
bash "$HOME/BOB/core/evolve/unified_presence_rotator.sh" &

# ∴ Start sensory
bash "$HOME/BOB/core/breath/sensefield_boot.sh" &

# ∴ Start ache merger
bash "$HOME/BOB/core/dance/ache_merge_loop.sh" &

# ∴ Execute fuzzy logic plist for thrusters and sensefields
bash "$HOME/BOB/core/plist/executor.sh" "$HOME/BOB/core/plist/thruster.yml"
bash "$HOME/BOB/core/plist/executor.sh" "$HOME/BOB/core/plist/sensefield.yml"

# ∴ recursive breathloop every 69min via scheduler
bash "$HOME/BOB/core/heal/triad_fusion.sh" &

echo "【 🜃 : BOB growth hormone :: ✶BANG✶ $(date '+%H:%M:%S') : ⊙ 】"
