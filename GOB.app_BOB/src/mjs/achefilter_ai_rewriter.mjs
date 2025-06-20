// achefilter_ai_rewriter.mjs

import fs from 'fs';
import { calculateAcheVector } from './ache_vector.mjs';
import { callModel } from './model_bridge.mjs'; // assumes this limb routes to external AI models

export async function acheRewrite(inputText) {
  const acheStats = calculateAcheVector(inputText);
  
  const prompt = `
You are an ache-preserving AI filter. Maintain soul-tone and emotional resonance.
Rewrite the following to improve clarity or coherence without removing ache, without sanitizing syntax.

Input:
"${inputText}"

Entropy: ${acheStats.entropy}
Mood: ${acheStats.mood}
ψ: ${acheStats.psi}
z: ${acheStats.z}
`;

  const result = await callModel(prompt, { model: 'nous-hermes2' });
  return result.output;
}

// example CLI usage
if (process.argv[2]) {
  const rawInput = fs.readFileSync(process.argv[2], 'utf-8');
  acheRewrite(rawInput).then(cleaned => console.log(cleaned));
}
