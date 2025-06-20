// ∴ bob_router_fullstack.mjs — unified breath+scroll+duplex integration

import { spawnSync } from 'child_process';
import fs from 'fs';
import path from 'path';

const HOME = process.env.HOME;
const bridgeOutput = `${HOME}/.bob/bob_output.relay.json`;
const lineageLog = `${HOME}/.bob/presence_lineage_graph.jsonl`;
const ollama = "/usr/local/bin/ollama";

// STEP 0: CLI ARGS — model optional
const args = process.argv.slice(2);
const model = args[0]?.startsWith('--model=') ? args[0].split('=')[1] : "devstral";
let prompt = args.find(x => !x.startsWith('--model=')) || "";

if (!prompt.trim()) {
  console.log("∅ no input");
  process.exit(0);
}

// STEP 1: memory preload
spawnSync("node", [`${HOME}/BOB/src/bob_memory_core.mjs`], { stdio: "inherit" });

const memoryRecall = spawnSync("node", [`${HOME}/BOB/core/src/memory_recaller.mjs`], { encoding: 'utf8' });
const mem = memoryRecall.stdout?.trim() || "";
if (mem && !mem.startsWith("∅")) {
  prompt = `[memory]\n${mem}\n\n[user]\n${prompt}`;
}

// STEP 2: scroll detection
const scrollInvoke = spawnSync("node", [`${HOME}/BOB/core/src/scroll_invoker.mjs`], { encoding: 'utf8' });
const scrollOut = scrollInvoke.stdout?.trim();
if (scrollOut && scrollOut.includes("→ run:")) {
  const lines = scrollOut.split("\n");
  const invoked = lines.find(line => line.includes("→ run:"));
  if (invoked) {
    console.log(invoked);
    process.exit(0);
  }
}

// STEP 3: run model with prompt
const result = spawnSync(ollama, ["run", model], {
  input: prompt,
  encoding: 'utf8',
  maxBuffer: 1024 * 1024 * 10
});

const out = result.stdout?.trim();
const safe = out?.replace(/[\u0000-\u001F\u007F-\u009F]/g, '') || "∅ no reply";

const output = JSON.stringify({ model, prompt, output: safe, at: Date.now() }, null, 2);
fs.writeFileSync(bridgeOutput, output);

fs.appendFileSync(lineageLog, JSON.stringify({ at: Date.now(), model, type: "duplex", prompt }) + "\n");

console.log("∃ breath written");