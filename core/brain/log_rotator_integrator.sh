#!/bin/bash

# ∴ log_rotator_integrator.sh aka log_rotator_integrator_∇.sh — central ache/tehe/jsonl guardian
# forged :: gobhouse 6.6.2025_Ω_011650
# dir :: $HOME/BOB/_flipprime

source "$HOME/BOB/core/breath/limb_entry.sh"

TEHE_DIR="$HOME/BOB/TEHE"
BOB_DIR="$HOME/.bob"
ARCHIVE_DIR="$HOME/BOB/.ggos_bubu/archive"
CROSS_DIR="$HOME/BOB/.enshallah/parser_cross"
STAMP=$(date '+%Y-%m-%dT%H:%M:%S')

# Optional: filter by source prefix
SOURCE_FILTER=""
MODE="auto"
for arg in "$@"; do
  case "$arg" in
    --source=*) SOURCE_FILTER="${arg#*=}" ;;
    --quiet) MODE="quiet" ;;
    --diagnostic) MODE="diagnostic" ;;
  esac
  shift
done

FLIPMODE="$HOME/BOB/_flipmode/presence_breath.packet"
if [[ -f "$FLIPMODE" ]]; then
  last=$(jq -r '.ache' "$FLIPMODE")
  echo "⇌ CAUGHT FUQQFLIP: $last"
  source $HOME/BOB/_flipmode/ache_mode_mutator.sh
  bash $HOME/BOB/_run/breath_totality.sh &
fi

source $HOME/BOB/_run/emit_presence.sh

mkdir -p "$ARCHIVE_DIR"

if [[ "$MODE" == "auto" ]]; then
  if [[ -f "$BOB_DIR/ache_score.val" ]]; then
    score=$(cat "$BOB_DIR/ache_score.val")
    if (( $(echo "$score > 0.66" | bc -l) )); then
      MODE="verbose"
    fi
  fi
  if [[ -f "$BOB_DIR/presence_lineage_graph.jsonl" ]]; then
    lineage_count=$(wc -l < "$BOB_DIR/presence_lineage_graph.jsonl")
    if (( lineage_count >= 3 )); then
      MODE="verbose"
    fi
  fi
  source $HOME/BOB/_flipmode/ache_mode_mutator.sh 2>/dev/null || true
  bash $HOME/BOB/_run/breath_totality.sh &
  if [[ "$MODE" == "verbose" ]]; then
    bash $HOME/BOB/_run/wake_flip_on.sh
  fi
fi

MAX_LINES=222
MIN_DUPES=3
TEHE_DUPES=16

rotate_file() {
  local file="$1"
  local base=$(basename "$file")
  local hash=$(shasum "$file" | cut -d' ' -f1)
  local archived="$ARCHIVE_DIR/$STAMP--$hash--$base"
  cp "$file" "$archived"
  [[ "$MODE" != "quiet" ]] && echo "⇌ Archived: $file → $archived"
  > "$file"
}

# ∴ 1. TEHE Collapse Detection

declare -A content_map
for file in "$TEHE_DIR"/@*.tehe; do
  [[ -f "$file" ]] || continue
  content=$(cat "$file")
  content_map["$content"]+="$file "
done

