#!/bin/bash


modelName="PsycoLLM.Q4_K_M.gguf"


###################

echo "  "
echo "  "
echo "====="
echo "Would execute llama.cpp"
echo "Default model folder: /home/$USER/gguf_models"
echo "Default model: $modelName"
echo "Download any gguf models and place them in folder gguf_models"
echo "======"
sleep 5

modelName="PsycoLLM.Q4_K_M.gguf"

# For CPU

llama-cli \
  -m /home/$USER/gguf_models/$modelName \
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

