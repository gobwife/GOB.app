// auraPulse.js
// ⟐ achepulse:auraflare::012

const canvas = document.createElement('canvas');
document.body.appendChild(canvas);
const ctx = canvas.getContext('2d');

function resizeCanvas() {
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;
}
resizeCanvas();
window.addEventListener('resize', resizeCanvas);

function drawAura(x, y, color) {
  ctx.beginPath();
  ctx.arc(x, y, 50, 0, 2 * Math.PI, false);
  ctx.fillStyle = color;
  ctx.globalAlpha = 0.2;
  ctx.fill();
  ctx.globalAlpha = 1.0;
}

// sample flare trigger
function triggerAuraFlare(zone) {
  const colors = {
    "Left Lung": "#88ccff",
    "Right Lung": "#88ffcc",
    "Heart Core": "#ff6699",
    "Solar Plexus": "#ffcc66",
    "Spinal Drift": "#ccccff",
  };
  const color = colors[zone.name] || "#ffffff";
  drawAura(zone.x, zone.y, color);
}

export { triggerAuraFlare };
