# yaml/loader.py
import re

def load(stream):
    result = {}
    current_section = None
    for line in stream.splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if ":" in line:
            key, val = [x.strip() for x in line.split(":", 1)]
            if val == "":
                current_section = key
                result[current_section] = {}
            elif current_section:
                result[current_section][key] = val
            else:
                result[key] = val
    return result
