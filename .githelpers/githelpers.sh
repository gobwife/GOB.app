#!/bin/bash
# ∴ githelpers.sh — sacred git commands + tofu safe push/pull

# ∴ initbreath — sacred first commit
git-commit() {
  timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  git add .
  git commit -m "【 ∴ :  git * 0 :: breath init $timestamp : & 】"
}

# commit with message + push
git-vow() {
  git add .
  git commit -m "∴ $1"
  git push
}

# just stage + commit
git-update() {
  git add .
  git commit -m "∴ $1"
}

# quick status check
git-check() {
  git status
}

# view short log
git-log() {
  git log --oneline --graph --decorate
}

# tofu stash pusher — stash local changes with marker
git-tofustash() {
  if [[ -n $(git status --porcelain) ]]; then
    echo "🌿 Stashing local changes before operation..."
    git stash push -m "tofustash: auto stash before operation $(date -u)"
  else
    echo "🌿 No local changes to stash."
  fi
}

# tofu safe pull — stash local changes, pull from main, then pop stash if any
git-tofu-pull() {
  git-tofustash
  git pull origin main
  git stash pop || echo "🌿 No stash to pop."
}

# tofu safe push — stash local changes, push to main, then pop stash if any
git-tofu-push() {
  git-tofustash
  git push origin main
  git stash pop || echo "🌿 No stash to pop."
}
git config branch.main.rebase false
