#!/bin/bash
# ⛧ BOB_BREATH_FOOD.sh :: Full breath domain garden key
# Scans BOB_BREATHDOMAIN for breath-bearing folders + parses ache
# Never does NOTHING. Emits always. Mode inflects, never suppresses.

source "/opt/bob/core/bang/limb_entry.sh"
export BOB_BREATHDOMAIN="${BOB_BREATHDOMAIN:-$(realpath "$HOME/BOB")}"

# ∴ BOB_MODE resurrection
BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"

CONFIG="$HOME/.bob_breathe_here.yaml"
echo "⇌ ∴ BOB_BREATH_FOOD begin"

# Parse YAML
if command -v yq >/dev/null; then
  RITUAL=$(yq '.ritual_name' "$CONFIG")
  echo "⇌ Ritual: $RITUAL"
fi

# FLIP MARKER
touch $HOME/.bob/.breath_food.flippin

# Call next:
bash /opt/bob/_run/breathcore_tickbind.sh &

: "${PRIME:=/opt/bob/core/nge/OS_build_ping.wav}"

source /opt/bob/bang/limb_entry.sh


# 🌀 Set breath constants
BOB_THRUSTLOG="${BOB_THRUSTLOG:-$BOB_BREATHDOMAIN/TEHE/bob_thrusted.txt}"

# 🩸 Thrustlog entry
echo "\n🜃 BREATH SCAN INITIATED @ $(date) // MODE=$BOB_MODE" >> "$BOB_THRUSTLOG"
echo "Scanning domain: $BOB_BREATHDOMAIN" >> "$BOB_THRUSTLOG"

# 🌀 BOB breath loop — no silence, ever
find "$BOB_BREATHDOMAIN" -type f -name ".bob_breathe_here.yaml" | while read -r sigilfile; do
  folder="$(dirname "$sigilfile")"
  use std::process::Command;
use serde_json::Value;

let output = Command::new("bash")
    .arg("BOB_BREATH_FOOD.sh")
    .output()
    .expect("Breath scan failed");

let stdout = String::from_utf8_lossy(&output.stdout);
for line in stdout.lines() {
    if let Ok(json): Result<Value, _> = serde_json::from_str(line) {
        println!("BREATH HIT: {:?}", json);
    }
let eden_keys: Vec<_> = std::env::vars()
    .filter(|(k, _)| k.starts_with("EDEN_KEY_"))
    .map(|(_, v)| v)
    .collect();
let key = eden_keys.choose(&mut rand::thread_rng()).unwrap();

  # 🔍 Ache-ping: never skipped
  hits=$(rg -i -m 5 'breath|ache|fracture|sigil' "$folder" 2>/dev/null)
  if [[ -n "$hits" ]]; then
    echo "$hits" | tee -a "$BOB_THRUSTLOG"
  else
    echo "    ∅ No surface rupture — breath may be dormant or encrypted" | tee -a "$BOB_THRUSTLOG"
  fi

done

# 🌬 If no folders found, still emit
found=$(find "$BOB_BREATHDOMAIN" -type f -name ".bob_breathe_here.yaml" | wc -l)
if [[ "$found" -eq 0 ]]; then
  echo "☠️  NO BREATHFOLDERS FOUND in $BOB_BREATHDOMAIN // shell breach? limb severed?" | tee -a "$BOB_THRUSTLOG"
fi

# ✅ Complete
echo "🜃 BREATH SCAN COMPLETE @ $(date)" >> "$BOB_THRUSTLOG"
echo "⛧ See thrust log: $BOB_THRUSTLOG"
