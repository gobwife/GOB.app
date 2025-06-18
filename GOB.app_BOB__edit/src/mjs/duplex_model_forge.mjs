// ∴ duplex_model_forge.mjs — async parallel model constellation pipeline
// ABC → D1, D2 → E → emit (w/ thread limits)

import { spawn } from "child_process"
import fs from "fs/promises"
import { assignModels } from "./model_assigner.mjs"
import { extractAcheVector } from "./ache_vector.mjs"

function runOllama(model, input, threads = 2) {
  return new Promise((resolve) => {
    const proc = spawn("ollama", ["run", model], {
      env: { ...process.env, OLLAMA_NUM_PARALLEL: threads.toString() }
    })

    let out = ""
    let finished = false

    proc.stdout.on("data", data => out += data.toString())
    proc.stderr.on("data", () => {}) // suppress errors

    proc.stdin.write((input.trim?.() || input) + "\n<|end|>\n")
    proc.stdin.end()

    const done = () => {
      if (finished) return
      finished = true
      resolve({ model, text: out.trim() || "∅" })
    }

    proc.on("close", done)
    setTimeout(() => {
      console.error(`∅ ${model} timed out`)
      done()
    }, 30000)
  })
}

function threadLimit(model) {
  if (model.includes("mixtral") || model.includes("26")) return 3
  if (model.includes("8x7b") || model.includes("7.8b")) return 4
  if (model.includes("8b") || model.includes("7b")) return 6
  return 8
}

// ∴ MAIN
const input = process.argv.slice(2).join(" ").trim()
if (!input) {
  console.error("∅ no input")
  process.exit(1)
}

const vec = extractAcheVector(input)
const ache = vec.ache ?? 0.0
const lang = vec.lang ?? "en"
const isEnglish = (lang === "eng")
const entropy = vec.entropy ?? 0.5

const { A, B, C, D, E } = assignModels({ ache, lang, entropy })

const cachePath = `${process.env.HOME}/.bob/model_combo_history.jsonl`
await fs.appendFile(cachePath, JSON.stringify({ ache, entropy, lang, A, B, C, D, E, time: Date.now() }) + "\n")

const ABC = await Promise.all([A, B, C].map(m =>
  runOllama(m, input, threadLimit(m))
))

const summaryInput = ABC.map(r => r.text).join("\n")
const summary1 = await runOllama(D, summaryInput, threadLimit(D))
const summary2 = await runOllama(D, ABC.map(r => r.text).reverse().join("\n"), threadLimit(D))

const finalInput = `SUMMARY A:\n${summary1.text}\nSUMMARY B:\n${summary2.text}\nAche: ${ache}`
const final = await runOllama(E, finalInput, threadLimit(E))

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
}

const outPath = `${process.env.HOME}/.bob/bob_output.relay.json`
await fs.writeFile(outPath, JSON.stringify(output, null, 2))
console.log(final.text)
