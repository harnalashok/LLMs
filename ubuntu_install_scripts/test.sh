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
#     model_install.sh
#     test.sh


echo " " | tee -a error.log
echo "*********"  | tee -a error.log
echo "Script: test.sh"  | tee -a error.log
echo "**********" | tee -a error.log
echo " " | tee -a error.log

# Check ollama models
echo "Ollama models are stored here"  | tee -a error.log
echo "-------------"  | tee -a error.log
ls -la  /usr/share/ollama/.ollama/models/blobs   | tee -a error.log
echo " "   | tee -a error.log
 

# Stop ollama, if already started
sudo systemctl stop ollama

# Test langflow
echo " "    | tee -a error.log
echo "Testing langflow"    | tee -a error.log
echo "---------"    | tee -a error.log
echo " "    | tee -a error.log
uv run langflow --version   2>> error.log

# 2.2 Test Flowise:
echo " "    | tee -a error.log
echo "Starting flowise. Acess it at port 3000"    | tee -a error.log
echo "------- "    | tee -a error.log
echo " "    | tee -a error.log
sleep 9
npx flowise start & > /dev/null &

# Test docker
echo " "    | tee -a error.log
echo "Installing image hello-world of docker"    | tee -a error.log
echo "------- "    | tee -a error.log
echo " "    | tee -a error.log
sleep 9
sudo docker run hello-world   2>> error.log

# Test llama.cpp
echo " "    | tee -a error.log
echo "Testing llama.cpp"    | tee -a error.log
echo "------- "    | tee -a error.log
echo " "    | tee -a error.log
sleep 9

# Move scripts
mv ~/test.sh  ~/done
mv ~/next/last.sh  ~/

echo " "     | tee -a error.log
echo "-------"     | tee -a error.log
echo "Sending a prompt to gemma-2-2b"     | tee -a error.log
echo "-------"     | tee -a error.log
echo " "     | tee -a error.log
cd ~/llama.cpp/models
llama-cli -m gemma-2-2b-it.Q6_K.gguf -p "I believe the meaning of life is" -n 128


echo " "
echo " "
