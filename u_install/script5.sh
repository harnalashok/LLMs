#!/bin/bash

## Downloading many models

# 1.0
# Downloading smaller gguf model
echo "  "                                                 | tee -a /home/ashok/error.log
echo "Will download gemma-2 gguf model from huggingface"  | tee -a /home/ashok/error.log
echo "Will take lot of time....."                         | tee -a /home/ashok/error.log
echo "-------------------"                                | tee -a /home/ashok/error.log
echo " "                                                  | tee -a /home/ashok/error.log
sleep 9
cd /home/ashok/llama.cpp/models
wget -c   https://huggingface.co/MaziyarPanahi/gemma-2-2b-it-GGUF/resolve/main/gemma-2-2b-it.Q6_K.gguf? 2>> /home/ashok/error.log
# You may have to issue the following command to cleanup also.
mv 'gemma-2-2b-it.Q6_K.gguf?' gemma-2-2b-it.Q6_K.gguf
echo "12. gemm-1-2b installed"                            | tee -a /home/ashok/info.log
sleep 2


# 2.0
echo " "                                                  | tee -a /home/ashok/error.log
echo "Downloading tinyllama gguf model from huggingface"  | tee -a error.log
echo "Will take some time....."                           | tee -a /home/ashok/error.log
echo "File size is 780mb"                                 | tee -a /home/ashok/error.log
echo "-------------------"                                | tee -a /home/ashok/error.log
echo " "                                                  | tee -a /home/ashok/error.log
wget -c   https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/blob/main/tinyllama-1.1b-chat-v1.0.Q5_0.gguf 2>> /home/ashok/error.log  
sleep 2

# 3.0
echo " "                                                           | tee -a /home/ashok/error.log
echo "gemma-2-2b-it.Q6_K.gguf and tinyllama downloaded"            | tee -a /home/ashok/error.log
echo "13. gemma-2-2b-it.Q6_K.gguf and tinyllama downloaded"        | tee -a /home/ashok/info.log
echo "       Download folder is:  /home/ashok/llama.cpp/models"    | tee -a /home/ashok/info.log
echo "       Check as: ls -la /home/ashok/llama.cpp/models/"       | tee -a /home/ashok/error.log
echo "---------"                                                   | tee -a /home/ashok/error.log



# 4.0 
#  Download tinyllama
echo " "                                  | tee -a /home/ashok/error.log
echo "--------- "                         | tee -a /home/ashok/error.log
echo "Downloading tinyllama for ollama"   | tee -a /home/ashok/error.log
echo "Download size is 637MB"
echo "------"                             | tee -a /home/ashok/error.log
echo " "                                  | tee -a /home/ashok/error.log
ollama pull tinyllama                     2>> /home/ashok/error.log
sleep 2

echo "  "                       | tee -a /home/ashok/error.log
echo "  "                       | tee -a /home/ashok/error.log
echo "tinyllama downloaded"     | tee -a /home/ashok/error.log
echo "tinyllama downloaded"     | tee -a /home/ashok/info.log

echo "Check as: ollama list"    | tee -a /home/ashok/info.log
echo "-------"                  | tee -a /home/ashok/info.log



# 5.0
#  Downloading a larger gguf model
echo "  "    | tee -a /home/ashok/error.log
echo "Will download a large gguf model from huggingface"  | tee -a /home/ashok/error.log
echo "Will take lot of time....."                         | tee -a /home/ashok/error.log
echo "If broken, this download can be resumed as: "       | tee -a /home/ashok/error.log
echo "wget -c   https://huggingface.co/prithivMLmods/Llama-Thinker-3B-Preview-GGUF/resolve/main/llama-thinker-3b-preview-q8_0.gguf?download=true "  | tee -a /home/ashok/error.log        
echo "-------------------"                                | tee -a /home/ashok/error.log
echo " "                                                  | tee -a /home/ashok/error.log
sleep 2
cd /home/ashok/llama.cpp/models
wget -c   https://huggingface.co/prithivMLmods/Llama-Thinker-3B-Preview-GGUF/resolve/main/llama-thinker-3b-preview-q8_0.gguf?download=true
sleep 2

# You may have to issue the following command to cleanup also.
mv 'llama-thinker-3b-preview-q8_0.gguf?download=true' llama-thinker-3b-preview-q8_0.gguf

echo " "                                                | tee -a /home/ashok/error.log
echo "thinker-3b-preview-q8_0.gguf downloaded"          | tee -a /home/ashok/error.log
echo "thinker-3b-preview-q8_0.gguf downloaded"          | tee -a /home/ashok/info.log
echo "Check as: ls -la /home/ashok/llama.cpp/models/ "  | tee -a /home/ashok/info.log
echo "---------"                                        | tee -a /home/ashok/info.log
sleep 3

# 7.0
# Downloading thellama-2-13b-chat.Q4_K_M.gguf format model.
# It's possible to download models from the following sitew.
# In this example, we will use [llama-2-13b-chat.Q4_K_M.gguf]. 
#  ⇒ https://huggingface.co/TheBloke/Llama-2-7B-chat-GGUF/tree/main
#  ⇒ https://huggingface.co/TheBloke/Llama-2-13B-chat-GGUF/tree/main
#  ⇒ https://huggingface.co/TheBloke/Llama-2-70B-Chat-GGUF/tree/main 

echo " "  | tee -a /home/ashok/error.log
echo "Downloading Llama-2-13B-chat-GGUF" | tee -a /home/ashok/error.log
echo "Downloading size: 7.8GB" | tee -a /home/ashok/error.log
echo "to folder /home/ashok/llama.cpp/models/"  | tee -a /home/ashok/error.log
echo  "*********"  | tee -a /home/ashok/error.log
cd  /home/ashok/llama.cpp/models/
wget https://huggingface.co/TheBloke/Llama-2-13B-chat-GGUF/resolve/main/llama-2-13b-chat.Q4_K_M.gguf 
sleep 2
echo " "  | tee -a /home/ashok/error.log
echo "Downloaded Llama-2-13B-chat-GGUF" | tee -a /home/ashok/error.log
echo "Downloaded Llama-2-13B-chat-GGUF" | tee -a /home/ashok/info.log
echo "Downloaded size: 7.8GB" | tee -a /home/ashok/info.log
echo "Folder is /home/ashok/llama.cpp/models/"  | tee -a /home/ashok/info.log
sleep 2


# Move script file to done folder
mv /home/ashok/script5.sh /home/ashok/done
mv /home/ashok/next/script6.sh  /home/ashok/
sleep 5
bash script6.sh
