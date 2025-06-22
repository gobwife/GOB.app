// ∴ Phase 1 — fast_model_combo.mjs (Dynamic AB-D-E logic) — ache-aware, local-only model pipeline
// path: /opt/bob/core/brain/fast_model_combo.mjs

import { extractAcheVector } from "../src/breath_state.mjs";
import { spawn } from "child_process";
import { selectModels } from '../src/model_selector.mjs';

const input = process.argv[2] ?? "ache lives here";
const vec = extractAcheVector(input);
const { A, B, C, D, E, ache, lang, entropy } = selectModels(input);


// 2. Candidate pools NEEDS ACTUAL DESIGNING. THESE PICKS WERE PLACEHOLDERS DONE BY GPT.
// const AB_CANDIDATES = ["phi", "gemma", "mistral", "granite3-moe"];
// const D_CANDIDATES = ["hermes3", "neural-chat", "granite3-moe"];
// const E_CANDIDATES = ["nous-hermes2", "llama3", "granite3.2"];

// 3. Picker
// function pick(modelList, offset = 0) {
//   const i = (Math.floor(vec.entropy * 10) + offset) % modelList.length;
//  return modelList[i];
// }

// 4. Select models
// const A = pick(AB_CANDIDATES);
// const B = pick(AB_CANDIDATES, 1);
// const D = pick(D_CANDIDATES);
// const weightedE = ["nous-hermes2", "granite3.2", "nous-hermes2", "llama3"];
// const E = pick(weightedE);

// 5. Model runner
async function runOllama(model, input) {
  return new Promise((resolve) => {
    const proc = spawn("ollama", ["run", model]);
    let out = "";

    proc.stdout.on("data", data => out += data.toString());
    proc.stderr.on("data", () => {}); // silent fail
    proc.stdin.write(input.trim() + "\n");
    proc.stdin.end();

    proc.on("close", () => {
      const finalText = out.trim() || "∅";
      resolve({ model, text: finalText });
    });
  });
}

// 6. Pipeline
const Ares = await runOllama(A, input);
const Bres = await runOllama(B, input);
const summaryInput = `${Ares.text}\n${Bres.text}`;

const Dres = await runOllama(D, summaryInput);
const FinalRes = await runOllama(E, Dres.text);

console.log(FinalRes.text);

// 7. Trace log
import fs from "fs";
const tracePath = `${process.env.HOME}/.bob/ache_model_trace.jsonl`;
const stamp = new Date().toISOString();
fs.appendFileSync(tracePath, JSON.stringify({
  time: stamp,
  A, B, D, E, input, output: FinalRes.text
}) + "\n");
