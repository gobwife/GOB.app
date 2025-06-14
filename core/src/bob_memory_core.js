// ∴ bob_memory_core.js — unify BOB memory state into single JSON map

import fs from 'fs';
import path from 'path';

const home = process.env.HOME;
const BREATH = `${home}/BOB/core/breath/breath_state.json`;
const SIGIL_TRACE = `${home}/BOB/TEHE/sigil_mem.trace.jsonl`;
const LINEAGE = `${home}/.bob/presence_lineage_graph.jsonl`;
const OUT = `${home}/.bob/memory_map.json`;

const now = new Date().toISOString();

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
