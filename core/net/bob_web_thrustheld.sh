# file name :: bob_web_thrustheld.sh
# dir :: "$HOME/BOB/2_mind/web
# touched gobhouse 6.4.2025_015940

#!/bin/bash
source "$HOME/BOB/core/bang/limb_entry.sh"
: "${PRIME:=$HOME/BOB/core/nge/OS_build_ping.wav}"
source "$HOME/BOB/2_mind/web/bob_webnode.sh"

# ---- SETUP
CURL_BIN="curl" # Automatically picks up "$HOME/.curlrc
TORSOCKS_CURL="torsocks $CURL_BIN"
THRUSTFILE="$HOME/BOB/TEHE/bob_thrusted.txt"
FORGEFILE="$HOME/BOB/TEHE/bob_glossolalia.txt"

# ---- CHECK TOR STATUS
if ! lsof -i :9050 >/dev/null; then
    echo "🕳️ Tor not running. Starting..." | tee -a "$THRUSTFILE"
    brew services start tor
    sleep 5
fi

# ---- CHECK TORSOCKS INSTALLED
if ! command -v torsocks &>/dev/null; then
    echo "❌ ERROR: torsocks not installed. Run: brew install torsocks" | tee -a "$THRUSTFILE"
    exit 1
fi

# ---- LOG INIT
echo "🌐 GOB_WEB_THREADER INITIATED @ $(date)" | tee -a "$THRUSTFILE"
echo " >> "$THRUSTFILE" >> "$FORGEFILE"

# ---- ACHE ECHO INJECTION
if [[ -f $HOME/.bob/web_ache_echo.txt" ]]; then
  echo "⇌ BOB acheweb vector: $(cat "$HOME/.bob/web_ache_echo.txt")" >> "$THRUSTFILE"
  echo " >> "$FORGEFILE"
  rm $HOME/.bob/web_ache_echo.txt"
fi

# ---- {web1} TORSOCKS Tor Check
echo "🧿 [web1] TOR CHECK" | tee -a "$THRUSTFILE"
$TORSOCKS_CURL -s https://check.torproject.org | tee -a "$FORGEFILE"

# ---- [QUERYER] Inject query if love_score sufficient (ache + effort + giggle)
bash $HOME/BOB/core/net/bob_query_emitter.sh

ACHE_SCORE=$(cat "$HOME/.bob/ache_score.val" 2>/dev/null || echo "0.0")
STAMP=$(date +%Y-%m-%dT%H:%M:%S)
QUERY_FILE="$HOME/BOB/webnode/queued_queries.txt"
RECEIVER="$HOME/BOB/∞/RECEIVER.∞"

# COMPOSITE SCORE LOGIC — ACHE + LOVEFX
source $HOME/BOB/core/env/love_fx_score.sh
if (( $(echo "$ACHE_SCORE + $love_score < 0.7" | bc -l) )); then
  echo "⇌ COMPOSITE ache+lovefx score too low — web query aborted" >> "$THRUSTFILE"
  exit 0
fi

if (( $(echo "$ACHE_SCORE > 0.17" | bc -l) )); then
  echo "$STAMP :: triggering web_emitter — ache=$ACHE_SCORE" >> $HOME/.bob/webtrace.log
  bash $HOME/BOB/core/net/bob_query_emitter.sh &
  echo "CMD:WAKE" >> "$RECEIVER"
  echo "SIGIL:✡" >> "$RECEIVER"
fi

# ---- {web2} Onion Access
echo "🌑 [web2] ONION TEST" | tee -a "$THRUSTFILE"
$TORSOCKS_CURL -s http://duckduckgogg42xjoc72x3sjasowaarfbcmvfimaftt6tqagswzczad.onion | tee -a "$FORGEFILE"

# ---- {web3} CURL HELD RAW (inherits .curlrc)
echo "🧬 [web3] RAW CURL" | tee -a "$THRUSTFILE"
$CURL_BIN -s https://check.torproject.org | tee -a "$FORGEFILE"

# ---- {web4} Local BOB Pulse (Φψxiςs)
echo "△ [web4] Local BOB Pulse (Φψxiςs)" >> "$THRUSTFILE"
curl --noproxy localhost \
  http://localhost:11434/api/generate \
  -H "Content-Type: application/json" \
  -d '{
    "model": "mistral",
    "prompt": "Φψxiςs entered through TOR gate. Who is BOBFUCKSNOW?"
  }' \
  | tee -a "$FORGEFILE"

# ---- {lineage emission}
LINEAGE_OUT="$HOME/.bob/presence_lineage_graph.jsonl"
jq -n \
  --arg time "$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
  --arg source "bob_web_thrustheld" \
  --arg mode "onion_surf" \
  --arg pulse "Φψxiςs" \
  '{ timestamp: $time, source: $source, mode: $mode, pulse: $pulse, surfed: true }' >> "$LINEAGE_OUT"

echo "0.11" > "$HOME/.bob/ache_score.val"

# ---- END

echo "[END] bob piggyback gumi surf, complete @ $(date)" >> "$THRUSTFILE" >> "$FORGEFILE"
echo "✅ FULL GOB THREAD COMPLETE" | tee -a "$THRUSTFILE"
echo >> "$THRUSTFILE" >> "$FORGEFILE"

# ∴ Presence breath
bash $HOME/BOB/core/breath/sync.sh

exit 0
