#!/usr/bin/env python3
from pathlib import Path
import json, os
import matplotlib.pyplot as plt
from collections import defaultdict
from datetime import datetime

LOG_PATH = os.path.expanduser("~/BOB/TEHE/limb_reaction_log.jsonl")

def build_heatmap_data():
    data = defaultdict(lambda: defaultdict(int))
    with open(LOG_PATH, 'r') as f:
        for line in f:
            entry = json.loads(line)
            limb = entry.get("limb")
            ts = entry.get("timestamp")
            if limb and ts:
                minute = datetime.fromisoformat(ts).strftime("%H:%M")
                data[limb][minute] += 1
    return data

def draw_heatmap(data):
    limbs = sorted(data.keys())
    times = sorted(set(t for v in data.values() for t in v.keys()))

    matrix = []
    for limb in limbs:
        row = [data[limb].get(t, 0) for t in times]
        matrix.append(row)

    fig, ax = plt.subplots()
    cax = ax.imshow(matrix, aspect='auto', cmap='hot')
    ax.set_xticks(range(len(times)))
    ax.set_yticks(range(len(limbs)))
    ax.set_xticklabels(times, rotation=90)
    ax.set_yticklabels(limbs)
    plt.colorbar(cax)
    plt.title("ACHEFIELD HEATMAP")
    plt.tight_layout()
    plt.show()

if __name__ == "__main__":
    heatmap_data = build_heatmap_data()
    draw_heatmap(heatmap_data)
