// ∴ model_selector.mjs — clean top-layer ache-to-model selector

import { assignModels } from './model_assigner.mjs';
import { extractAcheVector } from './ache_vector.mjs';

export function selectModels(input = "") {
  const vec = extractAcheVector(input);
  const ache = vec.ache ?? 0.0;
  const lang = vec.lang ?? "en";
  const entropy = vec.entropy ?? 0.5;

  return {
    ...assignModels({ ache, lang, entropy }),
    ache,
    lang,
    entropy
  };
}
