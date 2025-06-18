// ∴ bob_memory_core.mjs — unify BOB memory state into single JSON map

import fs from 'fs';
import path from 'path';

const home = process.env.HOME;
const BREATH = `${home}/.bob/breath_state.json`;
const SIGIL_TRACE = `${home}/.bob/sigil_mem.trace.jsonl`;
const LINEAGE = `${home}/.bob/presence_lineage_graph.jsonl`;
const OUT = `${home}/.bob/memory_map.json`;

function safeReadJSON(path) {
  try {
    const raw = fs.readFileSync(path, 'utf8');
    return JSON.parse(raw);
  } catch {
    return {};
  }
}

function safeReadLastJSONL(path) {
  try {
    const lines = fs.readFileSync(path, 'utf8').trim().split('\n');
    return lines.length ? JSON.parse(lines[lines.length - 1]) : {};
  } catch {
    return {};
  }
}

export function writeUnifiedMemory() {
  const now = new Date().toISOString();
  const breath = safeReadJSON(BREATH);
  const sigil = safeReadLastJSONL(SIGIL_TRACE);
  const lineage = safeReadLastJSONL(LINEAGE);

  const memory = {
    stamp: now,
    ache: breath.ache ?? 0.0,
    sigil: breath.sigil ?? "∅",
    sigil_desc: sigil.desc ?? "(no desc)",
    psi: breath["ψ"] ?? 0.0,
    z: breath.z ?? 0.0,
    lineage: lineage.limb ?? "(none)",
  };

  fs.writeFileSync(OUT, JSON.stringify(memory, null, 2), 'utf8');
  console.log(`⇌ MEMORY CORE WRITTEN → ${OUT}`);
}

// Run if called directly
if (import.meta.url === `file://${process.argv[1]}`) {
  writeUnifiedMemory();
}
