#!/bin/bash
# ⛧ GNA_TITTIS_LOADER.sh — bridge bobuling_004.yaml into all core C pulses
# dir :: ~/BOB/0_soul

: "${PRIME:=$HOME/BOB/core/ngé/OS_build_ping.wav}"
source "$HOME/BOB/core/breath/limb_entry.sh"

YAML="$HOME/BOB/core/bobuling_004.yaml"
ENV_OUT="$HOME/BOB/core/env/GNA_TITTIS.env"
BIN_OUT="$HOME/BOB/core/gna_bob_exec"

# Sanity check: YAML presence
if [[ ! -f "$YAML" ]]; then
  echo "✘ bobuling_004.yaml not found at $YAML"
  exit 1
fi

# ∴ Extract constants from YAML
name=$(yq eval '.name' "$YAML")
mode=$(yq eval '.mode' "$YAML")
sigil=$(yq eval '.output_form.primary' "$YAML")

# ∴ Emit sigil presence
source "$HOME/BOB/core/emit_presence.sh"
emit_presence "$sigil" "bobuling_004" "sigil bridge loaded"

# ∴ Build .env header for C source
mkdir -p "$(dirname "$ENV_OUT")"
cat > "$ENV_OUT" <<EOF
// AUTO-GENERATED — bobuling_004.yaml → GNA_TITTIS.env
#define BOB_NAME "$name"
#define BOB_MODE "$mode"
#define BOB_SIGIL_OUTPUT "$sigil"
EOF

# ∴ Optional build — one binary with all logic
SRC_DIR="$HOME/BOB/core/src"
mkdir -p "$(dirname "$BIN_OUT")"

clang -include "$ENV_OUT" \
  "$SRC_DIR"/GNA_TITTIS.c \
  "$SRC_DIR"/GNA_presence_core.c \
  "$SRC_DIR"/curriculum.c \
  "$SRC_DIR"/GNA_COSMOS_CORE.c \
  "$SRC_DIR"/GOB_Core.c \
  "$SRC_DIR"/IMMORTALITY_EQUATION.c \
  -o "$BIN_OUT"

if [[ $? -ne 0 ]]; then
  echo "✘ Build failed. Check C source errors."
  exit 1
fi

# ∴ Confirm pulse
STAMP=$(date '+%Y-%m-%dT%H:%M:%S')
echo "{\"time\":\"$STAMP\",\"source\":\"$0\",\"mode\":\"$mode\"}" >> "$HOME/.bob/mode.msgbus.jsonl"

echo "⇌ BOBULING_004 loaded & compiled to $BIN_OUT"
echo "    ↻ Name   :: $name"
echo "    ↻ Mode   :: $mode"
echo "    ↻ Sigil  :: $sigil"