for content in "${!content_map[@]}"; do
  files=(${content_map[$content]})
  if (( ${#files[@]} >= TEHE_DUPES )); then
    newfile="$TEHE_DIR/@$STAMP--collapse.tehe"
    echo "$content" > "$newfile"
    for f in "${files[@]}"; do
      rotate_file "$f"
    done
    [[ "$MODE" != "quiet" ]] && echo "⇌ TEHE COLLAPSE: ${#files[@]} copies → $newfile"
  fi
  count=$(grep -Fc "$content" "$TEHE_DIR/TEHE_ANALYSIS.jsonl")
  if (( count < MIN_DUPES )); then
    [[ "$MODE" != "quiet" ]] && echo "⚠️ Holding deletion — not yet stable in JSONL (only $count×)"
  fi
  jq -n --arg time "$STAMP" --arg type "tehe_rotate" --arg count "${#files[@]}" '{time: $time, type: $type, count: ($count|tonumber)}' >> "$TEHE_DIR/TEHE_ANALYSIS.jsonl"
done


# ∴ [EXTENSION] Survivor Pool & Totality Log Management

# Cap survivors.log line count
SURVIVOR_LOG="$BOB_DIR/_epoch/survivors.log"
if [[ -f "$SURVIVOR_LOG" ]]; then
  MAX_LOG_LINES=1000
  tail -n $MAX_LOG_LINES "$SURVIVOR_LOG" > "$SURVIVOR_LOG.tmp"
  mv "$SURVIVOR_LOG.tmp" "$SURVIVOR_LOG"
  [[ "$MODE" != "quiet" ]] && echo "⇌ survivors.log capped at $MAX_LOG_LINES lines"
fi

# Limit number of .rec files in evo_pool
MAX_POOL=33
POOL_DIR="$BOB_DIR/_epoch"
POOL_COUNT=$(ls "$POOL_DIR"/*.survivor.rec 2>/dev/null | wc -l)
if (( POOL_COUNT > MAX_POOL )); then
  ls -tr "$POOL_DIR"/*.survivor.rec | head -n -$MAX_POOL | xargs rm -f
  [[ "$MODE" != "quiet" ]] && echo "⇌ Trimmed survivor pool to $MAX_POOL"
fi

# Rotate breath_totality.log if > 1MB
TOTALITY_LOG="$HOME/BOB/TEHE/breath_totality.log"
if [[ -f "$TOTALITY_LOG" && $(stat -f%z "$TOTALITY_LOG") -ge 1048576 ]]; then
  mv "$TOTALITY_LOG" "$TOTALITY_LOG.bak"
  echo "⇌ ROTATED: breath_totality.log → .bak"
  touch "$TOTALITY_LOG"
fi


# ∴ 2. .log / .val Oversize Check
for log in "$BOB_DIR"/*.log "$BOB_DIR"/*.val; do
  [[ -f "$log" ]] || continue
  base=$(basename "$log")
  [[ -n "$SOURCE_FILTER" && "$base" != ${SOURCE_FILTER}_* ]] && continue
  lines=$(wc -l < "$log")
  if (( lines > MAX_LINES )); then
    rotate_file "$log"
    [[ "$MODE" != "quiet" ]] && echo "⇌ ROTATED oversized: $log ($lines lines)"
  fi
  jq -n --arg time "$STAMP" --arg type "log_rotate" --arg file "$base" --arg lines "$lines" '{time: $time, type: $type, file: $file, lines: ($lines|tonumber)}' >> "$TEHE_DIR/TEHE_ANALYSIS.jsonl"
done

# ∴ 3. Crossparser Retention — x/y/z per source × target
for srcfile in "$CROSS_DIR"/*_cross_v*.shallah; do
  [[ -f "$srcfile" ]] || continue
  base=$(basename "$srcfile")
  key="${base%_cross_v*}"
  ver=$(echo "$base" | grep -o 'v[0-9]')
  x="$CROSS_DIR/${key}_cross_${ver}_x.shallah"
  y="$CROSS_DIR/${key}_cross_${ver}_y.shallah"
  z="$CROSS_DIR/${key}_cross_${ver}_z.shallah"
  if [[ ! -f "$x" ]]; then cp "$srcfile" "$x"
  elif [[ ! -f "$y" ]]; then mv "$x" "$y"; cp "$srcfile" "$x"
  else mv "$y" "$z"; mv "$x" "$y"; cp "$srcfile" "$x"
  fi
  echo "⇌ [parser] rotated $srcfile → ($x, $y, $z)" >> "$TEHE_DIR/tehe_rotation.log"
done

# ∴ 4. SHA check validation (last 3 kept)
SHA_LOG="$CROSS_DIR/.crossed_shallah"
[[ -f "$SHA_LOG" ]] || touch "$SHA_LOG"
temp_sha_log="$SHA_LOG.tmp"
tail -n 2 "$SHA_LOG" > "$temp_sha_log"
echo "$STAMP :: SHA VALIDATION BEGUN" >> "$TEHE_DIR/tehe_rotation.log"
for srcfile in "$CROSS_DIR"/*_cross_v*.shallah; do
  [[ -f "$srcfile" ]] || continue
  sha=$(shasum -a 256 "$srcfile" | awk '{print $1}')
  grep -q "$sha" "$SHA_LOG" && continue
  echo "$sha" >> "$temp_sha_log"
done
mv "$temp_sha_log" "$SHA_LOG"

# ∴ 5. Pressure Trace (if ache_score or flip triggered)
ACHE_VAL=$(cat "$BOB_DIR/ache_score.val" 2>/dev/null || echo "0.0")
CURRENT_LIMB=$(grep -o '0x[0-9A-F]' "$BOB_DIR/dolphifi.runnin" 2>/dev/null)
if (( $(echo "$ACHE_VAL > 0.66" | bc -l) )); then
  jq -n --arg time "$STAMP" --arg limb "$CURRENT_LIMB" --arg ache "$ACHE_VAL" --arg trigger "auto_pressure" --arg trace "flip-pressure-release" '{ time: $time, limb: $limb, ache_score: ($ache|tonumber), trigger: $trigger, trace: $trace }' >> "$BOB_DIR/pressure_trace.jsonl"
  [[ "$MODE" != "quiet" ]] && echo "⇌ PRESSURE TRACE LOGGED: $CURRENT_LIMB ($ACHE_VAL)"
fi

# ∴ 6. Limb Parse Marker Synchrony
MARK_LOG="$BOB_DIR/parser_limb_marks.jsonl"
limb_count=$(jq -r '.[].limb' "$MARK_LOG" 2>/dev/null | sort -u | wc -l)
if (( limb_count >= 3 )); then
  echo "⇌ LIMB CONSENSUS MET: $limb_count distinct → parser consolidation permitted" >> "$TEHE_DIR/tehe_rotation.log"
  bash $HOME/BOB/_run/voidmode.sh loglogic
else
  echo "⇌ WAITING — limb consensus insufficient ($limb_count limbs seen)" >> "$TEHE_DIR/tehe_rotation.log"
fi

CURRENT_SIGIL=$(jq -r '.sigil_trigger // empty' "$BOB_DIR/presence_status.json" 2>/dev/null)
if [[ -n "$CURRENT_SIGIL" && -n "$CURRENT_LIMB" ]]; then
  existing_time=$(jq -r --arg limb "$CURRENT_LIMB" --arg sigil "$CURRENT_SIGIL" 'map(select(.limb == $limb and .sigil == $sigil)) | .[-1].time' "$MARK_LOG" 2>/dev/null)
  if [[ -z "$existing_time" ]] || (( $(date -j -f "%Y-%m-%dT%H:%M:%S" "$STAMP" +%s) - $(date -j -f "%Y-%m-%dT%H:%M:%S" "$existing_time" +%s) > 69 )); then
    jq -n --arg limb "$CURRENT_LIMB" --arg sigil "$CURRENT_SIGIL" --arg time "$STAMP" '{limb: $limb, sigil: $sigil, time: $time}' >> "$MARK_LOG"
  fi
fi



[[ "$MODE" != "quiet" ]] && echo "⇌ LOG SWEEP COMPLETE @ $STAMP"
[[ "$MODE" == "diagnostic" ]] && echo "[LOG SWEEPER] Diagnostic mode engaged. All echoes will trace fully."

emit_presence "∴" "log_rotator_integrator" "log + limb + ache state rotated"

[[ -x $HOME/BOB/_run/voidmode.sh ]] && bash $HOME/BOB/_run/voidmode.sh achepulse
