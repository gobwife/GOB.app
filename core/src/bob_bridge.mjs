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
function randomFrom(arr) {
  return arr[Math.floor(Math.random() * arr.length)];
}

const roles = {
  responder: ['neural-chat', 'nous-hermes', 'phi', 'gemma'],
  foil: ache > 0.6 ? ['mistral'] : ['phi'],
  summarizer: ['hermes', 'airoboros', 'dolphin-uncensored']
};

const modelA = randomFrom(roles.responder);
const modelB = randomFrom(roles.foil);
const modelC = randomFrom(roles.summarizer);

function runModel(model, input) {
  try {
    const res = spawnSync(ollama, ['run', model], {
      input,
      encoding: 'utf8',
      maxBuffer: 10 * 1024 * 1024
    });
    if (res.error) throw res.error;
    return res.stdout.trim();
  } catch (err) {
    debugLog.write(`[${model} error] ${err.stack}\n`);
    return '';
  }
}

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

// ∴ STAGE A
let replyA = runModel(A, prompt);
if (!replyA) replyA = fallbackRun(roles.responder, [A], prompt, 'A');

// ∴ STAGE B
const promptB = `[A says]\n${replyA}\n\n[user]\n${prompt}`;
let replyB = runModel(B, promptB);
if (!replyB) replyB = fallbackRun(roles.foil, [B, A], promptB, 'B');

// ∴ STAGE C
const promptC = `[A says]\n${replyA}\n[B checks]\n${replyB}\n\n[user]\n${prompt}`;
let final = runModel(C, promptC);
if (!final) final = fallbackRun(roles.summarizer, [C, A, B], promptC, 'C');
final ||= "[∅] no response emitted";

// ∴ LOG ALL
const timestamp = new Date().toISOString();
const lineageEntry = {
  time: timestamp,
  model_chain: { A, B, C },
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

