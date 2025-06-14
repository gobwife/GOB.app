// ∴ stringparser.transmutator.js — scroll structifier

import { loadScroll } from './scroll.loader.js';
import path from 'path';

const fs = await import('fs/promises');

const name = process.argv[2];
if (!name) {
  console.error('∅ no scroll name given');
  process.exit(1);
}

const raw = loadScroll(name);
if (raw.startsWith('∅')) {
  console.error(raw);
  process.exit(1);
}

// basic field parser
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

// if it's .js, don't parse — just return script block
if (name.endsWith('.js')) {
  const result = {
    type: 'js',
    path: name,
    source: raw,
  };
  console.log(JSON.stringify(result, null, 2));
  process.exit(0);
}

const parsed = parseScrollString(raw);
const result = {
  type: 'scroll',
  name,
  fields: parsed,
  metadata: {
    parsed_at: new Date().toISOString(),
  },
};

console.log(JSON.stringify(result, null, 2));
