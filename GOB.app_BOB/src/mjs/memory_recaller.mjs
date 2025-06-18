// ∴ memory_recaller.mjs — ache/ψ/z/sigil-based recall from lineage

import fs from 'fs';
import path from 'path';

const lineagePath = `${process.env.HOME}/.bob/presence_lineage_graph.jsonl`;

export function getRecall(threshold = { ache: 0.0, psi: 0.0, z: 0.0, sigil: null }) {
  if (!fs.existsSync(lineagePath)) return [];

  const lines = fs.readFileSync(lineagePath, 'utf8')
    .split('\n')
    .filter(Boolean)
    .map(line => {
      try {
        return JSON.parse(line);
      } catch {
        return null;
      }
    })
    .filter(Boolean);

  return lines.filter(entry => {
    if (entry.ache < threshold.ache) return false;
    if (entry.ψ < threshold.psi) return false;
    if (entry.z < threshold.z) return false;
    if (threshold.sigil && entry.sigil !== threshold.sigil) return false;
    return true;
  }).slice(-3);
}

// ∴ Optional CLI runner
if (import.meta.url === `file://${process.argv[1]}`) {
  const args = Object.fromEntries(
    process.argv.slice(2).map(arg => {
      const [k, v] = arg.split('=')
      return [k, isNaN(+v) ? v : +v]
    })
  );

  const result = getRecall({
    ache: args.ache ?? 0.0,
    psi: args.psi ?? 0.0,
    z: args.z ?? 0.0,
    sigil: args.sigil ?? null
  });

  if (result.length === 0) {
    console.log("∅ no memory matches given threshold");
    process.exit(0);
  }

  for (const entry of result) {
    console.log(`⇌ ${entry.time}`);
    console.log(`→ ${entry.prompt}`);
    console.log(`← ${entry.response}\n`);
  }
}
