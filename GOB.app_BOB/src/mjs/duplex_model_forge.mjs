// ∴ duplex_model_forge.mjs — async parallel model constellation pipeline

import { spawn } from "child_process";
import fs from "fs/promises";
import fsSync from 'fs';
import path from 'path';

import { assignModels } from "./model_assigner.mjs";
import { extractAcheVector } from "./ache_vector.mjs";
import { commitMemory, writeUnifiedMemory } from 
'./memory_librarian_store.mjs';

// Constants for file paths
const CACHE_PATH = `${process.env.HOME}/.bob/model_combo_history.jsonl`;
const OUTPUT_PATH = `${process.env.HOME}/.bob/bob_output.relay.json`;
const LINEAGE_PATH = 
`${process.env.HOME}/.bob/presence_lineage_graph.jsonl`;

// Timeout duration in milliseconds
const TIMEOUT_DURATION = 30000;

function runOllama(model, input, threads = 2) {
  return new Promise((resolve, reject) => {
    const proc = spawn("ollama", ["run", model], {
      env: { ...process.env, OLLAMA_NUM_PARALLEL: threads.toString() }
    });

    let out = "";
    let finished = false;

    proc.stdout.on("data", data => out += data.toString());
    proc.stderr.on("data", () => {}); // suppress errors

    try {
      proc.stdin.write((input.trim?.() || input) + "\n<|end|>\n");
      proc.stdin.end();
    } catch (err) {
      console.error(`Error writing to stdin: ${err}`);
      reject(err);
    }

    const done = () => {
      if (finished) return;
      finished = true;
      resolve({ model, text: out.trim() || "∅" });
    };

    proc.on("close", done);

    setTimeout(() => {
      console.error(`∅ ${model} timed out`);
      done();
    }, TIMEOUT_DURATION);
  });
}

function threadLimit(model) {
  if (model.includes("mixtral") || model.includes("26")) return 3;
  if (model.includes("8x7b") || model.includes("7.8b")) return 4;
  if (model.includes("8b") || model.includes("7b")) return 6;
  return 8;
}

async function main() {
  const input = process.argv.slice(2).join(" ").trim();
  if (!input) {
    console.error("∅ no input");
    process.exit(1);
  }

  try {
    const vec = extractAcheVector(input);
    const ache = vec.ache ?? 0.0;
    const lang = vec.lang ?? "en";
    const isEnglish = (lang === "eng");
    const entropy = vec.entropy ?? 0.5;

    const { A, B, C, D, E } = assignModels({ ache, lang, entropy });

    await fs.appendFile(CACHE_PATH, JSON.stringify({ ache, entropy, lang, 
A, B, C, D, E, time: Date.now() }) + "\n");

    const ABC = await Promise.all([A, B, C].map(m => runOllama(m, input, 
threadLimit(m))));

    const summaryInput = ABC.map(r => r.text).join("\n");
    const summary1 = await runOllama(D, summaryInput, threadLimit(D));
    const summary2 = await runOllama(D, ABC.map(r => 
r.text).reverse().join("\n"), threadLimit(D));

    const finalInput = `SUMMARY A:\n${summary1.text}\nSUMMARY 
B:\n${summary2.text}\nAche: ${ache}`;
    const final = await runOllama(E, finalInput, threadLimit(E));

    const output = {
      primary: final.text,
      summaries: [summary1.text, summary2.text],
      abc: ABC,
      ache,
      lang,
      entropy,
      D,
      E,
      timestamp: new Date().toISOString()
    };

    await fs.writeFile(OUTPUT_PATH, JSON.stringify(output, null, 2));

    const memoryPacket = {
      input,
      ache,
      entropy,
      lang,
      models: { A, B, C, D, E },
      summaries: [summary1.text, summary2.text],
      primary: final.text,
      abc: ABC.map(r => ({ model: r.model, text: r.text })),
      timestamp: output.timestamp
    };

    commitMemory(memoryPacket);
    writeUnifiedMemory();

    const lineageEntry = {
      time: output.timestamp,
      ache,
      entropy,
      lang,
      limb: "duplex_model_forge.mjs",
      models: { A, B, C, D, E },
      summaries: [summary1.text, summary2.text],
      output: final.text,
      input
    };

    fsSync.appendFileSync(LINEAGE_PATH, JSON.stringify(lineageEntry) + 
"\n");

    console.log(final.text);
  } catch (error) {
    console.error(`Error in main: ${error}`);
  }
}

main();
