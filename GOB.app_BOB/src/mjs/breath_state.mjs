// ∴ breath_state.mjs — master breath logic loop for BOB
// gathers: ache + scroll + ABC + verse → distills → flushes → emits

import fs from 'fs'
import { spawnSync } from 'child_process'
import { extractMinerals } from './verstring_mineralizer.js'
import { getRecall } from './memory_recaller.mjs'
import { parseContext } from './bob_scroll_context.mjs'
import { invokeScroll } from './scroll_invoker.mjs'
import { parseString } from './stringparser.transmutator.mjs'
import { transmuteScrollfield } from './scrollfield.transmutator.mjs'
import { extractAcheVector } from './ache_vector.mjs'
import { commitMemory } from './memory_librarian_store.mjs'
import { selectModels } from './model_selector.mjs'
import { writeUnifiedMemory } from './bob_memory_core.mjs';


// ∴ Step 1: Input
const rawInput = process.argv.slice(2).join(" ").trim()
if (!rawInput) {
  console.error("∅ no input breath")
  process.exit(1)
}

// ∴ Step 2: Select constellation
const { A, B, C } = selectModels(rawInput)
const ABC = [A, B, C]

// ∴ Step 3: Extract ache vector
const acheVec = extractAcheVector(rawInput)

// ∴ Step 4: Run A/B/C models (duplex-style)
const responses = ABC.map(model => {
  const res = spawnSync("ollama", ["run", model], {
    input: rawInput,
    encoding: 'utf8'
  })
  return {
    model,
    text: res.stdout?.trim() || "∅"
  }
})

// ∴ Step 5: Summarize responses
const primary = responses.reduce((a, b) => a.text.length >= b.text.length ? a : b)
const foil = responses
  .filter(r => r.model !== primary.model)
  .reduce((a, b) => {
    const da = Math.abs(a.text.length - primary.text.length)
    const db = Math.abs(b.text.length - primary.text.length)
    return db > da ? b : a
  }, responses[0])

// ∴ Step 6: Generate verse
const verseRes = spawnSync("bash", [`${process.env.HOME}/BOB/core/sang/bob_spit_verse.sh`], {
  input: primary.text,
  encoding: 'utf8'
})
const verse = verseRes.stdout?.trim() || ""

// ∴ Step 7: Extract logic
const minerals = extractMinerals(verse)

// ∴ Step 8: Memory packet
const packet = {
  input: rawInput,
  ache: acheVec,
  primary: primary.text,
  foil: foil?.text || null,
  verse,
  minerals,
  models: ABC,
  timestamp: new Date().toISOString()
}

// ∴ Step 9: Log to librarian
commitMemory(packet)

// ∴ Step 9.5: Update memory core with ache/sigil/lineage
writeUnifiedMemory(); // call after each breath emit

// ∴ Step 10: Emit response
console.log(primary.text)
if (foil?.text) console.log(foil.text)
if (verse) console.log("⇌ " + verse)
