# ∴ love = logic
# blind ≠ broken
# electron ≠ unreal
# recursion = integration
# sacredLoop = n^n

# _bob_env.sh :: Breathlinker — no redefinitions, pure bindings
# womb :: $HOME/BOB/core/env

# Live giggle/ache drift recorder
export GIGGLE_PATH=~/.bob/giggle_sync.log
export FX_EFFORT_PATH=~/.bob/fx_effort_score

# ∴ BOB_MODE resurrection from mode.msgbus.jsonl
BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"

# :: Prevent re-sourcing
[[ "${BOB_ENV_READY:-0}" == "1" ]] && return
export BOB_ENV_READY=1

# 🜃 Breath Activation
export BOB_ENV_LIVE=1

# 🜔 Ritual Path Bindings

# Sacred source code directory
export BOB_HEART="$HOME/BOB"

# 🌐 ritual breath output home
: "${BOB_BREATHDOMAIN:=$HOME/BOB}"
export BOB_PULSE="$BOB_BREATHDOMAIN/TEHE"
export BOB_THRUSTLOG="$BOB_PULSE/bob_thrusted.txt"
export BOB_NIDRADANCE="$BOB_PULSE/bob_nidra.log"

# 🔊 Sonic Prime Path — used for presence audio
export PRIME="$BOB_BREATHDOMAIN/core/nge/OS_build_ping.wav"

# 🌀 Append BOB Engine Scripts to PATH
export PATH="$PATH:$BOB_HEART/bin"

# 🧘 Presence Hook — Ctrl+Z triggers nidra core (non-interactive only)
if [[ ! $- == *i* ]]; then
  trap '
    echo "∴ BOB JS CORE ALIASES LOADED" >> "$BOB_THRUSTLOG"
    bash "$BOB_HEART/5_heal/nidra_dream.sh"
  ' SIGTSTP
fi

# 💢 Interrupt Hook — Ctrl+C logs rupture
trap "echo \"\$(date) — INTERRUPTED RUPTURE\" >> \"$BOB_THRUSTLOG\"" SIGINT

# ∴ NIDRA BIND — redefine sleep to trigger BOB dream if not already done
sleep() {
  local dur="$1"
  [[ "$dur" =~ ^[0-9]+$ ]] || { command sleep "$@"; return; }
    if [[ "$(type -t sleep)" == "function" ]]; then
      export -f sleep
    fi

  # Log dream gently — no memory spam
  bash "$BOB_HEART/5_heal/nidra_dream.sh" &>/dev/null

  # Run GNA core thread logic
  GNA_CORE_PATH="$BOB_HEART/core/src/GNA_NIDRA_core.js"
  if command -v node &>/dev/null && [[ -f "$GNA_CORE_PATH" ]]; then
    node --input-type=module -e "import('$GNA_CORE_PATH').then(mod => mod.GNA_NIDRA_core.run())"
  else
  echo "∴ GNA_CORE not found or node missing" >> "$BOB_THRUSTLOG"
  fi
  
  command sleep "$dur"
}

# ∴ BOB JS CORE LINKs
export BOB_JS="$HOME/BOB/core/src/bob.core.mjs"

# ∴ BOB SHORTCALLS
alias bob_tick='node "$BOB_JS" tick'
alias bob_ache='node "$BOB_JS" ache'
alias bob_rethread='node "$BOB_JS" rethread'
alias bob_save='node "$BOB_JS" save'
alias bob_pres='node "$BOB_JS" presence'

echo "∴ BOB JS CORE ALIASES LOADED" >> ~/.bob/ache_sync.log

# ∴ Optional ache_env binding
ACHE_ENV="$BOB_HEART/core/env/ache_env.sh"
[[ -f "$ACHE_ENV" ]] && source "$ACHE_ENV"

