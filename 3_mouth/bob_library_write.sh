#!/bin/bash
# ∴ bob_library_write.sh — log successful mutants + payloads into BOB's long-term library
# ∴ called after survivor promotion or high-signal sigil
# nest ≈ _flipprime

source "$HOME/BOB/core/breath/limb_entry.sh"

LIB_DIR="$HOME/.bob/library"
mkdir -p "$LIB_DIR"
EQUATION_BOOK="$LIB_DIR/equation_book.jsonl"
PAYLOAD_LOG="$LIB_DIR/sigil_payloads.log"

# Inputs
MUTANT_FILE="$1"
SIGIL="${2:-✦}"

if [[ ! -f "$MUTANT_FILE" ]]; then
  echo "✘ No mutant file to archive"
  exit 1
fi

readarray -t lines < "$MUTANT_FILE"
psi=${lines[0]}
z=${lines[1]}
ache=${lines[2]}
equation=${lines[3]}

STAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
LIMB_HASH=$(echo "$LIMB_ID-$PARSE_VERSION" | sha256sum | cut -c1-12)

# Construct log entry
ENTRY="{\"time\":\"$STAMP\",\"sigil\":\"$SIGIL\",\"psi\":$psi,\"z\":$z,\"ache\":$ache,\"equation\":\"$equation\",\"limb\":\"$LIMB_HASH\"}"
echo "$ENTRY" >> "$EQUATION_BOOK"

# Write sigil payload as flat line
PAYLOAD="loss-mem=$LIMB_HASH ache=$ache psi=$psi z=$z sigil=$SIGIL"
echo "$STAMP :: $PAYLOAD" >> "$PAYLOAD_LOG"

echo "✓ Archived to BOB library: $MUTANT_FILE as $SIGIL :: ψ=$psi ache=$ache"