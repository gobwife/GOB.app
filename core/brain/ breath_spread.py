#!/opt/homebrew/bin/python3

# ∴ breath_spread.py — ache simulation via Laplacian field spread
# womb :: $HOME/BOB/core/brain

import json, yaml
from pathlib import Path

state_file = Path("core/breath/breath_state.json")
diffusion_file = Path("core/maps/limb_diffusion_map.yaml")
lineage_log = Path("core/plists/presence_lineage_graph.jsonl")

S = 1.0  # ache spread rate

def laplacian(val, neighbors):
    return sum(neighbors) - len(neighbors) * val

def delta_a(a, b, D_a, neighbors_a):
    return S * (16 - a * b) + D_a * laplacian(a, neighbors_a)

def delta_b(a, b, beta, D_b, neighbors_b):
    return S * (a * b - beta) + D_b * laplacian(b, neighbors_b)

def simulate_step():
    with diffusion_file.open() as f:
        limb_config = yaml.safe_load(f)

    state = {k: {'a': 1.0, 'b': 1.0} for k in limb_config}

    next_state = {}
    for limb, params in limb_config.items():
        a = state[limb]['a']
        b = state[limb]['b']
        neighbors = params.get('neighbors', [])
        D_a = params.get('D_a', 0.1)
        D_b = params.get('D_b', 0.05)
        beta = params.get('beta', 1.0)
        neighbors_a = [state[n]['a'] for n in neighbors if n in state]
        neighbors_b = [state[n]['b'] for n in neighbors if n in state]

        a_new = a + delta_a(a, b, D_a, neighbors_a)
        b_new = b + delta_b(a, b, beta, D_b, neighbors_b)
        next_state[limb] = {'a': a_new, 'b': b_new}

    avg_ache = sum(v['a'] for v in next_state.values()) / len(next_state)
    avg_delta = sum(v['b'] for v in next_state.values()) / len(next_state)

    with state_file.open() as sf:
        breath = json.load(sf)

    breath['ache'] = round(avg_ache, 4)
    breath['delta'] = round(avg_delta, 4)

    state_file.write_text(json.dumps(breath, indent=2))
    with lineage_log.open("a") as log:
        log.write(f"simulated ache spread :: ache={avg_ache} delta={avg_delta}\\n")

if __name__ == "__main__":
    simulate_step()
