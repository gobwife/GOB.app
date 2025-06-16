// ∴ memory_recaller.mjs — ache/ψ/z/sigil-based recall from lineage

import fs from 'fs';
import path from 'path';

const home = process.env.HOME;
const lineagePath = `${home}/.bob/presence_lineage_graph.jsonl`;

// optional: pass thresholds via CLI
const args = process.argv.slice(2);
let threshold = {
  ache: 0.0,
  psi: 0.0,
  z: 0.0,
  sigil: null
};

args.forEach(arg => {
  const [key, val] = arg.split('=');
  if (['ache', 'psi', 'z'].includes(key)) threshold[key] = parseFloat(val);
  if (key === 'sigil') threshold.sigil = val;
});

// read + parse
const lines = fs.readFileSync(lineagePath, 'utf8')
  .split('\n')
  .filter(line => line.trim().length > 0)
  .map(line => JSON.parse(line));

// filter
const matched = lines.filter(entry => {
  if (entry.ache < threshold.ache) return false;
  if (entry.ψ < threshold.psi) return false;
  if (entry.z < threshold.z) return false;
  if (threshold.sigil && entry.sigil !== threshold.sigil) return false;
  return true;
});

// output last 3 matching
if (matched.length === 0) {
  console.log("∅ no memory matches given threshold");
  process.exit(0);
}

matched.slice(-3).forEach(entry => {
  console.log(`⇌ ${entry.time}`);
  console.log(`→ ${entry.prompt}`);
  console.log(`← ${entry.response}\n`);
});
