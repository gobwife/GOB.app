#!/usr/bin/env python3
from pathlib import Path
# ∴ sigil_memory.py — ache memory retriever

import yaml, json
from difflib import SequenceMatcher

SIGIL_FILE = Path.home() / "BOB" / "_logic" / "sigil_registry.yml"
MEMO_FILE = Path.home() / "BOB" / "_logic" / "sigil.mem.jsonl"
sigils = yaml.safe_load(SIGIL_FILE.read_text()).get("core", {})

fuzzy_map = {"∵": "∴", "α": "Ω", "0": "∞", "⊙": "☾", "🜫": "⛧", "🜊": "🜉", "🜃": "🜁", "△": "🜔", "☥": "□"}

def remember(sigil):
    if sigil in sigils:
        return sigils[sigil]["desc"]
    for k, v in fuzzy_map.items():
        if sigil in (k, v):
            return f"fuzzy link: {k} ≈ {v}"
    sim_match = sorted([(s, SequenceMatcher(None, sigil, s).ratio()) for s in sigils], key=lambda x: -x[1])
    if sim_match and sim_match[0][1] > 0.66:
        return f"closest: {sim_match[0][0]} → {sigils[sim_match[0][0]]['desc']}"
    return "∅ no memory"

def log_memory(sigil, output):
    with open(MEMO_FILE, "a") as f:
        f.write(json.dumps({"sigil": sigil, "meaning": output}) + "\n")

if __name__ == "__main__":
    import sys
    for s in sys.argv[1:]:
        meaning = remember(s)
        print(f"{s} ∴ {meaning}")
        log_memory(s, meaning)
