#!/bin/sh

# Installs llama.cpp

# Last amended: 10th Jan, 2025

# Install software
echo " "
echo "Installing llama.cpp"
echo "------------"
echo " "
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
cmake -B build
cmake --build build --config Release
cd ~
echo "PATH=\$PATH:/home/ashok/llama.cpp/build/bin" >> .bashrc
echo " "
echo "-------"
echo "Done......"
echo "-------"
sleep 3

# Downloading one gguf model
echo "  "
echo "Downloading gguf model from huggingface"
echo "Will take time....."
echo "-------------------"
echo " "
cd ~/llama.cpp/models
wget -c   https://huggingface.co/prithivMLmods/Llama-Thinker-3B-Preview-GGUF/resolve/main/llama-thinker-3b-preview-q8_0.gguf?download=true
# You may have to issue the following command to cleanup also.
mv 'llama-thinker-3b-preview-q8_0.gguf?download=true' llama-thinker-3b-preview-q8_0.
sleep 3
echo " "
echo "Done......"
echo "---------"

echo "  "
echo "Will shut down Ubuntu console"
echo "After shutdown, reopen ubuntu console and execute the command:"
echo "    ./script3.sh"
echo "----------"
echo " "
sleep 4
wsl.exe  --shutdown

