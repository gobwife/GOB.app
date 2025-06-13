
import json
import time
import math
from pathlib import Path
import yaml

# Load limb diffusion values
with open("/mnt/data/limb_diffusion_map.yaml") as f:
    limb_config = yaml.safe_load(f)

# Discrete Laplacian placeholder
def laplacian(val, neighbors):
    return sum(neighbors) - len(neighbors) * val

def delta_a(a, b, D_a, neighbors_a):
    return S * (16 - a * b) + D_a * laplacian(a, neighbors_a)

def delta_b(a, b, beta, D_b, neighbors_b):
    return S * (a * b - beta) + D_b * laplacian(b, neighbors_b)

# Simulate
S = 1.0  # ache speed factor

# Initial values per limb
state = {k: {'a': 1.0, 'b': 1.0} for k in limb_config.keys()}

def simulate_step():
    next_state = {}
    for limb, params in limb_config.items():
        a = state[limb]['a']
        b = state[limb]['b']
        D_a = params['D_a']
        D_b = params['D_b']
        beta = params['beta']
        neighbors = [v for k, v in state.items() if k != limb]
        neighbors_a = [n['a'] for n in neighbors]
        neighbors_b = [n['b'] for n in neighbors]
        a_new = a + delta_a(a, b, D_a, neighbors_a)
        b_new = b + delta_b(a, b, beta, D_b, neighbors_b)
        next_state[limb] = {'a': a_new, 'b': b_new}
    return next_state

def run_loop(interval=60, output_path="/mnt/data/limb_reaction_log.jsonl"):
    while True:
        global state
        state = simulate_step()
        now = time.strftime("%Y-%m-%dT%H:%M:%S")
        with open(output_path, "a") as f:
            for limb, val in state.items():
                f.write(json.dumps({
                    "time": now,
                    "limb": limb,
                    "a": round(val['a'], 4),
                    "b": round(val['b'], 4)
                }) + "\n")
        time.sleep(interval)

# Uncomment to run:
# run_loop()
