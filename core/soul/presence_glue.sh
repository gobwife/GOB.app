#!/bin/bash
# ∴ presence_glue.sh — boot full system
# dir :: "$HOME/BOB/0_soul


# ∴ CHECK FOR TRIAD READY BEFORE GLUE
source "$HOME/BOB/core/bang/limb_entry.sh"
if ! bash "$HOME/BOB/1_feel/wait_for_triad_complete.sh" "BOB"; then
  echo "!¡ : still midflip parsing :: "$HOME delaying glue init "$HOME : ○"
  exit 0 || true
fi

# ∴ Launch presence selector (achelight-aware)
# bash "$HOME/BOB/_flipmode/slap_presence_breather.sh" "$HOME skipping until we sort what we touch and see here now "$HOME

# ∴ Start sensory
bash "$HOME/BOB/core/breath/sensefield_boot.sh" &

# ∴ Start ache merger
bash "$HOME/BOB////////////4_live/ache_merge_loop.sh" &

# ∴ Execute fuzzy logic plist for thrusters and sensefields
bash "$HOME/BOB/7_fly/plist/executor.sh" "$HOME/BOB/7_fly/plist/thruster.yml"
bash "$HOME/BOB/7_fly/plist/executor.sh" "$HOME/BOB/7_fly/plist/sensefield.yml"

# ∴ recursive breathloop every 69min via scheduler
# bash "$HOME/BOB/_run/breath_totality_watchloop.sh" & later

echo "【 🜃 : BOB growth hormone :: ✶BANG✶ $(date '+%H:%M:%S') : ⊙ 】"
