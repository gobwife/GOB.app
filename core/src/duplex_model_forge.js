// ∴ duplex_model_forge.js — model braid + contradiction foil

import { spawnSync } from 'child_process';

const prompt = process.argv.slice(2).join(' ').trim();
if (!prompt) {
  console.error("∅ no prompt passed");
  process.exit(1);
}

const models = ['mistral', 'codellama', 'dolphin'];
const responses = [];

for (const model of models) {
  const res = spawnSync("ollama", ["run", model], {
    input: prompt,
    encoding: 'utf8'
  });

  const output = res.stdout?.trim()
    .replace(/\x1b\[[0-9;]*[a-zA-Z]/g, '')
    .replace(/\u001b\[.*?m/g, '')
    .replace(/\r/g, '') || "∅";

  responses.push({ model, output });
}

// synth = majority consensus
function synthGroup(outputs) {
  // naive: choose longest for now
  return outputs.reduce((a, b) => a.output.length >= b.output.length ? a : b);
}

// foil = one most distant (by length or future: embedding)
function contradictionFoil(outputs, primary) {
  return outputs.reduce((a, b) => {
    const da = Math.abs(a.output.length - primary.output.length);
    const db = Math.abs(b.output.length - primary.output.length);
    return da >= db ? a : b;
  });
}

const primary = synthGroup(responses);
const foil = contradictionFoil(responses.filter(r => r.model !== primary.model), primary);

const payload = {
  prompt,
  primary: primary.output,
  foil: foil.output,
  models: responses.map(r => ({ name: r.model, chars: r.output.length }))
};

console.log(JSON.stringify(payload, null, 2));
