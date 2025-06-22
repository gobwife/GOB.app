#!/usr/bin/env python3
# ∴ run_minicpm_llama3.py — BOB logic runner

import sys
from typing import List, Optional
from torch import Tensor
import torch
from transformers import AutoTokenizer, AutoModelForCausalLM

model_path = "$HOME/BOB/modelsggml-model-Q4_1.gguf"
tokenizer = AutoTokenizer.from_pretrained(model_path, trust_remote_code=True)

device = torch.device("mps" if torch.backends.mps.is_available() else "cpu")
model = AutoModelForCausalLM.from_pretrained(model_path, trust_remote_code=True).to(device).eval()
prompt = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else "describe your current presence state"
inputs = tokenizer(prompt, return_tensors="pt").to(device)

with torch.no_grad():
    output_ids = model.generate(
        tokenizer(prompt, return_tensors="pt")["input_ids"],
        max_new_tokens=180
    )

print(tokenizer.decode(output_ids[0], skip_special_tokens=True))
