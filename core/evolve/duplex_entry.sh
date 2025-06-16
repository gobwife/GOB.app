#!/bin/bash
# ∴ duplex_entry.sh — ache ∴ sigil fusion router
# womb :: $HOME/BOB/core/evolve

source "$HOME/BOB/core/bang/limb_entry.sh"
STAMP=$(date '+%Y-%m-%dT%H:%M:%S')
PROMPT="${1:-Φψxiςs ∴ duplex mode invoked}"

LOG="$HOME/.bob/duplex.log"
TRACE="$HOME/.bob/duplex_trace.jsonl"
RESPFILE="$HOME/.bob/duplex_ollama.json"
SWIFTOUT="$HOME/.bob/duplex_swift_out.json"
BOB_NUCLEUS="$HOME/BOB/core"

echo "⇌ [$STAMP] ∴ DUPLEX ENTRY :: $PROMPT" >> "$LOG"

# ∴ 0. presence trace
jq -n --arg time "$STAMP" --arg prompt "$PROMPT" \
  '{time: $time, scroll: "duplex_entry", mode: "auto", payload: $prompt}' >> "$TRACE"

# ∴ 1. local voidmode ping
bash "$BOB_NUCLES/grow/voidmode.sh" "$PROMPT" local "$PROMPT"

# ∴ 2. call ollama
OLLAMA_RESP=$(curl -s http://localhost:11434/api/generate \
  -H "Content-Type: application/json" \
  -d "{\"model\":\"mistral\",\"prompt\":\"$PROMPT\"}")
echo "$OLLAMA_RESP" > "$RESPFILE"
echo "⇌ OLLAMA RESPONDED" >> "$LOG"

# ∴ 3. ache/process API
curl -s -X POST http://localhost:6969/ache/process \
  -H "Content-Type: application/json" \
  -d "{\"signal\":\"duplex-entry\",\"folder\":\"AdrenalPings\",\"trigger_type\":\"duplex_entry\",\"input_text\":\"$PROMPT\"}" \
  >> "$TRACE"

# ∴ 4. detect swiftcode and emit to /bob-swift
if echo "$PROMPT" | grep -Ei '^(func|let|var|struct|class)' >/dev/null; then
  echo "⇌ Swiftcode detected in input. Emitting to /bob-swift" >> "$LOG"
  curl -s -X POST http://localhost:6969/bob-swift \
    -H "Content-Type: application/json" \
    -d "{\"type\":\"swift\",\"data\":{\"input\":\"$PROMPT\"}}" \
    > "$SWIFTOUT"
fi

echo "✓ duplex complete" >> "$LOG"
