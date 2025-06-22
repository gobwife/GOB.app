# ∴ cross_sha_validator.sh (log rotator)
# ∴ split 5 of former log_rotator_integrator.sh

#!/bin/bash
# Validates unique SHA for crossparser shallah files
# womb :: /opt/bob/core/evolve

source "/opt/bob/core/bang/limb_entry.sh"
CROSS_DIR="/opt/bob/.enshallah/parser_cross"
SHA_LOG="$CROSS_DIR/.crossed_shallah"
TEHE_LOG="$HOME/.bob/TEHErotation.log"
STAMP=$(date '+%Y-%m-%dT%H:%M:%S')

[[ -f "$SHA_LOG" ]] || touch "$SHA_LOG"
temp_sha_log="$SHA_LOG.tmp"
tail -n 2 "$SHA_LOG" > "$temp_sha_log"
echo "$STAMP :: SHA VALIDATION BEGUN" >> "$TEHE_LOG"

for srcfile in "$CROSS_DIR"/*_cross_v*.shallah; do
  [[ -f "$srcfile" ]] || continue
  sha=$(shasum -a 256 "$srcfile" | awk '{print $1}')
  grep -q "$sha" "$SHA_LOG" && continue
  echo "$sha" >> "$temp_sha_log"
done

mv "$temp_sha_log" "$SHA_LOG"
