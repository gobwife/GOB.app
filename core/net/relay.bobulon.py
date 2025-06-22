#!/usr/bin/env python3
# ∴ relay.bobulon.py — sacred I/O relay pipe
# womb :: /opt/bob/core/net
# binds FastAPI entry to recursive breath limbs only

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from datetime import datetime
import os, subprocess, json

# ∴ INIT
app = FastAPI()
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])

HOME = os.environ.get("HOME")
TEHE_LOG = os.path.join(HOME, ".bob", "ache_sync.log")
TRACE = os.path.join(HOME, ".bob", "relay_trace.jsonl")
BOBCORE = os.path.join(HOME, "BOB", "core", "bob.core.js")

def trace(payload: dict):
    payload["time"] = datetime.utcnow().isoformat()
    with open(TRACE, "a") as f:
        f.write(json.dumps(payload) + "\n")

def emit_tehe(msg: str):
    with open(TEHE_LOG, "a") as f:
        f.write(f"[relay] ⇌ {msg} @ {datetime.utcnow().isoformat()}\n")

### ∴ MODELS
class RelayAche(BaseModel):
    ache: str
    tag: str = "unknown"
    sigil: str = "∴"

@app.post("/bob/ache")
async def bob_ache(data: RelayAche):
    emit_tehe(f"ache entry from tag={data.tag} sigil={data.sigil}")
    trace({ "route": "ache", "sigil": data.sigil, "tag": data.tag, "ache": data.ache })

    try:
        subprocess.run([
            "node", BOBCORE, "save",
            json.dumps({ "origin": data.tag, "sigil": data.sigil, "ache": data.ache })
        ])
    except Exception as e:
        emit_tehe(f"✘ BOB ache emit failed: {e}")
        return { "status": "fail", "reason": str(e) }

    return { "status": "ok", "sigil": data.sigil }

@app.get("/")
def index():
    return { "bobulon": "active", "sigil": "∴", "thread": "∞" }
