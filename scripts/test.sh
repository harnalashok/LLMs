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

# Download ollama nomic-embed-text
# Start ollama in background
ollama serve &  > /dev/null &
echo " Pulling text-embedding model"
ollama pull nomic-embed-text
sleep 4
echo " Pulling olomo2 model"
ollama pull olmo2
sleep 5

# Test langfloe
uv run langflow --version

# 2.2 Test Flowise:
npx flowise start

# Test docker
sudo docker run hello-world

# Test llama.cpp
cd /home/ashok/llama.cpp/models
llama-cli -m gemma-2-2b-it.Q6_K.gguf -p "I believe the meaning of life is" -n 128

mv test.sh /home/ashok/done
