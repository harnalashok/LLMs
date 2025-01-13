#/bin/bash

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

echo "Installing milvus vector database"
echo " "
sleep 9
curl -sfL https://raw.githubusercontent.com/milvus-io/milvus/master/scripts/standalone_embed.sh -o standalone_embed.sh
bash standalone_embed.sh start
echo " "
echo "Milvus installed"
echo " "
sleep 9

# Download ollama nomic-embed-text
# Start ollama in background
echo " "
echo "-----------"
echo "Starting ollama in background"
echo "---------"
echo " "
ollama serve &  > /dev/null &
echo " "
echo " Pulling text-embedding model"
echo " "
ollama pull nomic-embed-text
sleep 6
echo " Pulling olomo2 model"
ollama pull olmo2
sleep 5

# Test langflow
echo " "
echo "Testing langflow"
echo "---------"
echo " "
uv run langflow --version

# 2.2 Test Flowise:
echo " "
echo "Starting flowise. Acess it at port 3000"
echo "------- "
echo " "
sleep 9
npx flowise start & > /dev/null &

# Test docker
echo " "
echo "Installing image hello-world of docker"
echo "------- "
echo " "
sleep 9
sudo docker run hello-world

# Test llama.cpp
echo " "
echo "Testing llama.cpp"
echo "------- "
echo " "
sleep 9
cd /home/ashok/llama.cpp/models
llama-cli -m gemma-2-2b-it.Q6_K.gguf -p "I believe the meaning of life is" -n 128

mv test.sh /home/ashok/done
