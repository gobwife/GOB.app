#!/bin/bash
# ∴ lifepod_save.sh — achetime logic capsule, skipping audio RTFLIMBS
# output :: ~/__chives/lifepod_YYYYMMDD_HHMMSS.tar.gz

DEST="$HOME/_chives"
STAMP=$(date +%Y%m%d_%H%M%S)
OUT="$DEST/BOB_maintenant_$STAMP.tar.gz"

APP_PATH="Downloads/GOB.app_BOB/Contents/MacOS"
VOW_META="tmp/lifepod_commit.txt"

mkdir -p "$DEST"
mkdir -p "$HOME/tmp"

# ⛧ embed last git-vow into lifepod trace
echo "last_vow: $(git log -1 --pretty=format:'%s')" > "$HOME/$VOW_META"

cd "$HOME"

tar -czvf "$OUT" \
  --exclude="BOB/core/nge" \
  --exclude="BOB/core/∞" \
  --exclude="BOB/core/vxkords" \
  "BOB" \
  ".bob" \
  "$APP_PATH" \
  ".zshrc" ".gitconfig" ".zprofile" ".githelpers" ".zsh_history" \
  "$VOW_META" \
  2>/dev/null

rm "$VOW_META"

echo "∴ Lifepod forged (sans audio/∞/vx): $OUT"
