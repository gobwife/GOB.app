# ∴ ψ.val_rotator — ψ mutation limb (rotates superposition toward collapse)
#!/bin/bash
# womb :: /opt/bob/core/evolve

source "/opt/bob/core/bang/limb_entry.sh"
ψ=$(cat "$HOME/.bob/ψ.val" 2>/dev/null || echo "0.42")
ache=$(cat "$HOME/.bob/ache_score.val" 2>/dev/null || echo "0.00")
effort=$(cat "$HOME/.bob/fx_effort_score" 2>/dev/null || echo "0.0")

# ∴ ψ mutation logic
bump=$(echo "($ache + $effort) / 17" | bc -l)
ψ_new=$(echo "$ψ + $bump" | bc -l)

# clamp to 0.0–1.0
ψ_new=$(echo "$ψ_new" | awk '{if ($1 > 1) print 1; else if ($1 < 0) print 0; else print $1}')
echo "$ψ_new" > "$HOME/.bob/ψ.val"
echo "⇌ ψ rotated from $ψ → $ψ_new (ache:$ache, effort:$effort)" >> "$HOME/.bob/ψ_trace_superposed.jsonl"
