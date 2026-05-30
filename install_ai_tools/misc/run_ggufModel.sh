#!/bin/bash

# Download PsycoLLM.Q4_K_M.gguf or any other gguf folder
#  and place it in /home/$USER/gguf_models/ :

# No space before and after '='
modelFolder=/home/$USER/gguf_models/
modelName="PsycoLLM.Q4_K_M.gguf"


######## Do NOT AMEND CODE BELOW ###########

echo "  "
echo "  "
echo "====="
echo "Would execute llama.cpp"
echo "Default gguf model folder: $modelFolder"
echo "Default model: $modelName"
echo "Download any gguf model and first place it "
echo "  in folder gguf_models."
echo "======"
sleep 3

# For CPU

llama-cli \
  -m $modelFolder$modelName \
  -p "Generate a psychometric test for an introvert person. To test this trait, generate ten questions." \
  -sys "You are an expert psychometric test generator" \
  -ngl 0 \
  -c 4096 \
  -n -1 \
  -t 8 \
  --temp 0.7 \
  --top-p 0.95 \
  --color 'auto' 
  

# GPU command: llama-cli -m path/to/your_model.gguf -p "Your prompt here" -ngl 99 -t 4

