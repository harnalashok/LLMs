#/bin/bash

# Last amended: 14th Jan, 2025

# Test scripts

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
echo "Script: script5.sh"  | tee -a /home/ashok/error.log
echo "**********" | tee -a /home/ashok/error.log
echo " " | tee -a /home/ashok/error.log

#conda deactivate

# Check ollama models
echo "Ollama models are stored here"  | tee -a /home/ashok/info.log
echo "-------------"  | tee -a /home/ashok/info.log
ls -la  /usr/share/ollama/.ollama/models/blobs   | tee -a /home/ashok/info.log
echo " "   | tee -a /home/ashok/info.log
 

# Stop ollama, if already started
sudo systemctl stop ollama

# Test langflow
echo " "    | tee -a /home/ashok/error.log
echo "Testing langflow"    | tee -a /home/ashok/error.log
echo "---------"    | tee -a /home/ashok/error.log
echo " "    | tee -a /home/ashok/error.log
uv run langflow --version   2>> /home/ashok/error.log

# 2.2 Test Flowise:
echo " "    | tee -a /home/ashok/error.log
echo "Starting flowise. Acess it at port 3000"    | tee -a /home/ashok/error.log
echo "------- "    | tee -a /home/ashok/error.log
echo " "    | tee -a /home/ashok/error.log
sleep 9
echo "Start flowise as: npx flowise start "    | tee -a /home/ashok/error.log
npx flowise start & > /dev/null &

# Test docker
echo " "    | tee -a /home/ashok/error.log
echo "Installing image hello-world of docker"    | tee -a /home/ashok/error.log
echo "------- "    | tee -a /home/ashok/error.log
echo " "    | tee -a /home/ashok/error.log
sleep 9
sudo docker run hello-world   2>> /home/ashok/error.log

# Test llama.cpp
echo " "    | tee -a /home/ashok/error.log
echo "Testing llama.cpp"    | tee -a /home/ashok/error.log
echo "------- "    | tee -a /home/ashok/error.log
echo " "    | tee -a /home/ashok/error.log

# Move scripts
mv /home/ashok/script5.sh  /home/ashok/done
mv /home/ashok/next/script6.sh  /home/ashok/

echo " "     | tee -a /home/ashok/error.log
echo "-------"     | tee -a /home/ashok/error.log
echo "Sending a prompt to gemma-2-2b"     | tee -a /home/ashok/error.log
echo "Press ctrl+c to stop it any time."    | tee -a /home/ashok/error.log
echo "-------"     | tee -a /home/ashok/error.log
echo " "     | tee -a /home/ashok/error.log
echo " "     | tee -a /home/ashok/error.log
echo "Test llama.cpp, as"    | tee -a /home/ashok/info.log
echo "    llama-cli -m gemma-2-2b-it.Q6_K.gguf -p "I believe the meaning of life is" -n 128 "     | tee -a /home/ashok/info.log
echo "Press ctrl+c to kill the process..."
sleep 9
cd /home/ashok/llama.cpp/models
llama-cli -m gemma-2-2b-it.Q6_K.gguf -p "I believe the meaning of life is" -n 128
exec sleep 2


echo " "
echo " "
