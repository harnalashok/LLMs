#!/bin/bash

# Last amended: 14th Jan, 2024

# These sscripts run in sequence.
#     script0.sh
#     script1.sh
#     script2.sh
#     script3.sh
#     script4.sh
#     docker_install.sh
#     test.sh

echo " " | tee -a error.log
echo "*********"  | tee -a error.log
echo "Script: script4.sh"  | tee -a error.log
echo "**********" | tee -a error.log
echo " " | tee -a error.log


# Downloading a larger gguf model
echo "  "    | tee -a error.log
echo "Will download one gguf model from huggingface"  | tee -a error.log
echo "Will take lot of time....."    | tee -a error.log
echo "-------------------"    | tee -a error.log
echo " "    | tee -a error.log
sleep 9
cd ~/llama.cpp/models
wget -c   https://huggingface.co/prithivMLmods/Llama-Thinker-3B-Preview-GGUF/resolve/main/llama-thinker-3b-preview-q8_0.gguf?download=true
# You may have to issue the following command to cleanup also.
mv 'llama-thinker-3b-preview-q8_0.gguf?download=true' llama-thinker-3b-preview-q8_0.

echo " "    | tee -a error.log
echo "thinker-3b-preview-q8_0.gguf downloaded"    | tee -a error.log
echo "---------"    | tee -a error.log
sleep 9

# Move script file to done folder
mv /home/ashok/script4.sh /home/ashok/done
mv /home/ashok/next/test.sh  /home/ashok

echo " "
echo "You can now test installation, as below."
echo "Will shut down Ubuntu console, then open and execute:"
echo "    ./test.sh"
sleep 8
echo " "
wsl.exe --shutdown



