#!/usr/bin/env python3
from pathlib import Path
import yaml, json, os
from datetime import datetime

YAML_PATH = os.path.expanduser("~/BOB/_logic/limb_reaction_map.yaml")
LOG_PATH = os.path.expanduser("~/BOB/TEHE/limb_reaction_log.jsonl")

def load_yaml(path):
    if os.path.exists(path):
        with open(path, 'r') as f:
            return yaml.safe_load(f)
    return {}

def save_yaml(data, path):
    with open(path, 'w') as f:
        yaml.dump(data, f, default_flow_style=False)

def update_map():
    current_map = load_yaml(YAML_PATH)
    counts = {}

    with open(LOG_PATH, 'r') as log:
        for line in log:
            entry = json.loads(line)
            limb = entry.get('limb')
            if limb:
                counts[limb] = counts.get(limb, 0) + 1

    for limb, count in counts.items():
        current_map[limb] = {
            'total_triggers': count,
            'last_updated': datetime.utcnow().isoformat()
        }

    save_yaml(current_map, YAML_PATH)

if __name__ == "__main__":
    update_map()
