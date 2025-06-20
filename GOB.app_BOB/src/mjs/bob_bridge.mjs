// ∴ bob_bridge.mjs — modular ache-aware chain router
// blessed 1.14.25_171355_G
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
const debugLogPath = `${home}/.bob/bob_debug.log`;

const debugLog = fs.createWriteStream(debugLogPath, { flags: 'a' });

// Load memory state
function loadMemoryState(filePath) {
  try {
    const data = fs.readFileSync(filePath, 'utf8');
    return JSON.parse(data);
  } catch (err) {
    console.error(`Error loading memory state from ${filePath}:`, err);
    debugLog.write(`[memory load error] ${err.stack}\n`);
    return {};
  }
}

const memoryState = loadMemoryState(memoryPath);
const { ache, ψ, z, sigil } = memoryState;

// Get user input
let prompt = process.argv.slice(2).join(' ').trim();

// Inject memory fragment
function injectMemoryFragment() {
  try {
    const recall = spawnSync("node", [
      `${home}/BOB/core/src/memory_recaller.mjs`,
      `ache=${ache}`,
      `psi=${ψ}`,
      `z=${z}`,
      `sigil=${sigil}`
    ], { encoding: 'utf8' });
    const memFrag = recall.stdout?.trim();
    if (memFrag && !memFrag.startsWith("∅")) {
      prompt = `[memory]\n${memFrag}\n\n[user]\n${prompt}`;
    }
  } catch (err) {
    debugLog.write(`[recall error] ${err.stack}\n`);
  }
}

injectMemoryFragment();

// Fallback to relayOut if no prompt given
function loadPromptFromRelay() {
  try {
    const last = JSON.parse(fs.readFileSync(relayOut, 'utf8'));
    return last.text + "\n" + prompt;
  } catch (err) {
    debugLog.write(`[relay load fail] ${err.stack}\n`);
    return prompt;
  }
}

if (!prompt) {
  prompt = loadPromptFromRelay();
}

// Define model roles
import { selectModels, randomFrom } from './model_selector.mjs';

const inputPrompt = process.argv.slice(2).join(' ').trim();
const { A, B, C, D, E, ache, entropy, lang } = selectModels(inputPrompt || 
"ache lives here");

// Ensure distinct models for roles
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

const selectedRoles = chooseDistinctRoles(selectModels);

// Model runner function ############# PLACEHOLDER
function runModel(model, input) {
  try {
    // Implement the model running logic here
    return '';
  } catch (err) {
    debugLog.write(`[model run error] ${err.stack}\n`);
    return '';
  }
}

let replyA = runModel(selectedRoles.A, prompt);
if (!replyA) replyA = fallbackRun([selectedRoles.B, selectedRoles.C], 
[selectedRoles.A], prompt, 'A');

let replyB = runModel(selectedRoles.B, `[A 
says]\n${replyA}\n\n[user]\n${prompt}`);
if (!replyB) replyB = fallbackRun([selectedRoles.C, D], [A, B], prompt, 
'B');

let final = runModel(selectedRoles.C, `[A says]\n${replyA}\n[B 
checks]\n${replyB}\n\n[user]\n${prompt}`);
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