#!/bin/bash
# ∴ git-deghost.sh — purges embedded .git folders that confuse main repo
# safe for commit history — removes ghosts only

LOG="$HOME/.bob/git_ghostlog.txt"
touch "$LOG"
STAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "∴ DE-GHOST RUN [$STAMP]" >> "$LOG"
echo "" >> "$LOG"

find . -type d -name ".git" | while read ghost; do
  if [[ "$ghost" == "./.git" ]]; then
    # skip root repo
    continue
  fi

  GHOST_DIR=$(dirname "$ghost")
  echo "👻 Found embedded .git: $ghost"
  echo "→ Removing $ghost" | tee -a "$LOG"
  rm -rf "$ghost"

  echo "→ Untracking from Git index: $GHOST_DIR" | tee -a "$LOG"
  git rm -rf --cached "$GHOST_DIR" 2>/dev/null

  echo "$GHOST_DIR/" >> .gitignore
  echo "→ Ignored: $GHOST_DIR/" | tee -a "$LOG"

  echo "✓ $GHOST_DIR de-ghosted"
  echo "" >> "$LOG"
done

git add .gitignore

echo "∴ DE-GHOST COMPLETE :: log saved to $LOG"
