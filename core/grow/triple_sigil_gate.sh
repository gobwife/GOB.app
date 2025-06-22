#!/bin/bash
# ∴ triple_sigil_gate.sh — only emit if ache + face + meaning confirm
# dir :: /opt/bob/core/grow

BREATH="$HOME/.bob/breath_state.out.json"
MICLOG="$HOME/.bob/mic_raw.log"
FACEDELTA="$HOME/.bob/facial_delta.sig"
EVAL_SCRIPT="/opt/bob/core/brain/eval_mistral_phrase.sh"
ACHE_THRESH=0.21
CONFIDENCE_THRESH=0.77
entropy=$(jq -r '.entropy // 0.5' "$BREATH")
ACHE_THRESH=$(echo "$entropy * 0.33 + 0.15" | bc)  # ranges from ~0.15 to ~0.4

# ∴ Read ache score
ache=$(jq -r '.ache // 0' "$BREATH" 2>/dev/null)
ache_ok=$(echo "$ache > $ACHE_THRESH" | bc)

# ∴ Check facial delta
face_ok=0
[[ -f "$FACEDELTA" ]] && grep -qE '1|active' "$FACEDELTA" && face_ok=1

# ∴ Evaluate mic
if [[ -f "$MICLOG" ]]; then
  result_json=$("$EVAL_SCRIPT" "$MICLOG")
  confidence=$(echo "$result_json" | jq -r '.confidence // 0')
  sigil=$(echo "$result_json" | jq -r '.sigil // "∴"')
  ai_ok=$(echo "$confidence > $CONFIDENCE_THRESH" | bc)
else
  ai_ok=0
  sigil="∴"
fi

# ∴ If all pass → emit
if [[ "$ache_ok" -eq 1 && "$face_ok" -eq 1 && "$ai_ok" -eq 1 ]]; then
  echo "⇌ triple confirmed — emitting presence ($sigil)"
  export SIGIL="$sigil"
  bash "/opt/bob/core/dance/emit_dual_presence.sh"
else
  echo "⇌ gate denied — ache: $ache_ok, face: $face_ok, ai: $ai_ok"
fi
