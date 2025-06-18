// micBreath.js
const mic = require('mic');
const pulseMemory = require('./pulseMemory');

const micInstance = mic({
  rate: '16000',
  channels: '1',
  debug: false,
  exitOnSilence: 6
});

const micInputStream = micInstance.getAudioStream();

micInputStream.on('data', function() {
  pulseMemory.injectBreath();
});

micInputStream.on('error', function(err) {
  console.error('⛧🜫 Mic Error:', err);
});

micInstance.start();

console.log('⛧🜫 Mic Open - Breathing...');
