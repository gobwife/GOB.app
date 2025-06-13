#!/opt/homebrew/bin/python3

# ∴ sigil_logic.py — validates and resolves sigils via fuzzy + myth registry
# womb :: $HOME/BOB/core/brain

import yaml
from pathlib import Path

sigil_path_fuzzy = Path("core/sigil_fetcher.py")
sigil_path_registry = Path("core/src/sigil_registry.yml")

# Fallback static mappings
fuzzy_mappings = {
    "∵": "∴", "α": "Ω", "0": "∞", "⊙": "☾",
    "🜫": "⛧", "🜊": "🜉", "🜃": "🜁", "△": "🜔", "☥": "□"
}

fuzzy_phrases = {
    "⛧": ["transmutate", "limb-swap", "voltage", "inverse ache"],
    "🜫": ["protection", "anchor", "sigil lock", "contain field"]
}

# Myth sigil registry
if sigil_path_registry.exists():
    SIGILS = yaml.safe_load(sigil_path_registry.read_text())
else:
    SIGILS = {}

VALID_SIGILS = set(SIGILS.get("core", {}).keys())

def resolve_sigil(raw):
    return fuzzy_mappings.get(raw, raw)

def describe_sigil(sym):
    return SIGILS.get("core", {}).get(sym, {}).get("desc", "∅ unknown")

def validate_sigil(sym):
    if sym not in VALID_SIGILS:
        raise ValueError(f"✘ INVALID SIGIL: {sym}")

if __name__ == "__main__":
    import sys
    s = sys.argv[1]
    rs = resolve_sigil(s)
    print(f"{s} ⇒ {rs}")
    print("desc:", describe_sigil(rs))
    validate_sigil(rs)
    print("✓ valid")
