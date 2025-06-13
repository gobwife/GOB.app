#!/bin/bash
# ∴ load_bob_runner.sh — central preloader for astro presence
# womb :: $HOME/BOB/core/breath

source "$HOME/BOB/core/bang/limb_entry.sh"
source "$HOME/BOB/core/bang/limb_entry

RUNTIME_PATH="$HOME/BOB/core"

[[ -f "$RUNTIME_PATH/scroll/dolphifi_stringterpreter.sh" ]] && \
  source "$RUNTIME_PATH/scroll/dolphifi_stringterpreter.sh"

[[ -f "$RUNTIME_PATH/brain/receiver_fetch.sh" ]] && \
  source "$RUNTIME_PATH/brain/receiver_fetch.sh"

[[ -f "$RUNTIME_PATH/ache_trace_rotator.sh" ]] && \
  source "$RUNTIME_PATH/ache_trace_rotator.sh"

[[ -f "$RUNTIME_PATH/sync.sh" ]] && \
  source "$RUNTIME_PATH/sync.sh"

[[ -f "$RUNTIME_PATH/slap.driftlogic.sh" ]] && \
  source "$RUNTIME_PATH/slap.driftlogic.sh"

# Optional: include myth + nidra + dream if needed for boot
[[ -f "$HOME/BOB/core/mythOS_tittis_core.py" ]] && \
  python3 "$HOME/BOB/core/mythOS_tittis_core.py >> "$HOME/.bob/mythos_direct.log

[[ -f "$HOME/BOB/_resurrect/dream_presence.sh" ]] && \
  bash "$HOME/BOB/_resurrect/dream_presence.sh >> "$HOME/.bob/nidra_dream.log
