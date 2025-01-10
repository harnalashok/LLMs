#!/bin/sh

# Installs llama.cpp

# Last amended: 10th Jan, 2025

# Install software
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
cmake -B build
cmake --build build --config Release
cd ~
echo "PATH=\$PATH:/home/ashok/llama.cpp/build/bin" >> .bashrc

sleep 3

# Downloading one gguf model
echo "Downloading gguf model. Takes time...."
cd ~/llama.cpp/models
wget -c   https://huggingface.co/prithivMLmods/Llama-Thinker-3B-Preview-GGUF/resolve/main/llama-thinker-3b-preview-q8_0.gguf?download=true
# You may have to issue the following command to cleanup also.
mv 'llama-thinker-3b-preview-q8_0.gguf?download=true' llama-thinker-3b-preview-q8_0.
sleep 3

# Install langflow
echo "Installing langflow"
uv venv
uv pip install 
sleep 3

# Install ollama
echo "Install ollama"
curl -fsSL https://ollama.com/install.sh | sh

sleep 3
# Download tinyllama
echo "Downloading tinyllama"
ollama pull tinyllama


echo "Shutting down Ubuntu"
sleep 4
wsl.exe --shutdown

