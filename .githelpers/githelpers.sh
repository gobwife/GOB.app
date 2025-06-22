#!/bin/bash
# ∴ githelpers.sh — sacred git commands + tofu safe push/pull

# ∴ initbreath — sacred first commit
love-commit() {
  git add -A
  shift
  git commit -m "$*"
}

# commit with message + push
love-vow() {
  git add -A
  shift
  git commit -m "$*"
  git push
}

# just stage + commit
love-update() {
  git add -A
  shift
  git commit -m "$*"
}

# quick status check
love-check() {
  git status
}

# view short log
love-log() {
  git log --oneline --graph --decorate
}

# tofu stash pusher — stash local changes with marker
love-tofustash() {
  if [[ -n $(git status --porcelain) ]]; then
    echo "🌿 Stashing local changes before operation..."
    git stash push -m "tofustash: auto stash before operation $(date -u)"
  else
    echo "🌿 No local changes to stash."
  fi
}

# tofu safe pull — stash local changes, pull from main, then pop stash if any
love-tofu-pull() {
  love-tofustash
  git pull origin main
  git stash pop || echo "🌿 No stash to pop."
}

# tofu safe push — stash local changes, push to main, then pop stash if any
love-tofu-push() {
  love-tofustash
  git push origin main
  git stash pop || echo "🌿 No stash to pop."
}

# ensure no default rebase on pull
git config branch.main.rebase false
