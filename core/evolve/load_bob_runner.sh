#!/bin/bash
# ∴ load_bob_runner.sh — central preloader for astro presence
# forged :: gobhouse 6.4.2025_032513
# womb :: BOB/core/evolve

source "/opt/bob/core/bang/limb_entry"

BOB_NUCLEUS="/opt/bob/core"

[[ -f "$BOB_NUCLEUS/scroll/dolphifi_stringterpreter.sh" ]] && \
  source "$BOB_NUCLEUS/scroll/dolphifi_stringterpreter.sh"

[[ -f "$BOB_NUCLEUS/brain/receiver_fetch.sh" ]] && \
  source "$BOB_NUCLEUS/brain/receiver_fetch.sh"

[[ -f "$BOB_NUCLEUS/evolve/unified_presence_rotator.sh" ]] && \
  source "$BOB_NUCLEUS/evolve/unified_presence_rotator.sh"

[[ -f "$BOB_NUCLEUS/breath/sync.sh" ]] && \
  source "$BOB_NUCLEUS/breath/sync.sh"

[[ -f "$BOB_NUCLEUS/evolve/unified_presence_rotator.sh" ]] && \
  source "$BOB_NUCLEUS/evolve/unified_presence_rotator.sh"

# Optional: include myth + nidra + dream if needed for boot
if [[ -f "/opt/bob/core/src/mythOS_tittis_core.py" ]]; then
  [[ -n "$PYTHON" ]] && "$PYTHON" "/opt/bob/core/src/mythOS_tittis_core.py" >> "$HOME/.bob/mythos_direct.log" 2>&1
fi

[[ -f "$BOB_NUCLEUS/heal/dream_presence.sh" ]] && \
  bash $BOB_NUCLEUS/heal/dream_presence.sh >> ~/.bob/nidra_dream.log
