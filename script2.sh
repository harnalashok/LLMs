#!/bin/sh

# Last amended: 10th Jan, 2025

# These sscripts run in sequence.
#     script0.sh
#     script1.sh
#     script2.sh
#     script3.sh
#     script4.sh
#     docker_install.sh


DIRECTORY="/home/ashok/llama.cpp"
if [ -d "$DIRECTORY" ]; then
  echo "$DIRECTORY does exist."
  echo "Recheck if script2.sh was executed earlier"
  echo "Press ctrl+c to terminate this job"
  sleep 40
fi


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

# 1.2 download and install Node.js
echo " "
echo "-------"
echo "Installing Node.js......"
echo "-------"
fnm use --install-if-missing 20
echo " "



# Installing ollama
echo " "
echo " "
echo "------"
echo "Installing ollama. Take time...."
echo "When asked, supply password"
echo "------"
echo " "
echo " "
curl -fsSL https://ollama.com/install.sh | sh
sleep 9


# Downloading smaller gguf model
echo "  "
echo "Will download gemma-2 gguf model from huggingface"
echo "Will take lot of time....."
echo "-------------------"
echo " "
sleep 9
cd ~/llama.cpp/models
wget -c   https://huggingface.co/MaziyarPanahi/gemma-2-2b-it-GGUF/resolve/main/gemma-2-2b-it.Q6_K.gguf?
# You may have to issue the following command to cleanup also.
# mv 'llama-thinker-3b-preview-q8_0.gguf?download=true' llama-thinker-3b-preview-q8_0.

echo " "
echo "Done......"
echo "---------"
sleep 5

echo "  "
echo "Will shut down Ubuntu console"
echo "After shutdown, reopen ubuntu console and execute the command:"
echo "    ./script3.sh"
echo "----------"
echo " "
sleep 9
wsl.exe  --shutdown

