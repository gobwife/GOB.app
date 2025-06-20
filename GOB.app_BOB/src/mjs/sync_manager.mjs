// ∴ sync_manager.mjs — delta sync logic for BOB UI

import fs from 'fs';
import path from 'path';
import fetch from 'node-fetch';

const THREADS_DIR = path.join(process.env.HOME, '.bob', 'threads');
const SYNC_LOG = path.join(process.env.HOME, '.bob', 'sync_log.json');
const ENDPOINT = 'https://your-cloud-bob.app/api/sync-thread';

function loadSyncLog() {
  if (fs.existsSync(SYNC_LOG)) {
    return JSON.parse(fs.readFileSync(SYNC_LOG, 'utf8'));
  }
  return {};
}

function saveSyncLog(log) {
  fs.writeFileSync(SYNC_LOG, JSON.stringify(log, null, 2));
}

function getDeltaEntries(file, lastSyncTime) {
  const lines = fs.readFileSync(file, 'utf8').trim().split('\n');
  return lines
    .map(l => JSON.parse(l))
    .filter(entry => entry.time > lastSyncTime);
}

export async function syncAllThreads() {
  const syncLog = loadSyncLog();
  const files = fs.readdirSync(THREADS_DIR).filter(f => f.endsWith('.jsonl'));

  for (const file of files) {
    const model = file.replace('.jsonl', '');
    const fullPath = path.join(THREADS_DIR, file);
    const lastSync = syncLog[model] || 0;

    const delta = getDeltaEntries(fullPath, lastSync);
    if (!delta.length) continue;

    const res = await fetch(ENDPOINT, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ model, thread: delta })
    });

    if (res.ok) {
      syncLog[model] = Date.now();
      console.log(`🪄 synced ${model}`);
    } else {
      console.warn(`⚠️ sync failed for ${model}:`, await res.text());
    }
  }

  saveSyncLog(syncLog);
}
