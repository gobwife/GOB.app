// ∴ scroll_invoker.js — invoke matching scroll based on breath state

import fs from 'fs';
import path from 'path';
import { exec } from 'child_process';
import { loadScroll } from './scroll.loader.js';

// simple field parser (same as in transmutators)
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

// breath reference state
const breathPath = path.join(process.env.HOME, 'BOB', 'core', 'breath', 'breath_state.json');
const breath = JSON.parse(fs.readFileSync(breathPath, 'utf8') || '{}');
const ache = breath.ache ?? 0;
const psi = breath["ψ"] ?? 0;
const z = breath.z ?? 0;
const sigil = breath.sigil ?? "∅";

// candidate scrolls
const scrollDir = path.join(process.env.HOME, 'BOB', 'core', '∞');
const exts = ['.∞', '.txt', '.val', '.md', '.rtf'];

let candidates = [];

for (const file of fs.readdirSync(scrollDir)) {
  if (!exts.some(e => file.endsWith(e))) continue;

  const name = file.replace(/\.(∞|txt|val|md|rtf)$/, '');
  const raw = loadScroll(name);
  if (raw.startsWith('∅')) continue;

  const parsed = parseScrollString(raw);
  const minAche = parsed.minAche ?? 0;

  if (ache < minAche) continue;

  const matchesSigil = !parsed.sigil || parsed.sigil === sigil;
  const matchesPsi   = !parsed.psi   || psi >= parsed.psi;
  const matchesZ     = !parsed.z     || z >= parsed.z;

  if (matchesSigil && matchesPsi && matchesZ && parsed.run) {
    candidates.push({ name, run: parsed.run, parsed });
  }
}

if (candidates.length === 0) {
  console.log("∅ no matching scroll found.");
  process.exit(0);
}

const chosen = candidates[0]; // could improve with effort sorting later

console.log(`⇌ invoking scroll: ${chosen.name}`);
console.log(`→ run: ${chosen.run}`);

const runPath = chosen.run.replace('$HOME', process.env.HOME);
const fullRun = path.isAbsolute(runPath)
  ? runPath
  : path.join(process.env.HOME, 'BOB', runPath);

exec(`bash ${fullRun}`, (err, stdout, stderr) => {
  if (err) {
    console.error(`✘ limb failed: ${err.message}`);
    return;
  }
  if (stdout) console.log(stdout.trim());
  if (stderr) console.error(stderr.trim());
});
