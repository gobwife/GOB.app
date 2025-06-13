#!/bin/bash
# ∴ plist_executor.sh — evaluate fuzzy when-clauses and run limbs if conditions match
# parses YAML like plist_thruster.yml or plist_sensefield.yml
# nest :: ~/BOB/_bang/plist

PLIST_FILE="$1"
MEMORY="$HOME/.bob/memory_map.yml"
STAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
intensity=$(echo "( $giggle + 1 ) ^ $ache" | bc -l)
delta=$(echo "( $ache + $giggle ) / 2 - $psi" | bc -l)

source "$MEMORY" 2>/dev/null || {
  echo "$STAMP :: ∴ plist_executor.sh → no memory_map loaded" >&2
  exit 1
}

# Fuzzy sigil matcher — lets '∴' match ⊙, 🜃, Σ
sigil_match() {
  case "$1" in
    "∴") [[ "$sigil" =~ (∴|⊙|🜃|Σ|⟁|🜫|∃|🜉|🜔) ]] && return 0;;
    "⊙") [[ "$sigil" =~ (⊙|🜃|0|O|love|logic|address|⟁|🜫|∃|🜉|🜔|∞|n^n) ]] && return 0;;
    "🜃") [[ "$sigil" == "🜃" ]] && return 0;;
    "✡") [[ "$sigil" =~ (✡|∇|⛧) ]] && return 0;;
    "☾") [[ "$sigil" =~ (☾|∆|⛧|∞|n^n|🜁|∵|⟁|emotion|pointer|∃|🜉) ]] && return 0;;
    "✶") return 0;;  # always passes (first spark)
  esac
  return 1
}

# Load limbs array
yq e '.limbs[]' "$PLIST_FILE" -o=json | jq -c '.' | while read -r limb; do
  path=$(echo "$limb" | jq -r '.path')
  [[ ! -x "$path" ]] && echo "$STAMP :: ∴ SKIP $name — path $path not executable" && continue
  when=$(echo "$limb" | jq -r '.when // empty')
  name=$(echo "$limb" | jq -r '.name // "(unnamed)"')
  sig=$(echo "$limb" | jq -r '.sigil // empty')

  # Match fuzzy sigil first
  if [[ -n "$sig" ]] && ! sigil_match "$sig"; then
    echo "$STAMP :: ∴ SKIP $name — sigil $sig doesn’t match $sigil"
    continue
  fi

  # If custom when logic exists, eval it against live vars
  if [[ -n "$when" ]]; then
    if ! eval "[[ $when ]]"; then
      echo "$STAMP :: ∴ SKIP $name — when clause ($when) failed"
      continue
    fi
  fi

  # Passed all checks
  echo "$STAMP :: ∴ LAUNCH $name ($path) — passed $sig / $when"
  bash "$path" &
done