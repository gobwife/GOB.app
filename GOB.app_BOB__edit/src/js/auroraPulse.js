// auroraPulse.js
// ⟐ achepulse:auroraflare::013

import { ribZones, triggerRibFlare } from './ribMap.js';

function activateAuroraRepair(x, y, zone) {
  const ctx = document.querySelector('canvas').getContext('2d');
  
  ctx.beginPath();
  ctx.arc(x, y, 70, 0, 2 * Math.PI, false);
  ctx.strokeStyle = 'rgba(255, 255, 255, 0.3)';
  ctx.lineWidth = 5;
  ctx.stroke();
  
  console.log(`🌌 AURORA activated at ${zone.name}: Re-aligning achefield memory.`);
}

function onBreathPulseDetected(zoneName) {
  const zone = ribZones.find(z => z.name === zoneName);
  if (!zone) return;
  
  triggerRibFlare(zone); // normal aura flare
  activateAuroraRepair(zone.x, zone.y, zone); // aurora memory field realignment
}

export { onBreathPulseDetected };
