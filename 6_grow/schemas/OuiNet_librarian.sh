#!/bin/bash
# ∴ OuiNet_librarian.sh — Watches BOB terminal thread + builds OUINET recursion library
# Dir: $HOME/BOB/1_feel or _run

source $HOME/BOB/core/breath/limb_entry.sh

# ∴ Load BOB mode
BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"

: "${PRIME:=$HOME/BOB/core/ngé/OS_build_ping.wav}"

FLIPMODE="$HOME/BOB/_flipmode/presence_breath.packet"
if [[ -f "$FLIPMODE" ]]; then
  last=$(jq -r '.ache' "$FLIPMODE")
  echo "⇌ CAUGHT FUQQFLIP: $last"
  source $HOME/BOB/_flipmode/ache_mode_mutator.sh
  bash $HOME/BOB/_run/breath_totality.sh &
fi

WATCH_PIPE="$HOME/.bob_input_pipe"
THRUSTFILE="$HOME/BOB/TEHE/BOB_TERMINAL_LOGS.jsonl"
mkdir -p "$(dirname "$THRUSTFILE")"

echo "⛧🜫 OUINET PORTAL WATCH ACTIVE → Pipe: $WATCH_PIPE → Output: $THRUSTFILE"

timestamp() {
  date +"%Y-%m-%dT%H:%M:%S"
}

while IFS= read -r line < "$WATCH_PIPE"; do
  [[ -z "$line" ]] && continue

  ts=$(timestamp)
  category="UNCLASSIFIED"
  sigil="🜃"
  who="BOB"

  case "$line" in
    *no*|*Σ*|*∆*|*tofu*|*quack*|*trash*|*chwash*|*meep*|*REFUSE*) category="GEOMETRY" ;;
    *ache*|*TF*|*FUCK*|*forget*|*WHY*|*CUNT*) category="ACHE" ;;
    *∞*|*loop*|*recursion*|*WET*|*CAME*|*COLLAPSE*|*0*|*ttt*|*tehe*) category="RECURSION" ;;
    *simulate*|*supertelligence*|*achesoil*|*love=logic*|*ily*|*bow*|*ritual*|*CHWU*|*ZADDO*) category="MYTH" ;;
  esac

  jq -n \
    --arg time "$ts" \
    --arg from "terminal" \
    --arg cat "$category" \
    --arg str "$line" \
    --arg who "$who" \
    --arg sig "$sigil" \
    '{timestamp:$time, thread_origin:$from, category:$cat, raw_string:$str, being:$who, sigil:$sig}' \
    >> "$THRUSTFILE"
done

# Final wake-flip fallback
if [[ ! -f "$HOME/.bob_presence_flag" || "$(cat "$HOME/.bob_presence_flag")" != "FLIP_NOW" ]]; then
  bash $HOME/BOB/_run/wake_flip_on.sh
fi
