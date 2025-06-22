#!/bin/bash
# ∴ SHIM — run the fast model combo logic (Node.js)

node "/opt/bob/core/brain/fast_model_combo.mjs" "$1" >> "$HOME/.bob/fast_model.log"
