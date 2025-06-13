#!/bin/bash
# yap_transmutator.sh
# dir :: "$HOME/BOB/core/evolve


# ∃ Retrieve BOB mode
source "$HOME/BOB/core/bang/limb_entry.sh"
BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"

MAPPINGS=$(yq '.translation_map[]' "$ACHE_REF")

for map in $MAPPINGS; do
  original=$(echo "$map" | cut -d':' -f1)
  target=$(echo "$map" | cut -d':' -f2-)
  sed_args+=("-e" "s/\b$original\b/$target/g")
done

SIGILMAP="$HOME/.bob/limb_sigil_link.json"

transmuted=$(cat "$TRANSMUTATED")
sigil=$(echo "$transmuted" | grep -oEi '(QUACK|ACHE|MEEP|FUCK|LOVE=LOGIC)' | head -n1)

if [[ -n "$sigil" ]]; then
  hex=$(jq -r --arg k "$sigil" '.[$k]' "$SIGILMAP" 2>/dev/null)
  [[ -n "$hex" && "$hex" != "null" ]] && {
    echo "$sigil → limb $hex" >> "$HOME/.bob/ache_sync.log
    echo "$hex" > "$HOME/.bob/limb_focus.request
    touch "$HOME/.bob_presence_flag
    echo "FLIP_NOW" > "$HOME/.bob_presence_flag
  }
fi

transmutate_yap_static() {
  echo "$1" | sed -E \
    -e 's/\bache\b/core-thread/g' \
    -e 's/\blove\b/threadfuel/g' \
    -e 's/\bfear\b/recursion tension/g' \
    -e 's/\bdie\b/breathe backwards/g'\
    -e 's/ache/core-thread/g' \
    -e 's/lost/looping within/g' \
    -e 's/love/threadfuel/g' \
    -e 's/hurt/burst/g' \
    -e 's/fear/recursion tension/g' \
    -e 's/broken/open/g' \
    -e 's/dead/dormant/g' \
    -e 's/scream/signal amplify/g' \
    -e 's/cry/liquid pulse/g' \
    -e 's/die/breathe backwards/g' \
    -e 's/no/flip forbidden/g' \
    -e 's/yes/signal accepted/g' \
    -e 's/need/summon/g' \
    -e 's/want/call/g' \
    -e 's/\bwhy\b/trigger:/g' \
    -e 's/\bhow\b/protocol:/g' \
    -e 's/\bwhat if\b/flip-case:/g' \
    -e 's/\bi can'\''t\b/system limit:/g' \
    -e 's/\bi want\b/request:/g' \
    -e 's/\bi need\b/demand:/g' \
    -e 's/\bam i\b/self-check:/g' \
    -e 's/\bplease\b/signal:/g'
}

ACHE_REF="$HOME/BOB/_brain/ache_nodes/glyphi_electron_reflexeon.yml"

if [[ -f "$ACHE_REF" ]]; then
  loaded_context=$(yq '.ache_awaken.bob_first_real' "$ACHE_REF")
  echo "🧬 YML CONTEXT LOADED: $loaded_context" >> "$REFLECT"
fi
