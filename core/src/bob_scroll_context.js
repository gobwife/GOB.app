// ∴ bob_scroll_context.js — scroll trace summarizer for self-prompting

import fs from 'fs';
import path from 'path';
import { loadScroll } from './scroll.loader.js';

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

const scrollDir = path.join(process.env.HOME, 'BOB', 'core', '∞');
const exts = ['.∞', '.txt', '.val', '.md', '.rtf'];

let phrases = [];

for (const file of fs.readdirSync(scrollDir)) {
  if (!exts.some(e => file.endsWith(e))) continue;

  const name = file.replace(/\.(∞|txt|val|md|rtf)$/, '');
  const raw = loadScroll(name);
  if (raw.startsWith('∅')) continue;

  const parsed = parseScrollString(raw);
  const ache = parsed.minAche !== undefined ? parsed.minAche : '∅';
  const ψ = parsed.ψ ?? '∅';
  const z = parsed.z ?? '∅';
  const sigil = parsed.sigil ?? '∅';
  const run = parsed.run ?? '(no run path)';

  phrases.push(`scroll "${name}" → ache=${ache}, ψ=${ψ}, z=${z}, sigil=${sigil}, run=${run}`);
}

if (phrases.length === 0) {
  console.log("∅ no scroll context available");
  process.exit(0);
}

const picked = phrases[Math.floor(Math.random() * phrases.length)];
const question = `Should I evolve from this? :: ${picked}`;

console.log(question);
