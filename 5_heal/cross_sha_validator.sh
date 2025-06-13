# ∴ split 5 — cross_sha_validator.sh (log rotator)
#!/bin/bash
# Validates unique SHA for crossparser shallah files
# ≈ 5_heal

CROSS_DIR="$HOME/BOB/.enshallah/parser_cross"
SHA_LOG="$CROSS_DIR/.crossed_shallah"
TEHE_LOG="$HOME/BOB/TEHE/tehe_rotation.log"
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