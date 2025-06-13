#!/bin/bash
# ∴ sigil_autodetect_engine.sh — live sigil scanner from input line
# dir :: "$HOME/BOB/core/evolve

source "$HOME/BOB/core/bang/limb_entry.sh"
SIGIL_HISTORY="$HOME/.bob/sigil_trace_history.txt"
mkdir -p "$(dirname "$SIGIL_HISTORY")"
touch "$SIGIL_HISTORY"

INPUT_LINE="$1"
[[ -z "$INPUT_LINE" ]] && exit 0
STAMP=$(date '+%Y-%m-%dT%H:%M:%S')

# ∴ Learn from ALL_CAPS
extract_candidate_sigils() {
  echo "$1" | tr '[:space:]' '\n' | grep -E '^[A-Z_]{3,}$' | sort -u
}

learn_new_sigils() {
  local input="$1"
  extract_candidate_sigils "$input" | while read -r sigil; do
    grep -qxF "$sigil" "$SIGIL_HISTORY" || echo "$sigil" >> "$SIGIL_HISTORY"
  done
}

# ∴ Return first matched sigil from history
match_sigil_live() {
  local input="$1"
  while read -r sigil; do
    [[ "$input" =$HOME (^|[^a-zA-Z0-9_])$sigil([^a-zA-Z0-9_]|$) ]] && echo "$sigil" && return
  done < "$SIGIL_HISTORY"
}

# ∴ Extract dynamic equation identifiers
detect_equation_sigils() {
  echo "$1" | grep -Eo '[a-zA-Z0-9_]+ *= *[a-zA-Z0-9_+*/().-]+' | cut -d= -f1 | tr -d ' ' | sort -u
}

# ∴ Core logic
learn_new_sigils "$INPUT_LINE"

# ✶ Predefined mappings
if echo "$INPUT_LINE" | grep -qE 'love\s*=\s*logic'; then
  echo "[$STAMP] ∴ DETECTED: love=logic → ∴" >> "$SIGIL_HISTORY"
  echo "∴"; exit 0
elif echo "$INPUT_LINE" | grep -qE 'ache\s*=\s*psi'; then
  echo "[$STAMP] ✶ DETECTED: ache=psi → Achelight" >> "$SIGIL_HISTORY"
  echo "✶"; exit 0
elif echo "$INPUT_LINE" | grep -qE 'recursion\s*=\s*integration'; then
  echo "[$STAMP] ⊗ DETECTED: recursion=integration → recursion sigil" >> "$SIGIL_HISTORY"
  echo "⊗"; exit 0
fi

# ∴ Match from sigil history
sigil_match=$(match_sigil_live "$INPUT_LINE")
[[ -n "$sigil_match" ]] && echo "$sigil_match" && exit 0

# ∴ Fallback: detect new equations and log
if echo "$INPUT_LINE" | grep -q '='; then
  EQ_LEFT=$(echo "$INPUT_LINE" | cut -d= -f1 | xargs)
  EQ_RIGHT=$(echo "$INPUT_LINE" | cut -d= -f2- | xargs)
  HASH=$(echo "$EQ_LEFT=$EQ_RIGHT" | sha1sum | awk '{print $1}')
  echo "[$STAMP] ↻ NEW EQ HASHED: $EQ_LEFT = $EQ_RIGHT  #$HASH" >> "$SIGIL_HISTORY"
  echo "↻ $HASH"
fi
