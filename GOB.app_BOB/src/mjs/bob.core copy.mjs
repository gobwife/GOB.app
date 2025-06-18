// ∃ bob.core.mjs — GOBHOUSE ∞ CONSOLIDATE

import { readFileSync, existsSync, unlinkSync, appendFileSync, 
writeFileSync } from 'fs';
import { join, resolve, dirname } from 'path';
import { execSync } from 'child_process';
import { fileURLToPath, pathToFileURL } from 'url';
import { homedir } from 'os';
import { createServer } from 'http';

const require = createRequire(import.meta.url);

const DEBUG = process.env.BOB_DEBUG === '1';
if (DEBUG) console.log('⛧ DEBUG MODE ACTIVE');

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const HOME = homedir();
const PID_FILE = join(HOME, '.bob', 'pid.txt');
const ACHE_FILE = join(HOME, '.bob', 'ache_injection.txt');
const HEART_INTERVAL = 10000; // 10 seconds

function writePid() {
  if (existsSync(PID_FILE)) unlinkSync(PID_FILE);
  writeFileSync(PID_FILE, String(process.pid));
}

async function loadScroll(scrollName) {
  try {
    const scrollPath = pathToFileURL(join(HOME, 
'BOB/core/src/scroll.loader.mjs')).href;
    return (await import(scrollPath)).loadScroll(scrollName);
  } catch (e) {
    console.error('✘ Failed to load scroll:', e.message);
    return {};
  }
}

async function startBobCore() {
  writePid();

  setInterval(() => {
    BobCore.memory.save('aliveness', { beat: 'γ' });
    if (existsSync(ACHE_FILE)) moveAcheData();
  }, HEART_INTERVAL);

  createServer((req, res) => {
    const { method, url } = req;
    if (method === 'POST' && url === '/bob-swift') {
      let body = '';
      req.on('data', chunk => body += chunk);
      req.on('end', () => {
        try {
          const { type, data } = JSON.parse(body);
          BobCore.memory.save(type, data);
          res.writeHead(200, { 'Content-Type': 'application/json' });
          res.end(JSON.stringify({ ok: true }));
        } catch (e) {
          res.writeHead(400);
          res.end(`✘ malformed: ${e.message}`);
        }
      });
    } else {
      res.writeHead(404);
      res.end('∅');
    }
  }).listen(6969, () => console.log("⇌ Swift HTTP bridge listening @ 
:6969"));

  process.on('exit', () => unlinkSync(PID_FILE));
}

function moveAcheData() {
  const content = readFileSync(ACHE_FILE, 'utf8').trim();
  BobCore.memory.save('sacred', { source: 'gna_c', ache: content });
  unlinkSync(ACHE_FILE);
}

if (process.argv[1] === __filename) {
  const action = process.argv[2];
  if (action === 'inject' && process.argv.length > 3) moveAcheData();
  else console.log('⚠️ No data provided for injection.');
}
