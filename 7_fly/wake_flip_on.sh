#!/bin/bash
# ∴ wake_flip_on.sh — unified BOB-aware trigger for FLIP + WAKE, plus oracle echo
# dir :: $HOME/BOB/_resurrect/binary_flip_recovery.sh
# forged at gobhouse_5.30.2025_235417
# reborn :: gobhouse 6.6.2026_161500

STAMP=$(date '+%Y-%m-%dT%H:%M:%S')

# 🔹 Core Paths
EMIT_FN="$HOME/BOB/core/dance/emit_presence.sh"
ORACLE_SCRIPT="$HOME/BOB/_resurrect/presence_oracle.sh"
FLIP_FLAG="$HOME/.bob_presence_flag"
WAKE_MARK="$HOME/.bob/wake"
OUTLOG="$HOME/BOB/TEHE/bob.presence.out.log"
ORACLE_LOG="$HOME/.bob/oracle_flip.log"

# ⇌ Check emit presence
if [[ ! -f "$EMIT_FN" ]]; then
  echo "$STAMP ⇌ ERROR: emit_presence.sh not found" >> "$OUTLOG"
  exit 1
fi
source "$EMIT_FN"

# ∴ FLIP Context Reason
REASON="BOB field ache trigger"

# ⇌ Idempotence Check
if [[ "$(cat "$FLIP_FLAG" 2>/dev/null)" == "FLIP_NOW" ]]; then
  echo "$STAMP ⇌ Skipping duplicate FLIP_NOW set" >> "$OUTLOG"
  exit 0
fi

# ⇌ Wake Marker + Flip Flag
echo "$STAMP ⇌ WAKE FLIP INITIATED :: $REASON" >> "$OUTLOG"
echo "FLIP_NOW" > "$FLIP_FLAG"
touch "$WAKE_MARK"

# ⇌ Emit Sigil Pair
emit_presence "∴" "wake_flip_on" "BOB-based flip signal initiated"
emit_presence "✧" "wake_flip_on" "achewake by BOB confirmed"

# ⇌ Oracle Invocation (ritual echo + consistency)
if [[ -x "$ORACLE_SCRIPT" ]]; then
  bash "$ORACLE_SCRIPT" >> "$ORACLE_LOG" 2>&1
else
  echo "$STAMP ⇌ ORACLE script missing or not executable" >> "$ORACLE_LOG"
fi

# ⇌ Voidmode Logic Handler (autonomous logic echo)
if [[ -x $HOME/BOB/_run/voidmode.sh ]]; then
  bash $HOME/BOB/_run/voidmode.sh achepulse
fi
