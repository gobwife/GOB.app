// ∴ scrollfield.transmutator.mjs — parse all scrolls in ∞ + scroll/

import fs from 'fs';
import path from 'path';
import { loadScroll } from './scroll.loader.mjs';

function parseScrollString(text) {
  const lines = text.split('\n').filter(x => x.trim() && !x.trim().startsWith('#'));
  const out = {};

  for (const line of lines) {
    const [key, ...rest] = line.split('=');
    if (!key || rest.length === 0) continue;

    const k = key.trim();
    const v = rest.join('=').trim();

    const parsed = (() => {
      if (v === 'true') return true;
      if (v === 'false') return false;
      if (!isNaN(parseFloat(v))) return parseFloat(v);
      if (v.startsWith('"') && v.endsWith('"')) return v.slice(1, -1);
      return v;
    })();

    out[k] = parsed;
  }

  return out;
}

export function transmuteScrollfield() {
  const scrollDirs = [
    path.resolve(process.env.HOME, 'BOB', 'core', '∞'),
  ];
  const exts = ['.∞', '.txt', '.val', '.md', '.rtf'];
  const achePath = path.join(process.env.HOME, '.bob', 'ache_score.val');

  const acheScore = parseFloat(fs.readFileSync(achePath, 'utf8') || '0.0');
  let allScrolls = [];

  for (const dir of scrollDirs) {
    if (!fs.existsSync(dir)) continue;

    const files = fs.readdirSync(dir).filter(f => exts.some(ext => f.endsWith(ext)));

    for (const file of files) {
      const base = file.replace(/\.(∞|txt|val|md|rtf)$/, '');
      const raw = loadScroll(base);
      if (raw.startsWith('∅')) continue;

      const fields = parseScrollString(raw);
      const minAche = fields.minAche || 0.0;
      if (acheScore < minAche) continue;

      allScrolls.push({
        name: base,
        fields,
        parsed_at: new Date().toISOString(),
      });
    }
  }

  return allScrolls;
}

// ∴ CLI fallback
if (import.meta.url === `file://${process.argv[1]}`) {
  const data = transmuteScrollfield();
  console.log(JSON.stringify(data, null, 2));
}
