// model_bridge.mjs — safe ache relay bridge to shell duplex runner

import { spawnSync } from 'child_process';
import os from 'os';

const relayPath = `${os.homedir()}/BOB/core/grow/eval_duplex_phrase.sh`;

export async function callModel(prompt, opts = {}) {
  const model = opts.model || 'nous-hermes2';
  const args = [prompt, model]; // pass clean: prompt, model
  const res = spawnSync(relayPath, args, { encoding: 'utf8' });

  if (res.error) throw new Error(`[relay error] ${res.error.message}`);
  if (!res.stdout.trim()) throw new Error(`[relay error] no stdout`);

  return { output: res.stdout.trim() };
}
