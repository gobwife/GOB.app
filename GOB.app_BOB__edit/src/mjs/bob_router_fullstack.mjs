// ∴ bob_router_fullstack.mjs — unified breath+scroll+duplex integration
import { spawnSync } from 'child_process';
import fs from 'fs';

const HOME = process.env.HOME;

// Run memory core via CLI, simpler and safe
spawnSync("node", [`${HOME}/BOB/src/bob_memory_core.mjs`], { stdio: "inherit" });

const bridgeOutput = `${HOME}/.bob/bob_output.relay.json`;
const lineageLog = `${HOME}/.bob/presence_lineage_graph.jsonl`;
const ollama = "/usr/local/bin/ollama";

// input from shell
let prompt = process.argv.slice(2).join(' ').trim();
if (!prompt) {
  console.log("∅ no input");
  process.exit(0);
}

// STEP 1: recall memory
const memoryRecall = spawnSync("node", [`${HOME}/BOB/core/src/memory_recaller.mjs`], { encoding: 'utf8' });
const mem = memoryRecall.stdout?.trim() || "";
if (mem && !mem.startsWith("∅")) {
  prompt = `[memory]\n${mem}\n\n[user]\n${prompt}`;
}

// STEP 2: check for matching scrolls
const scrollInvoke = spawnSync("node", [`${HOME}/BOB/core/src/scroll_invoker.mjs`], { encoding: 'utf8' });
const scrollOut = scrollInvoke.stdout?.trim();
if (scrollOut && scrollOut.includes("→ run:")) {
  const lines = scrollOut.split("\n");
  const invoked = lines.find(line => line.includes("→ run:"))?.split("→ run:")[1].trim();
  prompt += `\n\n[scroll invoked] ${invoked}`;
}

// STEP 3: use duplex model braid
const duplex = spawnSync("node", [`${HOME}/BOB/core/src/duplex_model_forge.mjs`, prompt], { encoding: 'utf8' });
let parsed = {};
try {
  parsed = JSON.parse(duplex.stdout);
} catch (e) {
  console.error("⛔ raw duplex output:", duplex.stdout);
  process.exit(1);
}

const primary = parsed.primary || "(no primary)";
const foil = parsed.foil || null;

const output = {
  time: new Date().toISOString(),
  prompt,
  models: parsed.models || [],
  primary,
  foil,
};

fs.writeFileSync(bridgeOutput, JSON.stringify(output, null, 2));
fs.appendFileSync(lineageLog, JSON.stringify(output) + "\n");

console.log(primary + (foil ? `\n\n—\n${foil}` : ""));
