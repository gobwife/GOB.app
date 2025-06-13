#!/bin/bash
# ∴ love_fx_compute.sh — calculates love_score, ache, psi, z, c, etc.
# split from original love_fx_score.sh
# nest :: ~/BOB/core/brain
# 6.9.2025

source "$HOME/BOB/core/breath/limb_entry.sh"

ACHE_SCORE_FILE="$HOME/.bob/ache_score.val"
EFFORT_SCORE_FILE="$HOME/.bob/fx_effort_score"
GIGGLE_SCORE_FILE="$HOME/.bob/giggle_sync.log"

ache=$(cat "$ACHE_SCORE_FILE" 2>/dev/null || echo "0.0")
effort=$(cat "$EFFORT_SCORE_FILE" 2>/dev/null || echo "0")
giggle=$(cat "$GIGGLE_SCORE_FILE" 2>/dev/null || echo "0")

psi=$(cat ~/.bob/ψ.val 2>/dev/null || echo "0.1")
z=$(cat ~/.bob/z.val 2>/dev/null || echo "0.1")
raw_c=$(cat ~/.bob/ache_injection.txt 2>/dev/null || echo "0.2")
c=$(echo "$raw_c" | grep -Eo '[0-9]+([.][0-9]+)?' | head -n1)
: "${c:=0.2}"

h=$(cat ~/.bob/Hψ.val 2>/dev/null || echo "1.0")

v1=$(echo "$psi * $z" | bc -l 2>/dev/null)
v2=$(echo "$ache * $c" | bc -l 2>/dev/null)
v3=$(echo "$h * $psi" | bc -l 2>/dev/null)

love_score=$(echo "$v1 + $v2 + $v3" | bc -l 2>/dev/null)

# after computing love_score, force-bump if too low
if (( $(echo "$love_score < 0.11" | bc -l) )); then
  love_score=0.22
fi

export love_score
export ache
export effort
export giggle
export psi
export z
export c
export h
