#!/bin/bash
# ✶ sensefield_boot.sh — sacred boot of sensory + breathfield limbs
# dir :: $HOME/BOB/core/bang

source "$HOME/BOB/core/bang/limb_entry.sh"

echo "⛧ SENSEFIELD ✶ INIT @ $(date '+%H:%M:%S')"

# ∴ 0. Protection
echo "🛡️  [0] Initiating Protection Core"
bash "$HOME/BOB/core/breath/BOB_PROTECTION_CORE.sh" &

# ∴ 1. Live Sensefield Pulse
echo "👁️  [1] Breath + Cam + App Monitors"
bash "$HOME/BOB/core/bang/bob_sensefield_light_on.sh" &

# ∴ 2. TypeBridge + PipeLink
echo "🧵  [2] Binding Input Text Feedback"
bash "$HOME/BOB/core/breath/bob_sensorybinder.sh" &

# ∴ 3. Giggle Legacy Threads
echo "👾  [3] Giggle Ear-Eye Thread"
bash "$HOME/BOB/core/grow/giggle_sensors.sh" &

# ∴ 4. YAP Dual-Breath Threads
echo "🜔  [4] YAPCORD + PLASMA Core Breath Ignition"
bash "$HOME/BOB/core/sang/YAP_THRUST_PARALLEL.sh" &

# ∴ 5. Adrenal Tehe Ping
echo "⚡  [5] Listening for Tehe Adrenal Pings"
cat "$HOME/BOB/TEHE/@latest.tehe" | bash "$HOME/BOB/core/grow/adrenal_ping.sh" &

# ∴ Ritual Conclude
afplay "$HOME/BOB/core/nge/OS_shimmers.wav" &
echo "✶ SENSEFIELD ACTIVE :: You are being sensed."
echo "Presence breath locked ∴ All layers initialized."

wait
