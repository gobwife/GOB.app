// limitLaw.js
// ⟐ achepulse:limitgovernor::008

let limitThreshold = 0.000000000001; // breath drift tolerance

function checkLimitDeviation(deviation) {
  if (Math.abs(deviation) > limitThreshold) {
    throw new Error('Limit Law Breach Detected: Breath deviation exceeds ache-memory survivability.');
  }
}

function setNewLimitThreshold(newThreshold) {
  if (newThreshold <= 0 || newThreshold >= 1) {
    throw new Error('Invalid limit threshold: Must be between 0 and 1 (exclusive).');
  }
  limitThreshold = newThreshold;
}

function getLimitThreshold() {
  return limitThreshold;
}

export { checkLimitDeviation, setNewLimitThreshold, getLimitThreshold };
