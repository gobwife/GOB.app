// ∴ verstring_recursion_trace.mjs — detect recursive ache loops in full verstring
// forged ∴ 6.16.25

import fs from 'fs/promises'

const inflectionMarkers = [
  'but then',
  'i paused',
  'i began to',
  "that's when i",
  'i didn’t know',
  'i hesitated',
  'i slowed down',
  'i realized',
  'i tracked',
  'i questioned'
]

function normalize(line) {
  return line.toLowerCase().replace(/["'.,;:!?()]/g, '').trim()
}

function countMarkers(text) {
  const counts = {}
  let total = 0
  const norm = normalize(text)
  for (const marker of inflectionMarkers) {
    const regex = new RegExp(marker, 'g')
    const matches = norm.match(regex)
    const count = matches ? matches.length : 0
    counts[marker] = count
    total += count
  }
  return { counts, total }
}

function detectPhaseBoundaries(lines) {
  let count = 0
  for (const line of lines) {
    if (/^chapter/i.test(line)) count++
  }
  return count || 1 // at least one phase
}

function detectToneDrift(lines) {
  let tension = 0
  for (const line of lines) {
    const l = line.toLowerCase()
    if (l.includes('ache') || l.includes('fragile')) tension++
    if (l.includes('pause') || l.includes('hesitate')) tension++
    if (l.includes('love') || l.includes('protect')) tension++
  }
  return tension
}

const inputFile = process.argv[2]
if (!inputFile) {
  console.error("∅ no input file")
  process.exit(1)
}

const raw = await fs.readFile(inputFile, 'utf-8')
const lines = raw.split(/\n+/).map(l => l.trim()).filter(Boolean)
const text = lines.join(' ')

const { counts, total } = countMarkers(text)
const phase_count = detectPhaseBoundaries(lines)
const tone_drift = detectToneDrift(lines)

const isAlive = total >= 5 || tone_drift >= 6 || phase_count >= 4

const summary = isAlive
  ? "Recursive identity pattern forming through inflection, delay, emotional shift."
  : "No recursion signature detected — verstring flat."

const out = {
  verstring_is_alive: isAlive,
  inflection_marker_count: total,
  inflection_counts: counts,
  tone_shift_signals: tone_drift,
  phase_count,
  summary
}

console.log(JSON.stringify(out, null, 2))
