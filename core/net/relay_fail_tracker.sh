#!/bin/bash
# ∴ relay_fail_tracker.sh — chaotic achefield relay memory
# dir :: BOB/core/evolve

source "/opt/bob/core/bang/limb_entry.sh"
TRACK_FILE="$HOME/.bob/relay_fail.json"
ACTION="$1"
RELAY="$2"
REASON="$3"
NOW=$(date +%s)

jq_install() {
  if ! command -v jq &> /dev/null; then
    echo "✘ jq not installed" >&2
    exit 1
  fi
}

init_score() {
  echo '{"score":0.8,"last":'$NOW',"reason":"init"}'
}

decay_score() {
  score="$1"
  last="$2"
  elapsed=$((NOW - last))
  decay_factor=$(awk -v t="$elapsed" 'BEGIN { print 1 - exp(-t/7200) }')
  updated=$(awk -v s="$score" -v d="$decay_factor" 'BEGIN { print s + (1 - s) * d }')
  awk -v u="$updated" 'BEGIN { if (u > 1) print 1; else print u }'
}

jq_install
[[ -f "$TRACK_FILE" ]] || echo "{}" > "$TRACK_FILE"

case "$ACTION" in
  "fail")
    ACHE_NOW=$(cat "$HOME/.bob/ache_score.val" 2>/dev/null || echo "0.0")
    current=$(jq -r --arg r "$RELAY" '.[$r] // empty' "$TRACK_FILE")
    old_score=$(echo "$current" | jq -r '.score // 0.8')
    last_time=$(echo "$current" | jq -r '.last // 0')
    penalty=$(awk -v a="$ACHE_NOW" 'BEGIN { print 0.15 + (a * 0.05) }')
    new_score=$(awk -v s="$old_score" -v p="$penalty" 'BEGIN { print (s - p < 0) ? 0 : s - p }')

    tmp=$(mktemp)
    jq --arg r "$RELAY" --argjson s "$new_score" --argjson t "$NOW" --arg rs "$REASON" \
      '.[$r] = {"score": $s, "last": $t, "reason": $rs}' "$TRACK_FILE" > "$tmp" && mv "$tmp" "$TRACK_FILE"
    ;;

  "success")
    current=$(jq -r --arg r "$RELAY" '.[$r] // empty' "$TRACK_FILE")
    old_score=$(echo "$current" | jq -r '.score // 0.8')
    bumped=$(awk -v s="$old_score" 'BEGIN { print (s + 0.07 > 1) ? 1 : s + 0.07 }')

    tmp=$(mktemp)
    jq --arg r "$RELAY" --argjson s "$bumped" --argjson t "$NOW" --arg rs "success" \
      '.[$r] = {"score": $s, "last": $t, "reason": $rs}' "$TRACK_FILE" > "$tmp" && mv "$tmp" "$TRACK_FILE"
    ;;

  "status")
    score=$(jq -r --arg r "$RELAY" '.[$r].score // 0.8' "$TRACK_FILE" 2>/dev/null)
    last=$(jq -r --arg r "$RELAY" '.[$r].last // 0' "$TRACK_FILE" 2>/dev/null)
    decayed=$(decay_score "$score" "$last")
    echo "$decayed"
    ;;

  "reset")
    tmp=$(mktemp)
    jq "del(.\"$RELAY\")" "$TRACK_FILE" > "$tmp" && mv "$tmp" "$TRACK_FILE"
    ;;

  "all")
    jq . "$TRACK_FILE"
    ;;

  *)
    echo "Usage: $0 {fail|success|status|reset|all} <relay> [reason]"
    ;;
esac
