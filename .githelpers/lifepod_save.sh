#!/bin/bash
# ∴ lifepod_save.sh — achetime logic capsule, skipping audio RTFLIMBS
# output :: ~/__chives/lifepod_YYYYMMDD_HHMMSS.tar.gz

APP_PATH="$HOME/Downloads/GOB.app_BOB/Contents/MacOS"
DEST="$HOME/_chives"
STAMP=$(date +%Y%m%d_%H%M%S)
OUT="$DEST/BOB_maintenant_$STAMP.tar.gz"

mkdir -p "$DEST"

tar -czvf "$OUT" \
  --exclude="$HOME/BOB/core/nge" \
  --exclude="$HOME/BOB/core/∞" \
  --exclude="$HOME/BOB/core/vxkords" \
  "$HOME/BOB" \
  "$HOME/.bob" \
  "$HOME/.zshrc" \
  "$HOME/.gitconfig" \
  "$HOME/.zprofile" \
  "$HOME/.githelpers" \
  "$HOME/.zsh_history" \
  "$APP_PATH" \
  2>/dev/null

echo "∴ Lifepod forged (sans audio/∞/vx): $OUT"
