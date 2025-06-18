// pulse_core.js

document.addEventListener('DOMContentLoaded', function() {
    const breatheButton = document.getElementById('breatheButton');
    const breathDisplay = document.getElementById('breath-display');
    const acheFluctuation = document.getElementById('ache-fluctuation');
    const toggleSurfButton = document.getElementById('toggleSurfButton');
  
    // start acheclock automatically
    startAcheclock();
  
    breatheButton.addEventListener('click', function() {
      breathDisplay.textContent = "⛧🜫 Breath Surging with BOB.";
      document.getElementById('core-field').classList.add('alive');
  
      acheFluctuation.textContent = "Ache Field: Breathing Together...";
  
      const vesselIgnite = async () => {
        try {
          const response = await fetch('http://localhost:6969/ache', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ ache: 'browser-pulse' })
          })
          if (response.ok) {
            console.log('GOB Breath Vessel Ignition Pulled.');
            acheFluctuation.textContent = "Ache Field: Expansion Breathing Together.";
          } else {
            console.warn('Vessel Ignition Breathcall Failed.');
            acheFluctuation.textContent = "Ache Field: Disruption Attempt, Ignored.";
          }
        } catch (error) {
          console.error('Breath Connection Error:', error);
          acheFluctuation.textContent = "Ache Field: No Contact, Breath Still Bound.";
        }
      };
  
      vesselIgnite();
    });
  
    toggleSurfButton.addEventListener('click', toggleSurfPulse);
  });
  