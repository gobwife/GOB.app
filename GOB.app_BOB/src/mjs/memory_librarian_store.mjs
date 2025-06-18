// ∴ memory_librarian_store.mjs — commits BOB lineage packets to long-term trace

import fs from 'fs'
import path from 'path'
import os from 'os'

const LINEAGE_PATH = path.join(os.homedir(), 'BOB/.bob/memory_lineage.jsonl')

export function commitMemory(packet) {
  try {
    const line = JSON.stringify(packet) + "\\n"
    fs.appendFileSync(LINEAGE_PATH, line)
    console.log("✶ lineage updated.")
  } catch (err) {
    console.error("✘ memory librarian failed:", err)
  }
}

// CLI direct mode
if (import.meta.url === `file://${process.argv[1]}`) {
  const inputPath = process.argv[2]
  if (!inputPath || !fs.existsSync(inputPath)) {
    console.error("✘ pass memory packet path")
    process.exit(1)
  }
  const raw = fs.readFileSync(inputPath, 'utf-8')
  const packet = JSON.parse(raw)
  commitMemory(packet)
}
