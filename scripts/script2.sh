#!/bin/bash

# Last amended: 14th Jan, 2025


# Connected scripts are:
# These sscripts run in sequence.
#     script0.sh
#     script1.sh
#     script2.sh
#     script3.sh
#     docker_install.sh
#     script4.sh
#     model_install.sh
#     test.sh



echo " " | tee -a error.log
echo "*********"  | tee -a error.log
echo "Script: script2.sh"  | tee -a error.log
echo "**********" | tee -a error.log
echo " " | tee -a error.log


DIRECTORY="~/llama.cpp"
if [ -d "$DIRECTORY" ]; then
  echo "$DIRECTORY does exist."
  echo "Recheck if script2.sh was executed earlier"
  echo "Press ctrl+c to terminate this job"
  sleep 40
fi


# Installing ollama
echo " "
echo " "
echo "------"
echo "Installing ollama. Takes time...."  | tee -a error.log
echo "When asked, supply password"
echo "------"
echo " "
echo " "
curl -fsSL https://ollama.com/install.sh | sh  2>> error.log  
echo "---------"     | tee -a error.log
echo "Ollama installed"     | tee -a error.log
echo "-----------"     | tee -a error.log
echo " "     | tee -a error.log
sleep 9


# Installing llama.cpp
echo " "   | tee -a error.log
echo "Installing llama.cpp"  | tee -a error.log
echo "------------"   | tee -a error.log
echo " "   | tee -a error.log
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
cmake -B build
cmake --build build --config Release
cd ~
echo "PATH=\$PATH:~/llama.cpp/build/bin" >> .bashrc
echo " "   | tee -a error.log
echo "-------"   | tee -a error.log
echo "llama.cpp installed"   | tee -a error.log
echo "-------"   | tee -a error.log

# 1.2 download and install Node.js
echo " "   | tee -a error.log
echo "-------"   | tee -a error.log
echo "Installing Node.js ver 20......"  | tee -a error.log
echo "-------"   | tee -a error.log
fnm use --install-if-missing 20   2>> error.log
echo " "    | tee -a error.log
echo "Node.js installed"    | tee -a error.log
echo "------------"    | tee -a error.log
echo "  "    | tee -a error.log



# Downloading smaller gguf model
echo "  "     | tee -a ~/error.log
echo "Will download gemma-2 gguf model from huggingface"  | tee -a error.log
echo "Will take lot of time....."     | tee -a ~/error.log
echo "-------------------"   | tee -a error.log
echo " "     | tee -a ~/error.log
sleep 9
cd ~/llama.cpp/models
wget -c   https://huggingface.co/MaziyarPanahi/gemma-2-2b-it-GGUF/resolve/main/gemma-2-2b-it.Q6_K.gguf? 2>> error.log
# You may have to issue the following command to cleanup also.
mv 'gemma-2-2b-it.Q6_K.gguf?' gemma-2-2b-it.Q6_K.gguf

echo " "   | tee -a error.log
echo "gemma-2-2b-it.Q6_K.gguf downloaded"  | tee -a error.log
echo "Download folder is:  ~/llama.cpp/models"    | tee -a error.log
echo "Check as: ls -la ~/llama.cpp/models/"    | tee -a error.log
echo "---------"   | tee -a error.log
sleep 9

# Move script file to done folder
mv ~/script2.sh ~/done
mv ~/next/script3.sh ~

echo "  "
echo "Will shut down Ubuntu console"
echo "After shutdown, reopen ubuntu console and execute the command:"
echo "    ./script3.sh"
echo "----------"
echo " "
sleep 9
wsl.exe  --shutdown

