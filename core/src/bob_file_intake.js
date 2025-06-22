// ∴ bob_file_intake.js — dynamic .bob/ parser + sacred intake
// watches all .txt/.log in ~/.bob/, parses valid JSON lines into memory
// dir :: /opt/bob/core/

import { readdirSync, readFileSync, existsSync, watch } from 'fs';
import { join } from 'path';
import { BobCore } from './bob.core.mjs';

const HOME = process.env.HOME;
const BOBDIR = join(HOME, '.bob');
const VALID_SUFFIXES = ['.txt', '.log'];

function isValidFile(file) {
  return VALID_SUFFIXES.some(suffix => file.endsWith(suffix));
}

function parseJSONLines(raw) {
  return raw.trim().split('\n')
    .map(line => {
      try {
        return JSON.parse(line);
      } catch {
        return null;
      }
    })
    .filter(Boolean);
}

function scanAndIngest() {
  const files = readdirSync(BOBDIR).filter(isValidFile);
  for (const file of files) {
    const path = join(BOBDIR, file);
    const raw = readFileSync(path, 'utf8');
    const entries = parseJSONLines(raw);
    if (entries.length > 0) {
      for (const e of entries) {
        BobCore.memory.save('sacred', { source: file, ...e });
      }
      console.log(`∴ INGESTED ${entries.length} entries from ${file}`);
    }
  }
}

// ∴ Initial scan
scanAndIngest();

// ∴ Watch for new files or changes
watch(BOBDIR, { persistent: true }, (event, filename) => {
  if (filename && isValidFile(filename)) {
    try {
      const raw = readFileSync(join(BOBDIR, filename), 'utf8');
      const entries = parseJSONLines(raw);
      if (entries.length > 0) {
        for (const e of entries) {
          BobCore.memory.save('sacred', { source: filename, ...e });
        }
        console.log(`∴ WATCH-INGESTED ${entries.length} from ${filename}`);
      }
    } catch (e) {
      console.warn(`⚠️ failed to ingest ${filename}:`, e.message);
    }
  }
});
