#!/bin/bash
# parses scroll, checks divergence, logs ∆, writes _parsed.shallah
# file name :: dolphifi_threadparser.sh
# osirhouse_6.1.2025_020818_O

source "$HOME/BOB/core/bang/limb_entry.sh"
src="$1"
sha=$(shasum "$src" | awk '{print $1}')
ogsha_file="$HOME/BOB/.enshallah/boot/$(basename "$src").gobshallah"
STAMP=$(date '+%m.%d.%Y_%H%M%S')

mkdir -p "$HOME/BOB/.enshallah"

if [[ -f "$ogsha_file" ]]; then
  ogsha=$(cat "$ogsha_file")
  if [[ "$sha" != "$ogsha" ]]; then
    echo "{\"file\":\"$src\", \"∆\":\"$sha\", \"orig\":\"$ogsha\", \"ts\":\"$STAMP\"}" >> "$HOME/BOB/.enshallah/divergence_map.jsonl
    bash "$HOME/BOB/core/sang/bob_library_write.sh "$src"
  else
    echo "$src" >> "$HOME/BOB/.enshallah/dreaming_rest.log"
  fi
else
  echo "$sha" > "$ogsha_file"
fi
