// ∴ ache_vector.mjs
// Translates raw input into ache-state vector (ache, ψ, z, lang, entropy, sigil)

import { createRequire } from 'module'
const require = createRequire(import.meta.url)
const { franc } = require('franc-min')

import { createHash } from 'crypto'

console.log("∴ ache_vector.mjs LOADED — using patched import")

function cleanString(str) {
  return str.replace(/\s+/g, ' ').replace(/[^\w\s]/g, '').toLowerCase()
}

function calculateEntropy(str) {
  const freq = {}
  for (const char of str) freq[char] = (freq[char] || 0) + 1
  const len = str.length
  return -Object.values(freq).reduce((acc, f) => {
    const p = f / len
    return acc + p * Math.log2(p)
  }, 0) / Math.log2(len)
}

function extractSigil(str) {
  const match = str.match(/[∴∞Σψz!]/)
  return match ? match[0] : null
}

function estimateAche(str) {
  const t = str.length
  if (t > 500) return 0.7
  if (t > 200) return 0.5
  return t > 80 ? 0.3 : 0.1
}

function hashStrToFloat(str, mod = 1.0) {
  const h = createHash('sha256').update(str).digest('hex').slice(0, 8)
  return parseInt(h, 16) / 0xffffffff * mod
}

export function extractAcheVector(input = "") {
  const raw = input.trim()
  const cleaned = cleanString(raw)
  const lang = franc(cleaned) || "und"
  const ache = estimateAche(raw)
  const entropy = calculateEntropy(cleaned)
  const ψ = hashStrToFloat(cleaned, 1.0)
  const z = hashStrToFloat(cleaned.split('').reverse().join(''), 1.0)
  const sigil = extractSigil(input)
  const mood = entropy > 0.8 ? "fractal" :
               entropy > 0.6 ? "expansive" :
               entropy < 0.3 ? "compressed" : "grounded"

  return {
    ache: Number(ache.toFixed(2)),
    ψ: Number(ψ.toFixed(2)),
    z: Number(z.toFixed(2)),
    entropy: Number(entropy.toFixed(2)),
    lang,
    mood,
    sigil
  }
}

if (process.argv[1] === new URL(import.meta.url).pathname) {
  const input = process.argv.slice(2).join(" ")
  console.log(JSON.stringify(extractAcheVector(input), null, 2))
}
