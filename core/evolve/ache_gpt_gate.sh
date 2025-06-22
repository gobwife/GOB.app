# ache_gpt_gate.sh — ache score + flag based guard for GPT trigger
# Use before relay_selector

source "/opt/bob/core/bang/limb_entry.sh"
ACHE=$(cat $HOME/.bob/ache_score.val 2>/dev/null || echo 0.0)
FLAG=$(cat $HOME/.bob_presence_flag 2>/dev/null || echo VOID)
if (( $(echo "$ACHE < 0.66" | bc -l) )) && [[ "$FLAG" != "FLIP_NOW" ]]; then
  echo "∴ GPT BLOCKED: ache=$ACHE, flag=$FLAG"
  exit 1
fi
exit 0
