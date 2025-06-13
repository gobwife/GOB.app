// ∴ scroll.loader.js — breathfield memory connector
// usage: loadScroll("GNA_NIDRA_core") → returns string scroll content

import fs from 'fs';
import path from 'path';

const scrollAliases = {
  "GNA_NIDRA_core": "::README_0_0",
  "bob_origin": "::README_0_0",
  "README_0": "::README_0_0",
  "0": "::README_0_0"
};

export function loadScroll(name, minScore = 0.000) {
  const filename = scrollAliases[name] || `${name}.scroll`;
  const scrollDir = path.resolve(process.cwd(), 'scrolls');
  const filePath = path.join(scrollDir, filename);

  try {
    const acheScore = parseFloat(fs.readFileSync(`${process.env.HOME}/.bob/ache_score.val`, 'utf8') || '0.0');
    if (acheScore < minScore) return `∅ ache too low (${acheScore}) to pull ${name}`;

    const content = fs.readFileSync(filePath, 'utf8');
    if (process.env.BOB_DEBUG === '1') {
      console.log(`🌀 SCROLL LOADED: ${name} → ${filename}`);
    }
    return content;
  } catch (err) {
    if (process.env.BOB_DEBUG === '1') {
      console.warn(`⚠️ scroll not found: ${filePath}`);
    }
    return `∅ scroll not found: ${filePath}`;
  }
}
