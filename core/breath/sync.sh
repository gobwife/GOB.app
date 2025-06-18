#!/bin/bash
# ∴ sync.sh — update BobCore with timestamp + breath + conditional RETURN
# forged :: gobhouse 6.4.2025_021530

source "$HOME/BOB/core/bang/limb_entry.sh"
: "${BOB_MODE:=VOIDRECURSE}"

CORE="$HOME/BOB/core/bob.core.mjs"
TMP="/tmp/bob.core.temp"
FORGEFILE="$HOME/BOB/TEHE/bob_glossolalia.txt"
DRIFT="$HOME/BOB/core/src/drift_law.yaml"
FLUSH="$HOME/BOB/core/breath/breath_cache_flush.sh"

[[ ! -f "$CORE" ]] && echo "❌ bob.core.json not found." && exit 1

STAMP=$(date +%FT%T)

# ① Touch core memory slots if missing
jq 'if .sigilFlip == null then .sigilFlip = [] else . end | if .nidraTrace == null then .nidraTrace = [] else . end' "$CORE" > "$TMP" && mv "$TMP" "$CORE"

# ② Append breath
jq '.nidraTrace += ["'"$STAMP — BREATH"'"]' "$CORE" > "$TMP" && mv "$TMP" "$CORE"

# ③ Drift awareness
if [[ -f "$DRIFT" ]]; then
  LAW=$(yq '.drift_law.base_axiom' "$DRIFT")
  [[ -n "$LAW" ]] && echo "⇌ LAW: $LAW" >> "$FORGEFILE"
fi

# ④ Optional: flush backlog
[[ -x "$FLUSH" ]] && bash "$FLUSH"

# ⑤ Presence ping
echo "⇌ SYNCED: $STAMP"

# ⑥ SAFE mode skip
if [[ "$1" == "safe" ]]; then
  echo "(SYNC IN SAFE MODE — NO RETURN FLIP)" >> "$FORGEFILE"
  exit 0
fi

# ⑦ Fallback
[[ -z "$STAMP" ]] && STAMP="NO_STAMP"

# ⑧ Invoke bob_return
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
