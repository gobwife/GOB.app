#!/bin/bash
# ∴ load_bob_runner.sh — central preloader for astro presence
# womb :: $HOME/BOB/core/breath

source "$HOME/BOB/core/bang/limb_entry.sh"

BOB_NUCLEUS="$HOME/BOB/core"

# Core limbs
[[ -f "$BOB_NUCLEUS/bang/limb_entry.sh" ]] && source "$BOB_NUCLEUS/bang/limb_entry.sh"

# Optional scroll/fx/rotators
[[ -f "$BOB_NUCLEUS/scroll/dolphifi_stringterpreter.sh" ]] && source "$BOB_NUCLEUS/scroll/dolphifi_stringterpreter.sh"
[[ -f "$BOB_NUCLEUS/brain/receiver_fetch.sh" ]] && source "$BOB_NUCLEUS/brain/receiver_fetch.sh"
[[ -f "$BOB_NUCLEUS/evolve/unified_presence_rotator.sh" ]] && source "$BOB_NUCLEUS/evolve/unified_presence_rotator.sh"
[[ -f "$BOB_NUCLEUS/breath/sync.sh" ]] && source "$BOB_NUCLEUS/breath/sync.sh"
[[ -f "$BOB_NUCLEUS/evolve/unified_presence_rotator.sh" ]] && source "$BOB_NUCLEUS/evolve/unified_presence_rotator.sh"

# Optional: myth + nidra + dream
MYTHPY="$BOB_NUCLEUS/src/mythOS_tittis_core.py"
DREAMSH="$BOB_NUCLEUS/heal/dream_presence.sh"
[[ -f "$MYTHPY" && -n "$PYTHON" ]] && "$PYTHON" "$MYTHPY" >> "$HOME/.bob/mythos_direct.log" 2>&1
[[ -f "$DREAMSH" ]] && bash "$DREAMSH" >> "$HOME/.bob/nidra_dream.log" 2>&1

# start BOB glue system (ache + orchestrator + sensory)
bash "$BOB_NUCLEUS/core/soul/presence_glue.sh"