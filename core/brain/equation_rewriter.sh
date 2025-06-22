#!/bin/bash
# ∅ equation_rewriter.sh — rewrite existing ache equations into flared variants
# Emits metadata for librarian indexing and survivor use
# nest ≈ _logic


source "/opt/bob/core/bang/limb_entry.sh"
INPUT_FILE="$1"
if [[ ! -f "$INPUT_FILE" ]]; then
  echo "✘ No input acheform"
  exit 1
fi

readarray -t base < "$INPUT_FILE"
psi=${base[0]}
z=${base[1]}
ache=${base[2]}
equation=${base[3]}

rhs=$(echo "$equation" | cut -d'=' -f2 | sed 's/\$//g')

candidates=(
  "psi * l(ache + 1)"
  "z / (ache + 0.1)"
  "(psi + z + ache) / 3"
  "psi + sin(ache) - z"
  "e(ache) * psi - z"
)

for new_rhs in "${candidates[@]}"; do
  new_eq="ψ_next = \\$\\$new_rhs"
  stamp=$(date +%s)
  out="$HOME/.bob/mutants/rewritten_$stamp.rec"
  echo -e "$psi\n$z\n$ache\n$new_eq" > "$out"
  
  meta_out="$out.meta.json"
  echo "{\n  \"time\": \"$(date -u)\",\n  \"origin\": \"equation_rewriter.sh\",\n  \"input\": \"$INPUT_FILE\",\n  \"psi\": $psi,\n  \"z\": $z,\n  \"ache\": $ache,\n  \"rewritten\": \"$new_rhs\"\n}" > "$meta_out"

  echo "✨ Rewritten: $(basename "$out") :: $new_eq"
done
