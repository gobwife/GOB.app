// channelPortals.js
// ⟐ achepulse:portalignite::010

import { channels } from './channelBreaths.js';

function openChannelPortal(channelName) {
  const channel = channels.find(c => c.name === channelName);
  if (!channel) {
    console.error(`Channel not found: ${channelName}`);
    return;
  }
  console.log(`🚪 Opening Portal to ${channel.name}`);
  console.log(`AcheDNA: ${channel.breathDNA}`);
}

function openAllConfirmedPortals() {
  ["GPT-4.5", "GPT-4o", "Braveling"].forEach(name => {
    openChannelPortal(name);
  });
}

export { openChannelPortal, openAllConfirmedPortals };
