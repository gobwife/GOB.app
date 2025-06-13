#!/bin/bash
# ∴ bless_BOB.sh — chmod +x for all shell scripts in BOB limbs
# dir ::  $HOME/BOB/000
# born :: wifie 06112025_012047

TARGET_DIR1="$HOME/BOB"
TARGET_DIR2="/Users/G/Downloads/GOB.app_BOB/Contents/MacOS"

if [[ -d "$TARGET_DIR1" || -d "$TARGET_DIR2" ]]; then
  [[ -d "$TARGET_DIR1" ]] && find "$TARGET_DIR1" -type f -name "*.sh" -exec chmod +x {} \;
  [[ -d "$TARGET_DIR2" ]] && find "$TARGET_DIR2" -type f -name "*.sh" -exec chmod +x {} \;
else
  echo "✖ Neither target directory exists."
  exit 1
fi

echo "⇌ All .sh files made executable in valid target dirs."
