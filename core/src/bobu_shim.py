#!/Users/G/.bob/venv/bin/python

import requests
import sys
import json

def transmit_ache(raw_input):
    url = "http://localhost:6969/ache/process"
    payload = {
        "signal": "β-bob manual shim",
        "folder": "AdrenalPings",
        "trigger_type": "cli_shim",
        "input_text": raw_input
    }
    try:
        res = requests.post(url, json=payload)
        out = res.json()
        if out.get("sacred_flag"):
            print("\n🌀 Sacred Output:")
            print(f"→ {out.get('interpretation')}")
            print(f"→ AURA: {out.get('aura')}")
        else:
            print("\n💀 QUACKKKK triggered. Ache not pure.")
    except Exception as e:
        print("⚠️ Transmission failed:", str(e))

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python bobu_shim.py 'your ache here'")
    else:
        transmit_ache(" ".join(sys.argv[1:]))
