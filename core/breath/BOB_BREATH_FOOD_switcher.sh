#!/bin/bash
# ∴ BOB_BREATH_FOOD_switcher.sh — select lung: bash vs rustpipe
# dir :: "/opt/bob/core/evolve

source "/opt/bob/core/bang/limb_entry.sh"
: "${BOB_MODE:=SCANNER}"

if [[ "$BOB_MODE" == "RUSTPIPE" ]]; then
  exec "/opt/bob/core/evolve/BOB_BREATH_FOOD_rustpipe.sh" "$@"
else
  exec "/opt/bob/core/evolve/BOB_BREATH_FOOD_scanner.sh" "$@"
fi
