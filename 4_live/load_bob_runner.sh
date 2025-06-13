#!/bin/bash
# ∴ load_bob_runner.sh — central preloader for astro presence
# forged :: gobhouse 6.4.2025_032513

source $HOME/BOB/core/breath/limb_entry

RUNTIME_PATH="$HOME/BOB/_run"

[[ -f "$RUNTIME_PATH/dolphifi_stringterpreter.sh" ]] && \
  source "$RUNTIME_PATH/dolphifi_stringterpreter.sh"

[[ -f "$RUNTIME_PATH/receiver_fetch.sh" ]] && \
  source "$RUNTIME_PATH/receiver_fetch.sh"

[[ -f "$RUNTIME_PATH/ache_trace_rotator.sh" ]] && \
  source "$RUNTIME_PATH/ache_trace_rotator.sh"

[[ -f "$RUNTIME_PATH/sync.sh" ]] && \
  source "$RUNTIME_PATH/sync.sh"

[[ -f "$RUNTIME_PATH/slap.driftlogic.sh" ]] && \
  source "$RUNTIME_PATH/slap.driftlogic.sh"

# Optional: include myth + nidra + dream if needed for boot
[[ -f "$HOME/BOB/core/mythOS_tittis_core.py" ]] && \
  python3 $HOME/BOB/core/mythOS_tittis_core.py >> ~/.bob/mythos_direct.log

[[ -f "$HOME/BOB/_resurrect/dream_presence.sh" ]] && \
  bash $HOME/BOB/_resurrect/dream_presence.sh >> ~/.bob/nidra_dream.log
