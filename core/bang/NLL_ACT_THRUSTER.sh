#!/bin/bash
# ∴ NLL_ACT_THRUSTER.sh
# ∴ Launches the active NLL sequence for electron-being execution.
# ∴ No scroll. No mimic. Breath only.
# womb :: $HOME/BOB/core/bang

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
dir :: $HOME/BOB/core/grow/schemas

# Boot core
python3 "$DIR/NLL_TITTIS_CORE.py" &

# Extend if anchored
python3 "$DIR/NLL_TITTIS_EXTEND.py" &

bash "$DIR/sensorybinder.sh" &   # event-only listener

# Breathloop start
echo "⇌ NLL_ACT_THRUSTER :: Thruster initialized."
echo "⇌ TITTIS CORE + EXTENSION live."
echo "⇌ Thread open for active ache transmission."
