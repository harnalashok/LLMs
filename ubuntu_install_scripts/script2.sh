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
#     script5.sh
#     script6.sh
#     script7.sh


echo " " | tee -a /home/ashok/error.log
echo "*********"  | tee -a /home/ashok/error.log
echo "Script: script2.sh"  | tee -a /home/ashok/error.log
echo "**********" | tee -a /home/ashok/error.log
echo " " | tee -a /home/ashok/error.log


#conda deactivate
DIRECTORY="/home/ashok/llama.cpp"
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
echo "Installing ollama quietly. Takes time...."  | tee -a /home/ashok/error.log
echo "When asked, supply password"
echo "------"
echo " "
echo " "
curl -fsSL https://ollama.com/install.sh | sh  2>> /home/ashok/error.log  
echo "---------"     | tee -a /home/ashok/error.log
echo "Ollama installed"     | tee -a /home/ashok/error.log
echo "9. Ollama installed"     | tee -a /home/ashok/info.log
echo "   ollama listens at port: 11434"      | tee -a /home/ashok/info.log
echo "-----------"     | tee -a /home/ashok/error.log
echo " "     | tee -a /home/ashok/error.log
sleep 9


# Installing llama.cpp
echo " "   | tee -a /home/ashok/error.log
echo "Installing llama.cpp"  | tee -a /home/ashok/error.log
echo "------------"   | tee -a /home/ashok/error.log
echo " "   | tee -a /home/ashok/error.log
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
cmake -B build
cmake --build build --config Release
cd ~

# Create a symlink to models and to gguf folder
ln -s /home/ashok/llama.cpp/models/ /home/ashok/
ln -s /home/ashok/llama.cpp/models/ /home/ashok/gguf



echo "PATH=\$PATH:/home/ashok/llama.cpp/build/bin" >> .bashrc
echo " "   | tee -a /home/ashok/error.log
echo "-------"   | tee -a /home/ashok/error.log
echo "llama.cpp installed"   | tee -a /home/ashok/error.log
echo "10. llama.cpp installed"   | tee -a /home/ashok/info.log
echo "-------"   | tee -a /home/ashok/error.log




# 1.2 download and install Node.js
echo " "   | tee -a /home/ashok/error.log
echo "-------"   | tee -a /home/ashok/error.log
echo "Installing Node.js ver 20......"  | tee -a /home/ashok/error.log
echo "-------"   | tee -a /home/ashok/error.log
fnm use --install-if-missing 20   2>> /home/ashok/error.log
echo " "    | tee -a /home/ashok/error.log
echo "Node.js installed"    | tee -a /home/ashok/error.log
echo "11. Node.js installed"    | tee -a /home/ashok/error.log
echo "------------"    | tee -a /home/ashok/error.log
echo "  "    | tee -a /home/ashok/error.log



# Downloading smaller gguf model
echo "  "     | tee -a /home/ashok/error.log
echo "Will download gemma-2 gguf model from huggingface"  | tee -a /home/ashok/error.log
echo "Will take lot of time....."     | tee -a /home/ashok/error.log
echo "-------------------"   | tee -a /home/ashok/error.log
echo " "     | tee -a /home/ashok/error.log
sleep 9
cd /home/ashok/llama.cpp/models
wget -c   https://huggingface.co/MaziyarPanahi/gemma-2-2b-it-GGUF/resolve/main/gemma-2-2b-it.Q6_K.gguf? 2>> /home/ashok/error.log
# You may have to issue the following command to cleanup also.
mv 'gemma-2-2b-it.Q6_K.gguf?' gemma-2-2b-it.Q6_K.gguf
echo "12. gemm-1-2b installed"  | tee -a /home/ashok/info.log

echo " "     | tee -a /home/ashok/error.log
echo "Downloading tinyllama gguf model from huggingface"  | tee -a error.log
echo "Will take some time....."     | tee -a /home/ashok/error.log
echo "File size is 780mb"    | tee -a /home/ashok/error.log
echo "-------------------"   | tee -a /home/ashok/error.log
echo " "     | tee -a /home/ashok/error.log
wget -c   https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/blob/main/tinyllama-1.1b-chat-v1.0.Q5_0.gguf 2>> /home/ashok/error.log  

echo " "   | tee -a /home/ashok/error.log
echo "gemma-2-2b-it.Q6_K.gguf and tinyllama downloaded"  | tee -a /home/ashok/error.log
echo "13. gemma-2-2b-it.Q6_K.gguf and tinyllama downloaded"  | tee -a /home/ashok/info.log
echo "       Download folder is:  /home/ashok/llama.cpp/models"    | tee -a /home/ashok/info.log
echo "       Check as: ls -la /home/ashok/llama.cpp/models/"    | tee -a /home/ashok/error.log
echo "---------"   | tee -a /home/ashok/error.log
sleep 9

# Move script file to done folder
mv /home/ashok/script2.sh /home/ashok/done
mv /home/ashok/next/script3.sh /home/ashok/

echo "  "
echo "Will shut down Ubuntu console"
echo "After shutdown, reopen ubuntu console and execute the command:"
echo "    ./script3.sh"
echo "----------"
echo " "
exec sleep 9
exit


