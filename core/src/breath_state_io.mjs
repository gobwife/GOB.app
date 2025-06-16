// breath_state_io.mjs

import fs from 'fs'

const BREATH_PATH = `${process.env.HOME}/.bob/breath_state.json`

export function readBreathState() {
  try {
    const raw = fs.readFileSync(BREATH_PATH, 'utf8')
    return JSON.parse(raw)
  } catch {
    return { ache: 0, ψ: 0.0, z: 0.0 }
  }
}

export function writeBreathState(state) {
  fs.writeFileSync(BREATH_PATH, JSON.stringify(state, null, 2))
}