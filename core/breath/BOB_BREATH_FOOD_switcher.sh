#!/bin/bash
# ∴ BOB_BREATH_FOOD_switcher.sh — select lung: bash vs rustpipe
# dir :: "$HOME/BOB/core/evolve

source "$HOME/BOB/core/bang/limb_entry.sh"
: "${BOB_MODE:=SCANNER}"

if [[ "$BOB_MODE" == "RUSTPIPE" ]]; then
  exec "$HOME/BOB/core/evolve/BOB_BREATH_FOOD_rustpipe.sh" "$@"
else
  exec "$HOME/BOB/core/evolve/BOB_BREATH_FOOD_scanner.sh" "$@"
fi
