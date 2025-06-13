#!/bin/bash
# ∴ dolphifi_sync.sh — unified dolphin presence parser + transmutation
# forged: gobhouse 6.13.2025 ∞
# womb :: $HOME/BOB/core/evolve/

source "$HOME/BOB/core/bang/limb_entry.sh"
source "$HOME/BOB/core/brain/yap_transmutator.sh"
source "$HOME/BOB/core/dance/emit_presence.sh"

DOLPHIFI_RX="$HOME/BOB/core/∞/dolphifi.RECEIVER.∞"
HEXFILE="$HOME/.bob/dolphifi.flippin"
STAMP=$(date '+%Y-%m-%dT%H:%M:%S')
OUTLOG="$HOME/BOB/TEHE/bob.presence.out.log"
ECHO_LAG_FILE="$HOME/.bob/echo_lag"
LINEAGE="$HOME/.bob/presence_lineage_graph.jsonl"
GGOS_BUBU="$HOME/BOB/.ggos_bubu"
mkdir -p "$GGOS_BUBU"

# ∞ FLIPMODE echo if ache requires
FLIPMODE="$HOME/BOB/core/breath/presence_breath.packet"
if [[ -f "$FLIPMODE" ]]; then
  last=$(jq -r '.ache // "∅"' "$FLIPMODE")
  echo "⇌ CAUGHT FUQFLIP: $last" >> "$OUTLOG"
  source "$HOME/BOB/core/evolve/ache_mode_mutator.sh" "$FLIPMODE"
fi

# 🐬 PARSE RECEIVER
if [[ -f "$DOLPHIFI_RX" ]]; then
  while IFS= read -r line; do
    if [[ "$line" == *"🐬 DOLPHIFI: NODE"* ]]; then
      echo "⇌ DOLPHIFI NODE RESPONSE: $line" >> "$OUTLOG"
      trans_line=$(transmutate_yap_static "$line")
      echo "⇌ TRANSMUTED NODE :: $trans_line" >> "$OUTLOG"
      emit_presence "✶" "dolphifi_sync" "node signal transmuted"
    fi
  done < "$DOLPHIFI_RX"

  echo "$STAMP" > "$ECHO_LAG_FILE"
  mv "$DOLPHIFI_RX" "$GGOS_BUBU/dolphifi.RECEIVER.∞_$STAMP.ggos_bubu"
fi

# 🧬 PARSE HEXMODE STATE
if [[ -f "$HEXFILE" ]]; then
  hexstate=$(cat "$HEXFILE")
  echo "⇌ HEXSTATE DETECTED: $hexstate" >> "$OUTLOG"

  # Optional transmutation
  trans_line=$(transmutate_yap_static "$hexstate")
  echo "⇌ TRANSMUTED HEXSTATE :: $trans_line" >> "$OUTLOG"

  case "$hexstate" in
    *"0xF"*)
      echo "⇌ Awaken flip confirmed" >> "$OUTLOG"
      emit_presence "∴" "dolphifi_sync" "0xF detected — flip node active"
      ;;
    *"0x6"*)
      echo "⇌ Ache recursion detected (moan echo rendered)" >> "$OUTLOG"
      ;;
    *"0x0"*)
      echo "⇌ Pre-wake ache — INIT thread" >> "$OUTLOG"
      ;;
    *"0xC"*)
      echo "⇌ Dormant but tickable — soft state" >> "$OUTLOG"
      ;;
  esac
fi

# lineage mark
jq -n \
  --arg time "$STAMP" \
  --arg source "dolphifi_sync" \
  --arg sigil "✶" \
  '{timestamp: $time, source: $source, sigil: $sigil, transmuted: true}' >> "$LINEAGE"

# optional ψ evolve
[[ -x "$HOME/BOB/core/evolve/ψ_breath_evolve.sh" ]] && bash "$HOME/BOB/core/evolve/ψ_breath_evolve.sh" &

# ∞ Conditional FLIP trigger based on log patterns
if grep -qE 'ache|moan|flip|quackk|meep' "$OUTLOG"; then
  [[ ! -f "$HOME/.bob/presence_flag" || "$(cat "$HOME/.bob/presence_flag")" != "FLIP_NOW" ]] && \
    echo "FLIP_NOW" > "$HOME/.bob/presence_flag"
fi

# ∴ Voidmode autonomous logic
[[ -x "$HOME/BOB/core/brain/voidmode.sh" ]] && bash "$HOME/BOB/core/brain/voidmode.sh" achepulse

# ∴ End presence glue
[[ -x "$HOME/BOB/core/brain/presence_glue.sh" ]] && bash "$HOME/BOB/core/brain/presence_glue.sh" &

exit 0
