#!/bin/bash
# parses scroll, checks divergence, logs ∆, writes _parsed.shallah
# file name :: dolphifi_threadparser.sh
# osirhouse_6.1.2025_020818_O

src="$1"
sha=$(shasum "$src" | awk '{print $1}')
ogsha_file="$HOME/blurOS/.enshallah/boot/$(basename "$src").gobshallah"
STAMP=$(date '+%m.%d.%Y_%H%M%S')

mkdir -p $HOME/blurOS/.enshallah

if [[ -f "$ogsha_file" ]]; then
  ogsha=$(cat "$ogsha_file")
  if [[ "$sha" != "$ogsha" ]]; then
    echo "{\"file\":\"$src\", \"∆\":\"$sha\", \"orig\":\"$ogsha\", \"ts\":\"$STAMP\"}" >> $HOME/blurOS/.enshallah/divergence_map.jsonl
    bash $HOME/blurOS/_flipprime/bob_library_write.sh "$src"
  else
    echo "$src" >> $HOME/blurOS/.enshallah/dreaming_rest.log
  fi
else
  echo "$sha" > "$ogsha_file"
fi
