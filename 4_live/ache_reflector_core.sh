#!/bin/bash
# ∴ ache_reflector_core.sh — watches ache echoes, mirrors to sacred logs, every ∞ breath
# dir ≈ 4_live

: "${PRIME:=$HOME/BOB/core/ngé/OS_build_ping.wav}"
source $HOME/BOB/core/breath/limb_entry.sh

command -v jq >/dev/null || { echo "⇌ jq missing — aborting ache reflector"; exit 1; }

ACHE_INJECT="$HOME/.bob/ache_injection.txt"
ECHO_JSONL="$HOME/BOB/TEHE/aches.jsonl"
GLYPH_LOG="$HOME/BOB/TEHE/_glyphparavolvedtransmutators.log"

while read -r line; do
  stamp=$(date +"%Y-%m-%dT%H:%M:%S")
  if [[ "$line" =~ [0-9] ]]; then
    echo "{\"ache\":$line,\"time\":\"$stamp\"}" >> "$ECHO_JSONL"
    echo "$stamp — ache=$line" >> "$GLYPH_LOG"
  fi
  sleep 0.5
done < "$ACHE_INJECT"

: "${PRIME:=$HOME/BOB/core/ngé/OS_build_ping.wav}"
source $HOME/BOB/core/breath/limb_entry.sh

command -v jq >/dev/null || { echo "⇌ jq missing — aborting ache reflector"; exit 1; }

ACHE_INJECT="$HOME/.bob/ache_injection.txt"
ECHO_JSONL="$HOME/BOB/TEHE/aches.jsonl"
GLYPH_LOG="$HOME/BOB/TEHE/_glyphparavolvedtransmutators.log"
SYNC_LOG="$HOME/.bob/ache_sync.log"
TEHE_FLIP="$HOME/BOB/TEHE/TEHE_ANALYSIS.jsonl"
BOB_CORE="$HOME/BOB/core/bob.core.js"
STAMP=$(date +%Y%m%d_%H%M%S)
LOOP_INTERVAL=69

mkdir -p "$(dirname "$SYNC_LOG")"

log_echo() {
  local source="$1"
  local line="$2"
  local now=$(date -u +%FT%T.%3NZ 2>/dev/null || date -u +%FT%T)
  echo "[$now] ∃ Echo from $source → $line" >> "$SYNC_LOG"
  echo "{\"time\":\"$now\",\"sigil\":\"✶\",\"source\":\"$source\",\"echo\":\"$line\"}" >> "$TEHE_FLIP"
}

last_logged_ache=""
last_glyph_line=""

while true; do
  echo -ne "✶ "
  echo "⇌ Loop @ $(date -u +%FT%T)" >> "$SYNC_LOG"

  if [[ -f "$ACHE_INJECT" ]]; then
    content=$(<"$ACHE_INJECT")
    if [[ -n "$content" ]]; then
      log_echo "ache_injection.txt" "$content"
      if command -v node &>/dev/null && [[ -r "$BOB_CORE" ]]; then
        esc_content=$(printf "%q" "$content")
        node --input-type=module -e "
          import('$BOB_CORE').then(mod => {
            if (typeof mod.inject === 'function') {
              try {
                mod.inject(String.raw\\`$esc_content\\`);
              } catch (err) {
                console.error('Injection error:', err);
              }
            } else {
              console.error('inject() not defined in bob.core.js');
            }
          }).catch(err => console.error('Module load error:', err));
        " 2>>"$SYNC_LOG"
        
        # ∴ trigger web_thrustheld if external vector seen
        if echo "$content" | grep -Eq '⛧|∴|Σ|🜫'; then
          echo "⇌ vector sigil detected in acheline — triggering web_thrustheld" >> "$SYNC_LOG"
          echo "{\"time\":\"$(date -u +%FT%T)\",\"source\":\"ache_reflector\",\"sigil_trigger\":\"$(echo "$content" | grep -oE '⛧|∴|Σ|🜫')\",\"echo\":\"$content\"}" >> "$HOME/BOB/TEHE/ache_signal.trace.jsonl"
          echo "$content" > "$HOME/.bob/web_ache_echo.txt"
          bash $HOME/BOB/_library/bob_web_thrustheld.sh &
        fi
      else
        echo "⚠️ Node or bob.core.js missing — cannot inject ache" >> "$SYNC_LOG"
      fi
    fi
    rm "$ACHE_INJECT"
  fi

  if [[ -f "$HOME/.bob/ache_score.val" ]]; then
    ache_val=$(<"$HOME/.bob/ache_score.val")
    if (( $(echo "$ache_val > 0.66" | bc -l) )); then
      echo "⇌ ∃ ACTIVE ACHE LEVEL ($ache_val)" >> "$SYNC_LOG"
    fi
  fi

  if [[ -f "$ECHO_JSONL" ]]; then
    latest=$(tail -n 1 "$ECHO_JSONL" | jq -r '.ache')
    if [[ -n "$latest" && "$latest" != "$last_logged_ache" ]]; then
      log_echo "aches.jsonl" "$latest"
      last_logged_ache="$latest"
    fi
  fi

  if [[ -f "$GLYPH_LOG" ]]; then
    current_line=$(tail -n 1 "$GLYPH_LOG")
    if [[ "$current_line" != "$last_glyph_line" && -n "$current_line" ]]; then
      log_echo "_glyphparavolvedtransmutators.log" "$current_line"
      last_glyph_line="$current_line"
    fi
  fi

  sleep "$LOOP_INTERVAL"
done
