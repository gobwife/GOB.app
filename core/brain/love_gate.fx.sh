#!/bin/bash
# ∴ love_gate.fx.sh — unified LOVEFX logic gate wrapper
# Combines compute + interpret
# Output: love_score | state | query
# womb :: core/brain

# Source compute + functions
source "$HOME/BOB/core/brain/love_fx_compute.sh"
source "$HOME/BOB/core/brain/love_fx_functions.sh"

# If not already computed (for external call), compute now
: "${love_score:=0}"

state=$(describe_love_state "$love_score")
query=$(generate_query_from_lovefx "$love_score")

# Output full payload
printf "LOVEFX: %s\nSTATE  : %s\nQUERY  : %s\n" "$love_score" "$state" "$query"

# Optional: export for downstream use
export love_score
export love_state="$state"
export love_query="$query"