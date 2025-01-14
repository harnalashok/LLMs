#/bin/bash

# Last amended: 14th Jan, 2025

# Test scripts

# These sscripts run in sequence.
#     script0.sh
#     script1.sh
#     script2.sh
#     script3.sh
#     script4.sh
#     docker_install.sh
#     test.sh

# Milvus install
# Ref: https://milvus.io/docs/install_standalone-docker.md

echo " " | tee -a error.log
echo "*********"  | tee -a error.log
echo "Script: test.sh"  | tee -a error.log
echo "**********" | tee -a error.log
echo " " | tee -a error.log


echo "Installing milvus vector database using docker"    | tee -a error.log
echo "You will be asked for the password. Supply it..."    | tee -a error.log
echo "It is assumed that docker engine is already installed."    | tee -a error.log
echo " "    | tee -a error.log
sleep 9

curl -sfL https://raw.githubusercontent.com/milvus-io/milvus/master/scripts/standalone_embed.sh -o standalone_embed.sh
bash standalone_embed.sh start  2>> error.log

echo " "
echo "Milvus installed"    | tee -a error.log
echo "To stop docker use the following commands:"
echo "      bash standalone_embed.sh stop
echo "To delete the database, use the following command:
echo "      bash standalone_embed.sh delete"
echo "--------------------"
sleep 9

# Download ollama nomic-embed-text
# Start ollama in background
echo " "    | tee -a error.log
echo "-----------"    | tee -a error.log
echo "Starting ollama in background"    | tee -a error.log
echo "---------"    | tee -a error.log
echo " "    | tee -a error.log
ollama serve &  > /dev/null &

echo " "
echo " Pulling text-embedding model"    | tee -a error.log
echo " "    | tee -a error.log
echo "--------- "    | tee -a error.log

ollama pull nomic-embed-text  2>> error.log
sleep 6
echo "Pulling olomo2 model"    | tee -a error.log
ollama pull olmo2  2>> error.log
sleep 5

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
mv test.sh /home/ashok/done

echo " "     | tee -a error.log
echo "-------"     | tee -a error.log
echo "Sending a prompt to gemma-2-2b"     | tee -a error.log
echo "-------"     | tee -a error.log
echo " "     | tee -a error.log
cd /home/ashok/llama.cpp/models
llama-cli -m gemma-2-2b-it.Q6_K.gguf -p "I believe the meaning of life is" -n 128


echo " "
echo " "
