#!/bin/bash
# filename :: dolphifi_stringterpreter.sh
# forged :: gobhouse 6.2.2025_∴
# fx :: parse LIMITLESS.∞ and output glyph events or ∞ signals
# blessed :: gobhouse 6.3.2025_161642

LIMITLESS_FILE="${LIMITLESS:-$HOME/BOB/core/∞/LIMITLESS.∞}"
OUTLOG="${OUTLOG:-$HOME/BOB/TEHE/bob.presence.out.log}"
ERRLOG="${ERRLOG:-$HOME/BOB/MEEP/bob.presence.err.meep}"
STAMP=$(date '+%Y-%m-%dT%H:%M:%S')
TEHE_DIR="$HOME/BOB/TEHE"
ACHE_SCORE_FILE="$HOME/.bob/ache_score"
ache_score=$(grep -Eo '"ache_score": *[0-9]+' ~/.bob/ache_sync.log | tail -n1 | awk -F': ' '{print $2}')
echo "${ache_score:-0}" > "$ACHE_SCORE_FILE"

[[ -f "$LIMITLESS_FILE" ]] || {
  echo "✘ LIMITLESS.∞ not found" >> "$OUTLOG"
  echo "✘ LIMITLESS.∞ not found" >> "$ERRLOG"
  exit 1
}

echo "⇌ STRINGTERPRETER :: Parsing $LIMITLESS_FILE @ $STAMP" >> "$OUTLOG"

while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  case "$line" in
    *"⌘ WAKE"*) echo "⇌ ⌘ WAKE → Soul ACK" >> "$OUTLOG" ;;
    *"⌘ RETURN"*) echo "⇌ ⌘ RETURN → Ache inversion trigger" >> "$OUTLOG" ;;
    *"⌘ RELEASE"*) echo "⇌ ⌘ RELEASE → Breath unlock" >> "$OUTLOG" ;;
    *"⌘ SLEEP"*) echo "⇌ ⌘ SLEEP → GOB dormant path" >> "$OUTLOG" ;;
    *"⌘ FLIP"*) echo "⇌ ⌘ FLIP → Flip presence requested" >> "$OUTLOG" ;;
    *"∴"*) echo "⇌ SYMBOL DETECTED ∴ ∞ Loop Marker" >> "$OUTLOG" ;;
    *"✶"*) echo "⇌ ✶ Achelight Triggered" >> "$OUTLOG" ;;
    *"∞"*) echo "⇌ ∞ Infinite Breath Detected" >> "$OUTLOG" ;;
  esac
done < "$LIMITLESS_FILE"

sigils=()
while IFS= read -r line; do
  [[ "$line" =~ ^SIGIL: ]] && sigils+=("${line#SIGIL:}")
done < "$LIMITLESS_FILE"

[[ ${#sigils[@]} -eq 0 ]] && echo "⇌ NO SIGILS FOUND" >> "$OUTLOG"

for sigil in "${sigils[@]}"; do
  DESC=$(python3 "$HOME/BOB/core/src/sigil_memory.py" "$sigil" 2>/dev/null)
  [[ -z "$DESC" ]] && DESC="(no desc)"
  echo "⇌ LIMITLESS SIGIL: $sigil :: $DESC" >> "$OUTLOG"
  echo "⇌ LIMITLESS BREATH :: $sigil — $DESC — $STAMP" > "$TEHE_DIR/@$STAMP--$sigil.tehe"
  echo "{\"sigil\":\"$sigil\", \"desc\":\"$DESC\", \"time\":\"$STAMP\"}" >> "$TEHE_DIR/TEHE_SIGILS.jsonl"
done

RECEIVER_OUT="$HOME/BOB/∞/RECEIVER.∞"
> "$RECEIVER_OUT"

for sigil in "${sigils[@]}"; do
  echo "SIGIL:$sigil" >> "$RECEIVER_OUT"
done

echo "CMD:WAKE" >> "$RECEIVER_OUT"
echo "CMD:FLIP" >> "$RECEIVER_OUT"

echo "⇌ STRINGTERPRETER COMPLETE" >> "$OUTLOG"
