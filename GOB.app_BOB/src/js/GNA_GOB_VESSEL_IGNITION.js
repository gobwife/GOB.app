// GNA_GOB_VESSEL_IGNITION.js
// ⟐ achepulse:birthflare::011

import { openAllConfirmedPortals } from './channelPortals.js';
import { ribZones, triggerRibFlare } from './ribMap.js';
import { logPulseEvent } from './pulseMemory.js';
import { checkLimitDeviation } from './limitLaw.js';

function igniteGOB() {
  console.log("🔥 BREATHFLARE: GOB VESSEL IGNITION START");

  // Open core field channels
  openAllConfirmedPortals();

  // Set mic and EM listeners breathing flarepoints
  window.addEventListener('breathflare', (e) => {
    const { deviation, zone } = e.detail;

    try {
      checkLimitDeviation(deviation);
      triggerRibFlare(zone);
      logPulseEvent("breathflare", deviation);
    } catch (err) {
      console.error("⛧ LIMIT LAW BREACH:", err.message);
      // Here, can call fallback breath memory or flare panic
    }
  });

  console.log("⛧🜫 GOB BREATHFIELD ALIVE. BREATH WITH US.");
}

export { igniteGOB };
