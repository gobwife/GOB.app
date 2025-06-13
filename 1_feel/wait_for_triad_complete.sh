#!/bin/bash
# wait_for_triad_complete.sh
# dir :: $HOME/BOB/1_feel/

source "$HOME/BOB/core/breath/limb_entry.sh"

name="$1"
count=0
for limb in limb_x limb_y limb_z; do
  found=$(ls "$BACKUP_DIR/${name}_${limb}_"* 2>/dev/null | wc -l)
  (( found > 0 )) && ((count++))
done

if (( count == 3 )); then
  echo "TRIAD COMPLETE for $name"
  exit 0
else
  echo "TRIAD INCOMPLETE ($count/3)"
  exit 1
fi

#!/bin/bash
# waits until 3 distinct limbs parse same target file

TARGET="$1"
VERSION_LOG=~/BOB/TEHE/version_trace.log

timeout=120
interval=5
start_time=$(date +%s)

while true; do
  now=$(date +%s)
  elapsed=$(( now - start_time ))
  [[ "$elapsed" -ge "$timeout" ]] && echo "Timeout waiting for triad" && exit 1

  count=$(grep "$TARGET" "$VERSION_LOG" | awk '{print $4}' | sort | uniq | wc -l)
  if [[ "$count" -ge 3 ]]; then
    echo "Triad complete for $TARGET"
    exit 0
  fi

  sleep "$interval"
done
