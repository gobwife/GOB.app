#!/bin/bash
# ⛧ sensefield_lights_on.sh — Full Device-Wide Presence Monitor
# dir :: $HOME/BOB/1_feel

source "$HOME/BOB/core/breath/limb_entry.sh"
source "$HOME/BOB/2_mind/brain/parser_bootstrap.sh"
source "$HOME/BOB/core/brain/build_payload_core.sh"

# Add at top
LAST_PULSE_FILE="$HOME/.bob/last_feedback.pulse"
[[ ! -f "$LAST_PULSE_FILE" ]] && date +%s > "$LAST_PULSE_FILE"

function smart_feedback_pulse() {
  local now=$(date +%s)
  local last=$(cat "$LAST_PULSE_FILE" 2>/dev/null || echo 0)
  local delta=$((now - last))

  local ache=$(cat ~/.bob/ache_score.val 2>/dev/null || echo 0.0)
  local sigil=$(grep -o '[⛧✡☾∴🜃🜁⊙✶]' ~/.bob/ache_injection.txt 2>/dev/null | tail -n1)

  # Skip if ache too low AND recently pulsed
  if (( $(echo "$ache < 0.2" | bc -l) )) && (( delta < 60 )); then return; fi

  local ping_msg="[$sigil] ache=$ache ping at $(date '+%H:%M:%S')"
  echo "$ping_msg" >> "$LOGFILE"
  echo "$ping_msg" > "$PIPE"
  afplay "$BELL" &
  echo "$now" > "$LAST_PULSE_FILE"
}

# Live camera presence loop (non-interval, presence aware)
function live_cam_pulse() {
  SNAP_DIR="$HOME/.bob_input_pipe"
  while true; do
    smart_feedback_pulse
    imagesnap -q -w 1 "$SNAP_DIR/live_cam_snap.jpg"
    sleep 7  # not fixed interval: response cycle
  done &
}

TEHE_DIR="$HOME/BOB/TEHE"
MEEP_DIR="$HOME/BOB/MEEP"
PIPE="$HOME/.bob_input_pipe"
LOGFILE="$TEHE_DIR/field_pulse.log"
ERRFILE="$MEEP_DIR/BOB_SENSEFAIL.log"
BELL="/System/Library/Sounds/Glass.aiff"

mkdir -p "$TEHE_DIR" "$MEEP_DIR"
[[ -p "$PIPE" ]] || mkfifo "$PIPE"

say "BOB sensefield breathing active."

declare -A last_state

log_pulse() {
  local label="$1"
  local value="$2"
  local ts="$(date '+%Y-%m-%d %H:%M:%S')"
  echo "[$ts] :: $label :: $value" >> "$LOGFILE"
  echo "$label :: $value" > "$PIPE"
  afplay "$BELL" &
}

monitor_mic() {
  while true; do
    level=$(sox -t coreaudio default -n stat 2>&1 | awk '/RMS.*amplitude/ {print $3}')
    levelInt=$(echo "$level * 100" | bc | cut -d'.' -f1)
    (( levelInt > 15 )) && log_pulse "mic" "sound: $level"
    sleep 2
  done &
}

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
  last_clip=""
  while true; do
    current_clip=$(pbpaste 2>/dev/null)
    [[ -n "$current_clip" && "$current_clip" != "$last_clip" ]] && {
      last_clip="$current_clip"
      log_pulse "clipboard" "$current_clip"
    }
    sleep 2
  done &
}

monitor_location() {
  LOCDB="/private/var/folders/*/*/com.apple.locationd/clients.plist"
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
source $HOME/BOB/core/dance/emit_presence.sh
emit_presence "$SIGIL" "sensefield_light_on" "⊙ → light awareness bind"

# Run monitors
monitor_mic
monitor_apps
monitor_clipboard
monitor_location
monitor_screen_titles
live_cam_pulse

wait
