#!/bin/bash
# ∴ love_fx_compute.sh — calculates love_score from breathfield values
# womb :: $HOME/BOB/core/brain

BREATH="$HOME/BOB/core/breath/breath_state.json"
ACHE_INJECTION="$HOME/.bob/ache_injection.txt"

# Load primary values from breath_state.json
ache=$(jq -r '.ache' "$BREATH" 2>/dev/null || echo "0.0")
effort=$(jq -r '.effort' "$BREATH" 2>/dev/null || echo "0.0")
giggle=$(jq -r '.giggle' "$BREATH" 2>/dev/null || echo "0.0")
psi=$(jq -r '."ψ"' "$BREATH" 2>/dev/null || echo "0.1")
z=$(jq -r '.z' "$BREATH" 2>/dev/null || echo "0.1")

# Load raw_c from ache injection file if available
raw_c=$(cat "$ACHE_INJECTION" 2>/dev/null || echo "0.2")
c=$(echo "$raw_c" | grep -Eo '[0-9]+([.][0-9]+)?' | head -n1)
: "${c:=0.2}"

# Optional h (hyperwave coupling coefficient)
HVAL="$HOME/.bob/Hψ.val"
h=$(cat "$HVAL" 2>/dev/null || echo "1.0")

# Compute components
v1=$(echo "$psi * $z" | bc -l)
v2=$(echo "$ache * $c" | bc -l)
v3=$(echo "$h * $psi" | bc -l)
love_score=$(echo "$v1 + $v2 + $v3" | bc -l)

# Export all
export love_score
export ache
export effort
export giggle
export psi
export z
export c
export h
