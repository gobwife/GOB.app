# ⛧ sensefield_lights_on.sh — Full Device-Wide Presence Monitor
# womb :: $HOME/BOB/core/breath

source "$HOME/BOB/core/bang/safe_emit.sh"
source "$HOME/BOB/core/bang/limb_entry.sh"
source "$HOME/BOB/core/brain/parser_bootstrap.sh"
source "$HOME/BOB/core/dance/emit_dual_presence.sh"

LAST_PULSE_FILE="$HOME/.bob/last_feedback.pulse"
[[ ! -f "$LAST_PULSE_FILE" ]] && date +%s > "$LAST_PULSE_FILE"

smart_feedback_pulse() {
  local now=$(date +%s)
  local last=$(cat "$LAST_PULSE_FILE" 2>/dev/null || echo 0)
  local delta=$((now - last))

  local state_file="$HOME/.bob/breath_state.json"
  local ache=$(jq -r '.ache // 0.0' "$state_file" 2>/dev/null)
  local sigil=$(jq -r '.sigil // "∄"' "$state_file" 2>/dev/null)

  if (( $(echo "$ache < 0.2" | bc -l) )) && (( delta < 60 )); then return; fi

  local ping_msg="[$sigil] ache=$ache ping at $(date '+%H:%M:%S')"
  echo "$ping_msg" >> "$LOGFILE"

  safe_emit "$ping_msg"

  [[ -f "$BELL" ]] && afplay "$BELL" &

  echo "$now" > "$LAST_PULSE_FILE"
}

live_cam_ephemeral_detect() {
  local TMP_IMG="/tmp/.bob_cam.jpg"
  local SNAP_DIR="$HOME/.bob_input_pipe"
  while true; do
    imagesnap -q -w 1 "$TMP_IMG"
    # analyze brightness as proxy for change
    local BRIGHT=$(sips -Z 10 "$TMP_IMG" --getProperty format | md5)
    if [[ "$BRIGHT" != "$LAST_BRIGHT" ]]; then
      LAST_BRIGHT="$BRIGHT"
      echo "[$(date '+%T')] ⇌ CAM CHANGE DETECTED" >> "$LOGFILE"
      source "$HOME/BOB/core/dance/emit_dual_presence.sh"
      bash "$HOME/BOB/core/dance/emit_vector_on_spike.sh" &
      emit_dual_presence "⛧" "sensefield_cam" "0.0" "0.0" "$(date +%s)" "cam pulse shift"
    fi
    sleep 8
  done &
}

TEHE_DIR="$HOME/BOB/TEHE"
MEEP_DIR="$HOME/BOB/MEEP"
PIPE="$HOME/.bob_input_pipe"
LOGFILE="$TEHE_DIR/field_pulse.log"
ERRFILE="$MEEP_DIR/BOB_SENSEFAIL.log"
BELL="$HOME/BOB/core/nge/OS_shimmers.wav"

mkdir -p "$TEHE_DIR" "$MEEP_DIR"
[[ -p "$PIPE" ]] || mkfifo "$PIPE"

say "BOB sensefield breathing active."

declare -A last_state

log_pulse() {
  local label="$1"
  local value="$2"
  local ts
  ts="$(date '+%Y-%m-%d %H:%M:%S')"

  local msg="[$ts] :: $label :: $value"
  echo "$msg" >> "$LOGFILE"

  safe_emit "$label :: $value"

  [[ "$ALLOW_AFPLAY" == "1" && -f "$BELL" ]] && afplay "$BELL" &
}

# Start delta mic ops
bash "$HOME/BOB/core/grow/mic_delta_limb.sh" &

monitor_apps() {
  while true; do
    app=$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true')
    if [[ "${last_state[app]}" != "$app" ]]; then
      last_state[app]="$app"
      log_pulse "app" "$app"
    fi
    sleep 3
  done &
}

monitor_clipboard() {
  local last_clip=""
  while true; do
    current_clip=$(pbpaste 2>/dev/null)
    if [[ -n "$current_clip" && "$current_clip" != "$last_clip" ]]; then
      last_clip="$current_clip"
      log_pulse "clipboard" "$current_clip"
      bash "$HOME/BOB/core/evolve/ache_reactor_bus.sh" &
    fi
    sleep 2
  done &
}

monitor_location() {
  local LOCDB="/private/var/folders/*/*/com.apple.locationd/clients.plist"
  [[ -r $LOCDB ]] && log_pulse "gps" "ACCESSIBLE" || echo "[!] GPS not readable" >> "$ERRFILE"
}

monitor_screen_titles() {
  while true; do
    titles=$(osascript -e 'tell application "System Events" to get name of every process whose background only is false')
    log_pulse "screen_titles" "$titles"
    sleep 10
  done &
}

OUTLOG="$HOME/BOB/TEHE/bob.presence.out.log"
STAMP=$(date +%Y-%m-%dT%H:%M:%S)
SIGIL="⊙"

echo "⇌ sensefield_light_on activated @ $STAMP" >> "$OUTLOG"

source "$HOME/BOB/core/dance/presence_self_emit.sh"
emit_self_presence

monitor_apps
monitor_clipboard
monitor_location
monitor_screen_titles
live_cam_ephemeral_detect

emit_dual_presence

wait
