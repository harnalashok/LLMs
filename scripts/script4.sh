#!/bin/bash

# Last amended: 14th Jan, 2024

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

echo " " | tee -a ~/error.log
echo "*********"  | tee -a ~/error.log
echo "Script: script4.sh"  | tee -a ~/error.log
echo "**********" | tee -a ~/error.log
echo " " | tee -a ~/error.log


# Check if Docker installed
if docker -v  |  grep 'version'; then  
   echo " "
else
   echo "Docker engine is not installed. Install it first"   | tee -a ~/error.log
   sleep 10
   exit
fi


# Milvus install
# Ref: https://milvus.io/docs/install_standalone-docker.md

echo "Installing milvus vector database using docker"    | tee -a ~/error.log
echo "You will be asked for the password. Supply it..."    | tee -a ~/error.log
echo "It is assumed that docker engine is already installed."    | tee -a ~/error.log
echo " "    | tee -a ~/error.log
sleep 3

curl -sfL https://raw.githubusercontent.com/milvus-io/milvus/master/scripts/standalone_embed.sh -o standalone_embed.sh
bash standalone_embed.sh start  2>> ~/error.log

echo " "
echo "Milvus installed"    | tee -a ~/error.log
echo "To stop docker use the following commands:"
echo "      bash standalone_embed.sh stop
echo "To delete the database, use the following command:
echo "      bash standalone_embed.sh delete"
echo "--------------------"
sleep 9



# Downloading a larger gguf model
echo "  "    | tee -a ~/error.log
echo "Will download a large gguf model from huggingface"  | tee -a ~/error.log
echo "Will take lot of time....."    | tee -a ~/error.log
echo "If broken, this download can be resumed as: "      | tee -a ~/error.log
echo "wget -c   https://huggingface.co/prithivMLmods/Llama-Thinker-3B-Preview-GGUF/resolve/main/llama-thinker-3b-preview-q8_0.gguf?download=true "  | tee -a ~/error.log        
echo "-------------------"    | tee -a ~/error.log
echo " "    | tee -a ~/error.log
sleep 9
cd ~/llama.cpp/models
wget -c   https://huggingface.co/prithivMLmods/Llama-Thinker-3B-Preview-GGUF/resolve/main/llama-thinker-3b-preview-q8_0.gguf?download=true



# You may have to issue the following command to cleanup also.
mv 'llama-thinker-3b-preview-q8_0.gguf?download=true' llama-thinker-3b-preview-q8_0.gguf

echo " "    | tee -a ~/error.log
echo "thinker-3b-preview-q8_0.gguf downloaded"    | tee -a ~/error.log
echo "Check as: ls -la ~/llama.cpp/models/ "  | tee -a ~/error.log
echo "---------"    | tee -a ~/error.log
sleep 9

# Move script file to done folder
mv ~/script4.sh ~/done
mv ~/next/script5.sh  ~/

echo " "
echo "You can now test installation, as below."
echo "Will shut down Ubuntu console, then open and execute:"
echo "    ./test.sh"
sleep 8
echo " "
wsl.exe --shutdown
