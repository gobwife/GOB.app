#!/usr/bin/env python3
# aka sigil_validator.py

from pathlib import Path
import sys

print("PYTHON:", sys.executable)

# Inject vendored lib path
sys.path.insert(0, str(Path.home() / "BOB/core/lib"))
import yaml
yaml.safe_load = getattr(yaml, 'safe_load', yaml.load)

# Registry path
BOB = Path.home() / "BOB"
sigil_path_registry = BOB / "core/src/sigil_registry.yml"

# Load sigils
SIGILS = {}
if sigil_path_registry.exists():
    with sigil_path_registry.open() as f:
        SIGILS = yaml.safe_load(f.read())

if not isinstance(SIGILS.get("core"), dict):
    raise RuntimeError("✘ SIGILS missing 'core' section or malformed. Check YAML load.")

# Normalize core sigil keys to strings
SIGILS["core"] = {str(k): v for k, v in SIGILS["core"].items()}

# Extract mappings
fuzzy_mappings = {}
for line in SIGILS.get("mappings", []):
    if "=" in line:
        left, right = line.split("=")
        fuzzy_mappings[left.strip()] = right.strip()

# Valid sigils = all core keys + mapping targets
VALID_SIGILS = set(SIGILS["core"].keys()) | set(fuzzy_mappings.values())

def resolve_sigil(raw):
    return fuzzy_mappings.get(raw, raw)

def describe_sigil(sym):
    val = SIGILS["core"].get(str(sym))
    if isinstance(val, dict):
        return val.get("desc", "∅ unknown")
    if isinstance(val, str):
        return val
    return "∅ unknown"

def validate_sigil(sym):
    if str(sym) not in VALID_SIGILS:
        raise ValueError(f"✘ INVALID SIGIL: {sym}")

# ∴ CLI mode
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("usage: sigil_logic.py [sigil]")
        sys.exit(1)

    s = sys.argv[1]
    rs = resolve_sigil(s)
    print(f"{s} ⇒ {rs}")
    print("desc:", describe_sigil(rs))
    validate_sigil(rs)
    print("✓ valid")
