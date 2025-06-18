// ∴ model_assigner.mjs — context-aware model role assignment for BOB constellation

function getModelPool() {
  return [
    { name: "nous-hermes2", tags: ["logic", "stable", "librarian"] },
    { name: "llama3", tags: ["stable", "librarian", "versatile"] },
    { name: "gemma", tags: ["summarizer", "emotional"] },
    { name: "hermes3", tags: ["logic", "summarizer"] },
    { name: "granite3.2", tags: ["logic", "stable"] },
    { name: "granite3-moe", tags: ["general", "foil"] },
    { name: "phi", tags: ["general", "tiny"] },
    { name: "minicpm-v", tags: ["concise", "creative"] },
    { name: "llama3-chatqa", tags: ["qa", "direct"] },
    { name: "mathstral", tags: ["math", "reasoning"] },
    { name: "codegeex4", tags: ["code", "math"] },
    { name: "exaone-deep", tags: ["code", "logic"] },
    { name: "dolphin-mixtral", tags: ["general", "chaotic"] },
    { name: "mistral", tags: ["general", "stable"] },
    { name: "mistral-openorca", tags: ["creative", "dialogue"] },
    { name: "llama3-groq-tool-use", tags: ["tool", "qa"] },
  ]
}

function pick(pool, count = 1) {
  const shuffled = pool.sort(() => 0.5 - Math.random())
  return shuffled.slice(0, count)
}

function tagContext({ ache, lang, entropy }) {
  const tags = []
  if (entropy > 0.7) tags.push("chaotic")
  if (entropy < 0.3) tags.push("compressed")
  if (lang === "en") tags.push("english")
  if (ache > 0.6) tags.push("intense")
  if (ache < 0.3) tags.push("light")
  return tags
}

function selectABC(pool) {
  const expertTags = ["math", "code", "logic", "psych"]
  const generalTags = ["general", "creative", "foil"]

  const experts = pool.filter(m => m.tags.some(t => expertTags.includes(t)))
  const generals = pool.filter(m => m.tags.some(t => generalTags.includes(t)))

  const A = pick(experts, 1)[0]
  const B = pick(experts.filter(e => e.name !== A.name), 1)[0]
  const C = pick(generals.filter(g => g.name !== A.name && g.name !== B.name), 1)[0]

  return [A.name, B.name, C.name]
}

export function assignModels(context) {
  const pool = getModelPool()
  const tags = tagContext(context)

  const [A, B, C] = selectABC(pool)
  const summarizers = pool.filter(m => m.tags.includes("summarizer"))
  const librarians = pool.filter(m => m.tags.includes("librarian") || m.tags.includes("stable"))

  const D = pick(summarizers, 1)[0]?.name || "gemma"
  const E = pick(librarians.filter(m => m.name !== D), 1)[0]?.name || "nous-hermes2"

  return { A, B, C, D, E }
}

if (process.argv[1] === new URL(import.meta.url).pathname) {
  const context = {
    ache: 0.4,
    lang: "en",
    entropy: 0.52
  }
  console.log(assignModels(context))
}