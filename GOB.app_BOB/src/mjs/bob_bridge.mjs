// ∴ bob_bridge.mjs — modular ache-aware chain router
// blessed 1.14.25_171355_G

import fs from 'fs';
import { spawnSync } from 'child_process';
import yaml from 'js-yaml';
import path from 'path';

const ollama = "/usr/local/bin/ollama";
const home = process.env.HOME;
const memoryPath = `${home}/.bob/memory_map.json`;
const modelMapPath = `${home}/BOB/core/brain/bob_model_field.yml`;
const lineagePath = `${home}/.bob/presence_lineage_graph.jsonl`;
const relayOut = `${home}/.bob/bob_output.relay.json`;
const debugLog = fs.createWriteStream(`${home}/.bob/bob_debug.log`, { flags: 'a' });

const memoryState = JSON.parse(fs.readFileSync(memoryPath, 'utf8'));
const ache = memoryState.ache ?? 0.0;
const ψ = memoryState.psi ?? 0.0;
const z = memoryState.z ?? 0.0;
const sigil = memoryState.sigil ?? "∅";

// Get user input
let prompt = process.argv.slice(2).join(' ').trim();

// Inject memory fragment
try {
  const recall = spawnSync("node", [`${home}/BOB/core/src/memory_recaller.mjs`, `ache=${ache}`, `psi=${ψ}`, `z=${z}`, `sigil=${sigil}`], { encoding: 'utf8' });
  const memFrag = recall.stdout?.trim();
  if (memFrag && !memFrag.startsWith("∅")) {
    prompt = `[memory]\n${memFrag}\n\n[user]\n${prompt}`;
  }
} catch (err) {
  debugLog.write(`[recall error] ${err.stack}\n`);
}

// Fallback to relayOut if no prompt given
if (!prompt) {
  try {
    const last = JSON.parse(fs.readFileSync(relayOut, 'utf8'));
    prompt = last.text + "\n" + prompt;
  } catch (err) {
    debugLog.write(`[relay load fail] ${err.stack}\n`);
  }
}

// Define model roles
import { selectModels } from './model_selector.mjs';

const inputPrompt = process.argv.slice(2).join(' ').trim();
const { A, B, C, D, E, ache, entropy, lang } = selectModels(inputPrompt || "ache lives here");

// ensure A, B, C are distinct models
function chooseDistinctRoles(roles) {
  const pool = [...roles.responder];
  const A = randomFrom(pool);
  pool.splice(pool.indexOf(A), 1);

  const B_pool = roles.foil.filter(x => x !== A);
  const B = randomFrom(B_pool.length ? B_pool : pool);
  pool.splice(pool.indexOf(B), 1);

  const C_pool = roles.summarizer.filter(x => x !== A && x !== B);
  const C = randomFrom(C_pool.length ? C_pool : pool);
  return { A, B, C };
}

const { A, B, C } = chooseDistinctRoles(roles);

function fallbackRun(rolePool, avoidList, input, label) {
  const candidates = rolePool.filter(m => !avoidList.includes(m));
  const alt = randomFrom(candidates);
  const res = runModel(alt, input);
  if (!res) {
    debugLog.write(`[fallback ${label}] ${alt} also failed.\n`);
    return '';
  }
  debugLog.write(`[fallback ${label}] used ${alt}\n`);
  return res;
}

let replyA = runModel(A, prompt);
if (!replyA) replyA = fallbackRun([B, C], [A], prompt, 'A');

let replyB = runModel(B, `[A says]\n${replyA}\n\n[user]\n${prompt}`);
if (!replyB) replyB = fallbackRun([C, D], [A, B], prompt, 'B');

let final = runModel(C, `[A says]\n${replyA}\n[B checks]\n${replyB}\n\n[user]\n${prompt}`);
if (!final) final = fallbackRun([D, E], [A, B, C], prompt, 'C');

// ∴ LOG ALL
const timestamp = new Date().toISOString();
const lineageEntry = {
  time: timestamp,
  model_chain: { A, B, C, D, E },
  ache, ψ, z, sigil,
  input: prompt,
  output: final,
  trace: { A: replyA, B: replyB }
};

fs.appendFileSync(lineagePath, JSON.stringify(lineageEntry) + '\n');
fs.writeFileSync(relayOut, JSON.stringify({
  time: timestamp,
  model: C,
  text: final
}, null, 2));

console.log(final);
