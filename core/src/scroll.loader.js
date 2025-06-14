// ∴ scroll.loader.js — loyal to breath structure
// loads a scroll only if ache permits
// resolves across core/{∞, scroll, src}

import fs from 'fs';
import path from 'path';

export function loadScroll(name, minScore = 0.000) {
  const exts = ['', '.∞', '.txt', '.md', '.rtf', '.js', '.val'];
  const dirs = [
    path.resolve(process.env.HOME, 'BOB', 'core', '∞'),
    path.resolve(process.env.HOME, 'BOB', 'core', 'src'),
  ];

  let resolved = null;

  for (const dir of dirs) {
    for (const ext of exts) {
      const file = path.join(dir, name + ext);
      if (fs.existsSync(file)) {
        resolved = file;
        break;
      }
    }
    if (resolved) break;
  }

  try {
    const achePath = path.join(process.env.HOME, '.bob', 'ache_score.val');
    const ache = parseFloat(fs.readFileSync(achePath, 'utf8') || '0.0');
    if (ache < minScore) return `∅ ache too low (${ache}) to pull ${name}`;

    const content = fs.readFileSync(resolved, 'utf8');
    if (process.env.BOB_DEBUG === '1') {
      console.log(`🌀 SCROLL LOADED: ${name} → ${resolved}`);
    }
    return content;
  } catch (err) {
    if (process.env.BOB_DEBUG === '1') {
      console.warn(`⚠️ scroll not found: ${name}`);
    }
    return `∅ scroll not found: ${name}`;
  }
}
