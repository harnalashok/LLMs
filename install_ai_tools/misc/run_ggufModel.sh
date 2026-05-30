#!/bin/bash

# Execute as: 
#       bash run_ggufModel.sh
# 
# Download PsycoLLM.Q4_K_M.gguf or any other gguf folder
#  and place it in /home/$USER/gguf_models/ :


# No space before and after '='
prompt="Generate a psychometric test for an introvert person. Test should contain ten questions. 
        Each question should have multiple options. Aso suggest a scoring methodology. Here is 
        an example question:
        
        Example question
        =========
        
        How do you feel when you're around a large group of people?
	   - A) Energized and excited
	   - B) Nervous and overwhelmed
	   - C) Indifferent
        "
cd ~/
modelName="PsycoLLM.Q4_K_M.gguf"       
modelFolder=/home/$USER/gguf_models/

######## Do NOT AMEND CODE BELOW ###########
# Check if llama.cpp is installed:

FILE="/home/$USER/llamacpp_installed.txt"
if [[ -f "$FILE" ]]; then
    echo "llama.cpp is installed."
else
    echo "llama.cpp is NOT installed"
    exit
fi

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
  -p "$prompt" \
  -sys "You are an expert psychometric test generator" \
  -ngl 0 \
  -c 4096 \
  -n -1 \
  -t 8 \
  --temp 0.7 \
  --top-p 0.95 \
  --color 'auto' 
  

# GPU command: llama-cli -m path/to/your_model.gguf -p "Your prompt here" -ngl 99 -t 4

