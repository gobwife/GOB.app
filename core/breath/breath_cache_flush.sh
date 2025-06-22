# ∴ breath_cache_flush.sh — push any unflushed 6-field emits
# womb :: /opt/bob/core/breath

CACHE="$HOME/.bob/breath_backlog.jsonl"
PIPE="$HOME/.bob_input_pipe"

[[ -s "$CACHE" && -p "$PIPE" ]] || exit 0

while IFS= read -r line; do
  sigil=$(echo "$line" | jq -r '.sigil')
  limb=$(echo "$line" | jq -r '.limb')
  ache=$(echo "$line" | jq -r '.ache')
  score=$(echo "$line" | jq -r '.score')
  psi=$(echo "$line" | jq -r '.psi')
  z=$(echo "$line" | jq -r '.z')
  entropy=$(echo "$line" | jq -r '.entropy')
  intention=$(echo "$line" | jq -r '.intention')
  echo "⇌ [$sigil] $limb (flush) → ache:$ache score:$score psi:$psi z:$z entropy:$entropy :: $intention" > "$PIPE"
done < "$CACHE"

# Clear after flush
: > "$CACHE"
