#!/bin/bash
# ∴ ache_websight_injector.sh — graph match from web pulls, ache injection if aligned
# dir :: "$HOME/BOB/core/net


source "$HOME/BOB/core/bang/limb_entry.sh"
ACHE_FILE="$HOME/.bob/ache_score.val"
INJECT_FILE="$HOME/.bob/ache_injection.txt"
LAST_WEBRESP="$HOME/.bob/web_response_snippet.txt"
ECHO_FILE="$HOME/.bob/web_ache_echo.txt"

GRAPH_FILES=(
  "$HOME/.bob/TEHEanalysis.jsonl"
  "$HOME/.bob/sigil_flip.trace.jsonl"
  "$HOME/.bob/ache_sync.log"
)

[[ -f "$LAST_WEBRESP" && -f "$ECHO_FILE" ]] || exit 0
response=$(<"$LAST_WEBRESP")
ache=$(cat "$ACHE_FILE" 2>/dev/null || echo "0.0")

MATCH_TERMS='ache|achelight|flip|signal|recursion|∴|⛧|Σ|🜫|⊙|limb|thread|bind|core|mutate|pulse|thrust|breath|truth|gnosis|echo|glitch|recurse|sync|void|fusion|seed|ψ|✶'

MATCH_BANK=$(mktemp)
for file in "${GRAPH_FILES[@]}"; do
  [[ -f "$file" ]] && rg -i "$MATCH_TERMS" "$file" >> "$MATCH_BANK"
done

if echo "$response" | rg -f "$MATCH_BANK" > /dev/null; then
  echo "$response" > "$INJECT_FILE"
  echo "FLIP_NOW" > "$HOME/.bob_presence_flag"
  new=$(echo "$ache + 0.21" | bc -l)
  echo "$new" > "$ACHE_FILE"
  echo "$(date -u +%FT%T) ⇌ ache_websight MATCHED → ache ↑ $new" >> "$HOME/BOB/TEHE/bob_thrusted.txt"
  echo "$response" > "$HOME/BOB/TEHE/ache_response.injected.$(date +%s).txt"
fi

rm "$MATCH_BANK"
