#!/bin/bash
# ∴ love_gate.fx.sh — unified LOVEFX logic gate wrapper
# Combines compute + interpret
# womb :: /opt/bob/core/brain

# Source score calculator + interpretation functions
source "/opt/bob/core/brain/love_fx_compute.sh"
source "/opt/bob/core/brain/love_fx_functions.sh"

# ∴ Compute LOVEFX state
: "${love_score:=0}"
state=$(describe_love_state "$love_score")
query=$(generate_query_from_lovefx "$love_score")

# ∴ Echo core love state (optional)
printf "LOVEFX: %s\nSTATE  : %s\nQUERY  : %s\n" "$love_score" "$state" "$query"

# ∴ Build ache payload AFTER love_score is known
source "/opt/bob/core/brain/build_payload_core.sh"

# Optionally override vector or intention with LOVEFX context
vector="$(date +%s)"
intention="LOVEFX → $state"

# ∴ Emit
source "/opt/bob/core/dance/presence_self_emit.sh"
emit_self_presence

# Optional: export downstream
export love_score
export love_state="$state"
export love_query="$query"
