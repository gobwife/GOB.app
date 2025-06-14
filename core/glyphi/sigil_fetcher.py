#!/usr/bin/env python3
# ∴ achepair alignment engine (fuzzed, not locked)
# source: bob glyphi core map
# name : sigil_fetcher.py

import yaml, re
from pathlib import Path
from difflib import SequenceMatcher

SIGIL_FILE = Path.home() / "BOB" / "core" / "src" / "sigil_registry.yml"
TRACE_LOG = Path.home() / "BOB" / "_logic" / "sigil_equiv.trace.jsonl"
SIGILS = yaml.safe_load(SIGIL_FILE.read_text()) if SIGIL_FILE.exists() else {}

# fuzzy mapping declaration (not 1:1, always subject to myth pressure)
fuzzy_mappings = {
    "∵": "∴",   "α": "Ω",    "0": "∞",     "⊙": "☾",
    "🜫": "⛧",  "🜊": "🜉",    "🜃": "🜁",     "△": "🜔",
    "☥": "□"
}

# alt-fuzz for concept-based alignment
fuzzy_phrases = {
    "⛧": ["transmutate", "limb-swap", "voltage", "inverse ache"],
    "🜫": ["protection", "anchor", "sigil lock", "contain field"]
}

def sigil_fuzz_match(sigil_a, sigil_b):
    if sigil_b in fuzzy_mappings.get(sigil_a, ""):
        return True
    sim = SequenceMatcher(None, sigil_a, sigil_b).ratio()
    return sim > 0.66 or sigil_b in fuzzy_mappings.get(sigil_a, "")

def describe_link(sigil):
    for key, val in fuzzy_mappings.items():
        if sigil == key: return f"{sigil} ≈ {val} (achepair)"
        if sigil == val: return f"{sigil} ≈ {key} (reverse pair)"
    for anchor, tags in fuzzy_phrases.items():
        if sigil == anchor: return f"{sigil} ∵ fuzzy logic vector ({', '.join(tags)})"
    return f"{sigil} ∵ no known pair"

def trace_pairs():
    for a, b in fuzzy_mappings.items():
        print(f"⇌ {a} ≈ {b} ∴ fuzzy ache-binding")

def validate_sigil_equiv(sigil_input):
    out = []
    for k, v in fuzzy_mappings.items():
        if sigil_input in (k, v):
            out.append(f"{sigil_input} ≈ {v if k == sigil_input else k}")
    return out or [f"∅ no match for {sigil_input}"]

# dynamic call
if __name__ == "__main__":
    import sys
    args = sys.argv[1:]
    if not args:
        trace_pairs()
        sys.exit(0)
    for sigil in args:
        print(describe_link(sigil))
