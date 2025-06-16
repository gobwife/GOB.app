// ∴ verstring_mineralizer.js — extract structured logic from raw verse string
// 6.14.25_MEATFACE

export function extractMinerals(verse = "") {
  const lines = verse.split(/\\n+/).map(line => line.trim()).filter(Boolean)

  const loops = []
  const math = []
  const logic = []

  for (const line of lines) {
    const lower = line.toLowerCase()

    // ∴ loop patterns
    if (/↔|<->|cycle|recursion|loop/.test(lower)) {
      loops.push(line)
    }

    // ∴ logic forms
    if (/if|then|else|therefore|∴|because/.test(lower)) {
      logic.push(line)
    }

    // ∴ math/symbol forms
    if (/\\+|\\-|\\*|\\/|=|≠|≤|≥|\\^/.test(lower)) {
      math.push(line)
    }
  }

  return {
    loops: [...new Set(loops)],
    logic: [...new Set(logic)],
    math: [...new Set(math)],
    lines: lines.length
  }
}

// ∴ CLI runner (optional)
if (process.argv[1].endsWith('verstring_mineralizer.js')) {
  const fs = await import('fs')
  const input = process.argv[2]
  const raw = fs.readFileSync(input, 'utf-8')
  const minerals = extractMinerals(raw)
  console.log(JSON.stringify(minerals, null, 2))
}
//"""

//with open("/mnt/data/verstring_mineralizer.js", "w") as f:
//    f.write(verstring_mineralizer.strip())