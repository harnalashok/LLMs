


# Test ollama and tinyllama
ollama run tinyllama
# Test langfloe
uv run langflow --version
# uv run langflow --help

# 2.2 Test Flowise:
npx flowise start

# Test docker
sudo docker run hello-world

# Test llama.cpp
cd /home/ashok/llama.cpp/models
llama-cli -m gemma-2-2b-it.Q6_K.gguf -p "I believe the meaning of life is" -n 128
