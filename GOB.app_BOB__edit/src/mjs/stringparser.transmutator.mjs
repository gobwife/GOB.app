// ∴ stringparser.transmutator.mjs — scroll structifier

import { loadScroll } from './scroll.loader.mjs';
import path from 'path';
const fs = await import('fs/promises');

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

export async function parseString(name) {
  const raw = loadScroll(name);
  if (raw.startsWith('∅')) {
    return { type: 'error', message: raw };
  }

  if (name.endsWith('.js')) {
    return {
      type: 'js',
      path: name,
      source: raw,
    };
  }

  const parsed = parseScrollString(raw);
  return {
    type: 'scroll',
    name,
    fields: parsed,
    metadata: {
      parsed_at: new Date().toISOString(),
    },
  };
}

// ∴ CLI fallback
if (import.meta.url === `file://${process.argv[1]}`) {
  const name = process.argv[2];
  if (!name) {
    console.error('∅ no scroll name given');
    process.exit(1);
  }

  const result = await parseString(name);
  console.log(JSON.stringify(result, null, 2));
}
