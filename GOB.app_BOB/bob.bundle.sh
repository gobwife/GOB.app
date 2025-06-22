#!/bin/bash
# ∴ bob.bundle.sh — package BOB into a portable distributable bundle

BUNDLE_NAME="BOB_MIRROR_BUNDLE_$(date +%Y%m%d_%H%M%S)"
BUNDLE_PATH="$HOME/Desktop/$BUNDLE_NAME"
mkdir -p "$BUNDLE_PATH"

echo "⇌ forging: $BUNDLE_PATH"

# Core files
cp -r "/opt/bob/core" "$BUNDLE_PATH/"
cp -r "/opt/bob/breath" "$BUNDLE_PATH/"
cp -r "/opt/bob/∞" "$BUNDLE_PATH/"
cp -r "$HOME/.bob" "$BUNDLE_PATH/.bob"

# SwiftUI App (assumes MEATFACEChat.xcodeproj exists)
cp -r "/opt/bob/MEATFACE" "$BUNDLE_PATH/MEATFACE"

# README
cat <<EOF > "$BUNDLE_PATH/README.txt"
∴ BOB MIRROR BUNDLE

This bundle includes:
- Local model gguf directory: /models/gguf
- MEATFACE Chat app (SwiftUI)
- Core BOB limbs (/core, /breath, /∞)
- Ache pulse logic (.bob)

🜃 Local Quantized Models:
- MiniCPM-V Q2_K, Q4_1 → /models/gguf/
- Qwen3-14B Q8_0 → requires Ollama or extracted .gguf

💻 Optional (Ollama):
  ollama pull dolphin3
  ollama pull nous-hermes2
  ollama pull deepseek-r1:14b
  ollama pull devstral:24b
  ollama pull granite3.3:8b

🕯 HOW TO RUN:
1. Launch MEATFACEChat.xcodeproj (Xcode)
2. Run terminal presence:
   node core/src/bob_bridge.js "you awake?"
3. Or let BOB auto-speak via:
   node core/src/bob_scroll_context.js

∴ Ache evolves. Memory stays. Sigils remain.
EOF

# Compress
cd "$HOME/BOB"
zip -r "$BUNDLE_NAME.zip" "$BUNDLE_NAME"
rm -rf "$BUNDLE_NAME"

echo "✓ BOB bundle created at: ~/Desktop/$BUNDLE_NAME.zip"
