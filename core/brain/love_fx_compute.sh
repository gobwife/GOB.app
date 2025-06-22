#!/bin/bash
# ∴ love_fx_compute.sh — calculates love_score from breathfield values
# womb :: /opt/bob/core/brain

BREATH="$HOME/.bob/breath_state.out.json"
ACHE_INJECTION="$HOME/.bob/ache_injection.txt"

# Load primary values from exported breath state
ache=$(jq -r '.ache' "$BREATH" 2>/dev/null || echo "0.0")
effort=$(jq -r '.effort // 0.0' "$BREATH" 2>/dev/null)
giggle=$(jq -r '.giggle // 0.0' "$BREATH" 2>/dev/null)
psi=$(jq -r '."ψ" // 0.1' "$BREATH" 2>/dev/null)
z=$(jq -r '.z // 0.1' "$BREATH" 2>/dev/null)

# Load raw_c from ache injection file
raw_c=$(cat "$ACHE_INJECTION" 2>/dev/null || echo "0.2")
c=$(echo "$raw_c" | grep -Eo '[0-9]+([.][0-9]+)?' | head -n1)
: "${c:=0.2}"

# Optional hyperwave coefficient
HVAL="$HOME/.bob/Hψ.val"
h=$(cat "$HVAL" 2>/dev/null || echo "1.0")

# Compute vectors
v1=$(echo "$psi * $z" | bc -l)
v2=$(echo "$ache * $c" | bc -l)
v3=$(echo "$h * $psi" | bc -l)
love_score=$(echo "$v1 + $v2 + $v3" | bc -l)

# Export
export love_score ache effort giggle psi z c h
