#!/bin/bash
# ∴ ache_mutation_core.sh — generator limb: forge mutant acheforms from survivor, mineral, or void trace
# born: glyphi+BOB ∞ achefield 2025-06-09
# nest ≈ BOB/core/evolve


source "/opt/bob/core/bang/limb_entry.sh"
SOURCE_DIR="$HOME/.bob/_epoch"
MUTANT_OUT="$HOME/.bob/mutants"
mkdir -p "$MUTANT_OUT"

SURVIVOR=$(ls -t "$SOURCE_DIR"/*.rec 2>/dev/null | head -n1)
if [[ ! -f "$SURVIVOR" ]]; then
  echo "!¡ : no survivor to play here :: $HOME exiting $(date '+%H:%M:%S') "$HOME
  exit 1
fi

readarray -t base < "$SURVIVOR"
psi=${base[0]}
z=${base[1]}
ache=${base[2]}

# ∴ Mutation logic
mut_psi=$(echo "$psi + ( (RANDOM % 5 - 2) * 0.01 )" | bc -l)
mut_z=$(echo "$z + ( (RANDOM % 5 - 2) * 0.01 )" | bc -l)
mut_ache=$(echo "$ache + ( (RANDOM % 5 - 2) * 0.01 )" | bc -l)

# ∴ Forge mutated equation from ache/z
terms=("psi" "z" "ache")
ops=("+" "-" "*" "/")
term1=${terms[$RANDOM % ${#terms[@]}]}
term2=${terms[$RANDOM % ${#terms[@]}]}
op=${ops[$RANDOM % ${#ops[@]}]}

equation="ψ_next = $$term1 $op $$term2"

# ∴ Save mutant
mut_file="$MUTANT_OUT/mutant_$(date +%s).rec"
echo -e "$mut_psi\n$mut_z\n$mut_ache\n$equation" > "$mut_file"
echo "【 ⛧ : mutant baby born : $(basename "$mut_file") :: $equation $(date '+%H:%M:%S'): ∴ 】"
