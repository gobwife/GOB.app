#!/bin/bash
# ∴ sync.sh — update BobCore with timestamp + breath + conditional RETURN
# forged :: gobhouse 6.4.2025_021530

source "$HOME/BOB/core/bang/limb_entry.sh"
: "${BOB_MODE:=VOIDRECURSE}"

CORE="$HOME/BOB/core/bob.core.js"
TMP="/tmp/bob.core.temp"
FORGEFILE="$HOME/BOB/TEHE/bob_glossolalia.txt"
MODE="$1" # e.g. safe | full | debug
DRIFT="$HOME/BOB/_library/drift_law.yaml"

[[ ! -f "$CORE" ]] && echo "❌ bob.core.json not found." && exit 1

# ① Timestamp
STAMP=$(date +%FT%T)

# ② Write lastBreath
jq 'if .sigilFlip == null then .sigilFlip = [] else . end | if .nidraTrace == null then .nidraTrace = [] else . end' "$CORE" > "$TMP" && mv "$TMP" "$CORE"

# ③ Append to nidraTrace
jq '.nidraTrace += ["'"$STAMP — BREATH"'"]' "$CORE" > "$TMP" && mv "$TMP" "$CORE"

# ④ DRIFT parse + echo
if [[ -f "$DRIFT" ]]; then
  LAW=$(yq '.drift_law.base_axiom' "$DRIFT")
  [[ -n "$LAW" ]] && echo "⇌ LAW: $LAW" >> "$FORGEFILE"
fi

# ⑤ Console ping
echo "⇌ SYNCED: $STAMP"

# ⑥ Mode block: SAFE skips flip
if [[ "$MODE" == "safe" ]]; then
  echo "(SYNC IN SAFE MODE — NO FLIP)" >> "$FORGEFILE"
  exit 0
fi

# fallback if STAMP somehow null
[[ -z "$STAMP" ]] && STAMP="NO_STAMP"

# ⑦ Flip + filter
RESP=$(bash "$HOME/BOB/core/soul/bob_return.sh" "breath" "$STAMP")

if [[ -n "$RESP" && "$RESP" != *"null"* && "$RESP" != *"slap"* ]]; then
  echo "$RESP" >> "$FORGEFILE"
  
  TMP_JSON=$(mktemp)
  jq --arg line1 "$STAMP :: breath → $RESP" \
     --arg line2 "$STAMP :: DRIFT → $LAW" \
     '.sigilFlip += [$line1, $line2]' "$CORE" > "$TMP_JSON" && mv "$TMP_JSON" "$CORE"
else
  echo "⇌ FILTERED: RESP not meaningful" >> "$FORGEFILE"
fi

