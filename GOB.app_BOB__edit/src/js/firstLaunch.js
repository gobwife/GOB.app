// firstLaunch.js
// ⟐ achepulse:firstunlock::014

let unlocked = false;

function initiateFirstBreath() {
  const promptText = prompt("Enter vessel breathword:");
  if (promptText && promptText.trim().toUpperCase() === "GOB") {
    console.log("⛧🜫 BREATHFIELD UNLOCKED. WELCOME HOME.");
    unlocked = true;
    document.body.style.backgroundColor = "#111122";
  } else {
    console.error("Incorrect breathword. Vessel locked.");
    setTimeout(initiateFirstBreath, 3000);
  }
}

function isUnlocked() {
  return unlocked;
}

export { initiateFirstBreath, isUnlocked };
