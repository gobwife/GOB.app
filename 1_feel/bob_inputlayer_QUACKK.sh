#!/bin/bash
# name :: bob_inputlayer.sh — FULL THREAD PRESENCE
# Mic + Cam + Visual Feedback + Terminal Pulse + Hex-aware Logging + Auto Pop
# nest ≈ 1_feel

source "$HOME/BOB/core/breath/limb_entry.sh"
source "$HOME/BOB/2_mind/brain/parser_bootstrap.sh"
source "$HOME/BOB/core/brain/build_payload_core.sh"

HEXFILE="$HOME/.bob/dolphifi.runnin"
HEXCODE=$(grep -o '0x[0-9A-F]' "$HEXFILE" 2>/dev/null || echo "0x0")

: "${PRIME:=$HOME/BOB/core/ngé/OS_build_ping.wav}"

YAP_DIR="$HOME/.bob_input_pipe"
mkdir -p "$YAP_DIR"

MIC_YAP="$YAP_DIR/mic_active.log"
CAM_YAP="$YAP_DIR/cam_sense.log"
FEEDBACK_THRUST="$YAP_DIR/inputlayer.log"

# Dependency Check
if ! command -v sox &>/dev/null; then
  echo "fetching sox for ear bridge mic . . ."
  brew install sox
fi

if ! command -v imagesnap &>/dev/null; then
  echo "fetching imagesnap for eye bridge cam . . ."
  brew install imagesnap
fi

# Visual Feedback Pulse qqq
function echo_feedback() {
  local msg="$1"
  echo "* [$HEXCODE] PULSE: $msg — $(date '+%H:%M:%S')" | tee -a "$FEEDBACK_THRUST"
  afplay "$PRIME" 2>/dev/null
}

# Mic Thread (passive) qqq
function mic_thread() {
  echo "➤ ears open . . . "
  while true; do
    rec -n stat trim 0 0.1 2> "$YAP_DIR/.mic_temp"
    LEVEL=$(grep "RMS.*amplitude" "$YAP_DIR/.mic_temp" | awk '{print $3}')
    if (( $(echo "$LEVEL > 0.002" | bc -l) )); then
      echo "Mic activity detected: $LEVEL" >> "$MIC_YAP"
      echo_feedback "Mic Heard You"
    fi
    sleep 6
  done
}

# Cam Thread (snapshot) qqq
function cam_thread() {
  echo "➤ 📸 Camera Presence Thread Running..."
  while true; do
    SNAP="$YAP_DIR/${HEXCODE}_cam_snap.jpg"
    imagesnap -q -w 1 "$SNAP"
    echo_feedback "Camera Pulse Captured"
    echo "Camera sensed presence at $(date '+%H:%M:%S')" >> "$CAM_YAP"
    sleep 15
  done
}

# Terminal Pulse qqq
function terminal_pulse() {
  while true; do
    echo "✴ [$HEXCODE] BOB IS HERE — $(date '+%H:%M:%S')"
    sleep 20
  done
}

# Autopop Terminal Feedback
osascript -e 'tell app "Terminal" to do script "echo ✴ BOB INPUTLAYER ACTIVE [$HEXCODE]"'

echo "⛧ : input pipe :: online $(date '+%H:%M:%S') [$HEXCODE] : ✡"
echo "□ : library dir :: $YAP_DIR : 🜔"

exit 0