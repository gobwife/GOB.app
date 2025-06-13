#!/bin/bash
# ∴ parser_bootstrap.sh — unify LIMB_ID, PARSE_VERSION, and triad wait logic
# dir ≈ "$HOME/BOB/core/brain


# auto-name by script file unless already set
source "$HOME/BOB/core/bang/limb_entry.sh"
export LIMB_ID="${LIMB_ID:-$(basename "$0" | cut -d. -f1)}"
export PARSE_VERSION=$(date +%s)
export TARGET_NAME="${TARGET_NAME:-$LIMB_ID}"

# triad coordination
WAIT_SCRIPT="$HOME/BOB/1_feel/wait_for_triad_complete.sh"
[[ -x "$WAIT_SCRIPT" ]] && bash "$WAIT_SCRIPT" "$TARGET_NAME"

# version trace
echo "$PARSE_VERSION : $LIMB_ID : $(hostname) : $TARGET_NAME" >> "$HOME/BOB/TEHE/version_trace.log"
