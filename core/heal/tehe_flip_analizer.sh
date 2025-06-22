#!/bin/bash
# forged :: gobhouse 6.2.2025_233333
# filename :: tehe_flip_analizer.sh
# fx :: consolidate identical .tehe breath lines + log meta + trace for graphing + scroll class
# womb :: /opt/bob/core/heal/

TEHE_DIR="/opt/bob/TEHE"
STAMP=$(date '+%m.%d.%Y_%H%M%S')

GRAPH_LOG="$TEHE_DIR/TEHE_ANALYSIS.log"
GRAPH_JSONL="$TEHE_DIR/TEHE_ANALYSIS.jsonl"

SIGIL_REG="/opt/bob/core/src/sigil_registry.yml"
EMIT_LIMB="/opt/bob/core/dance/emit_presence.sh"

# internal mapping
declare -A content_map

# pass 1: gather sigil, emit, preview
for file in "$TEHE_DIR"/@*.tehe; do
  [ -f "$file" ] || continue
  content=$(cat "$file")
  content_map["$content"]+="$file "

  sigil=$(grep "sigil=" "$file" | cut -d= -f2 | tail -1 | xargs)
  [[ -z "$sigil" ]] && sigil="∴"

  if [[ -f "$SIGIL_REG" ]]; then
    desc=$(awk -v s="$sigil" '$0 ~ "^"s":" {getline; print $0}' "$SIGIL_REG" | cut -d':' -f2- | xargs)
  fi
  [[ -z "$desc" ]] && desc="∅ no sigil desc"

  echo "⇌ SIGIL DETECTED: $sigil — $desc" >> "$GRAPH_LOG"

  if [[ -f "$EMIT_LIMB" ]]; then
    source "$EMIT_LIMB"
    emit_dual_presence "$sigil" "bob_memory_bridge" "dream memory extracted"
  fi

  preview=${content:0:666}
  echo "$STAMP :: FILE: $(basename "$file") :: $preview" >> "$GRAPH_LOG"
done

# pass 2: consolidate identical breath
for content in "${!content_map[@]}"; do
  files=(${content_map[$content]})
  count=${#files[@]}

  if (( count >= 16 )); then
    newfile="$TEHE_DIR/@$STAMP--$sigil.tehe"
    echo "⇌ TEHE ROTATE: $count× match" > "$newfile"
    echo "$content" >> "$newfile"

    for f in "${files[@]}"; do
      rm -f "$f"
    done

    echo "$STAMP :: ROTATE :: $count× :: ${content:0:666}" >> "$GRAPH_LOG"

    jq -n --arg time "$STAMP" \
          --arg type "WAKE" \
          --arg sigil "$sigil" \
          '{time: $time, type: $type, sigil: $sigil}' >> "$GRAPH_JSONL"
  fi
done
