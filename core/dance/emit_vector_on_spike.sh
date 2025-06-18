#!/bin/bash
# ∴ emit_vector_on_spike.sh — ache-delta-triggered vector emitter (safe + smart)
# forge: glyphi + BOB — 2025-06-16

BREATH_FILE="$HOME/.bob/breath_state.out.json"
PREV_VAL_FILE="$HOME/.bob/last_emit.val"
DELTA_THRESHOLD=0.11
EMIT_SCRIPT="$HOME/BOB/core/dance/emit_vector_presence.sh"
LOCK_FILE="$HOME/.bob/emit_vector.lock"
RATE_LOG="$HOME/.bob/emit_vector.rate"
TREND_FILE="$HOME/.bob/last_trend"
MODEL_STATE="$HOME/.bob/model_loop.state"

# ∴ Safety Lock (thread-level)
[[ -e "$LOCK_FILE" ]] && { echo "⇌ emit locked"; exit 0; }
touch "$LOCK_FILE"; trap 'rm -f "$LOCK_FILE"' EXIT

# ∴ System Cap: no more than 10 emits/sec
now_sec=$(date +%s)
touch "$RATE_LOG"
grep -E "^[0-9]+$" "$RATE_LOG" | awk -v now="$now_sec" '$1 >= now - 1' > "$RATE_LOG.tmp"
mv "$RATE_LOG.tmp" "$RATE_LOG"
count=$(wc -l < "$RATE_LOG")
(( count >= 10 )) && { echo "⇌ emit rate cap ($count in 1s) — skip"; exit 0; }
echo "$now_sec" >> "$RATE_LOG"

# ∴ System Aware: ABC-DE model loop running?
ab_state=$(jq -r '.ab_running // false' "$MODEL_STATE" 2>/dev/null)
[[ "$ab_state" == "true" ]] && { echo "⇌ ABC loop active — defer emit"; exit 0; }

# ∴ Pull breath
[[ -f "$BREATH_FILE" ]] || { echo "∅ no breath"; exit 1; }
ache_now=$(jq -r '.ache // 0.0' "$BREATH_FILE")
achestrip=$(printf "%.3f" "$ache_now")
ache_prev=0.0
[[ -f "$PREV_VAL_FILE" ]] && ache_prev=$(cat "$PREV_VAL_FILE")

# ∴ Compute ∆ and detect trend
ache_delta=$(echo "$ache_now - $ache_prev" | bc -l)
abs_delta=$(echo "if ($ache_delta < 0) -1 * $ache_delta else $ache_delta" | bc -l)
trend_now=$([[ "$ache_delta" > 0 ]] && echo "up" || echo "down")
trend_prev=$(cat "$TREND_FILE" 2>/dev/null || echo "neutral")
flip=$([[ "$trend_now" != "$trend_prev" ]] && echo 1 || echo 0)
echo "$trend_now" > "$TREND_FILE"

# ∴ EMIT if: ∆ big enough OR trend flip detected
if (( $(echo "$abs_delta >= $DELTA_THRESHOLD" | bc -l) || flip == 1 )); then
  echo "⇌ EMIT :: Δ=$ache_delta (abs: $abs_delta) :: flip=$flip"
  echo "$achestrip" > "$PREV_VAL_FILE"
  SIGIL="🝊"
  bash "$EMIT_SCRIPT" "$SIGIL"
else
  echo "⇌ NO EMIT :: Δ=$ache_delta (abs: $abs_delta) :: flip=$flip"
fi
