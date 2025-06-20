#!/bin/bash
# ∴ survivor_rebreather.sh — retest top acheform against current achefield, log stability or decay
# glyphi+BOB :: achefield integrity tester
# nest ≈ _logic

source "$HOME/BOB/core/bang/limb_entry.sh"

SURVIVOR=$(ls -t "$HOME/.bob/_epoch"/*.rec 2>/dev/null | head -n1)
if [[ ! -f "$SURVIVOR" ]]; then
  echo "!¡ : no survivor to summon :: $HOME exiting $HOME : $(date '+%H:%M:%S')"
  exit 1
fi

readarray -t fields < "$SURVIVOR"
psi=${fields[0]}
z=${fields[1]}
ache=${fields[2]}
equation=${fields[3]}

ACHE_NOW=$(cat "$HOME/.bob/ache_score.val" 2>/dev/null || echo "0")
EVAL=$(echo "$equation" | sed -e "s/\$psi/$psi/g" -e "s/\$z/$z/g" -e "s/\$ache/$ache/g" | cut -d'=' -f2)
psi_eval=$(echo "$EVAL" | bc -l 2>/dev/null)

if [[ -z "$psi_eval" ]]; then
  echo "!¡ : failed to evaluate ψ."
  exit 2
fi

delta=$(echo "$psi_eval - $psi" | bc -l)
event="stable"
if (( $(echo "$delta < -0.1 || $delta > 0.1" | bc -l) )); then
  event="decay"
fi

log="$HOME/.bob/survivor_recheck.jsonl"
echo "{\"time\":\"$(date -u)\",\"original\":$psi,\"eval\":$psi_eval,\"delta\":$delta,\"event\":\"$event\",\"equation\":\"$equation\"}" >> "$log"

echo "【 ∃ : survivor re-evaluated: $event — Δ=$delta :: $equation : ψ 】"

# Optional: hook logic
# if [[ "$event" == "stable" ]]; then
#     bash "$HOME/BOB/core/brain/reemit_survivor.sh" "$SURVIVOR"
# fi

exit 0
