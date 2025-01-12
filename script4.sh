

# These sscripts run in sequence.
#     script0.sh
#     script1.sh
#     script2.sh
#     script3.sh
#     script4.sh
#     docker_install.sh

# Downloading a larger gguf model
echo "  "
echo "Will download one gguf model from huggingface"
echo "Will take lot of time....."
echo "-------------------"
echo " "
sleep 9
cd ~/llama.cpp/models
wget -c   https://huggingface.co/prithivMLmods/Llama-Thinker-3B-Preview-GGUF/resolve/main/llama-thinker-3b-preview-q8_0.gguf?download=true
# You may have to issue the following command to cleanup also.
mv 'llama-thinker-3b-preview-q8_0.gguf?download=true' llama-thinker-3b-preview-q8_0.

echo " "
echo "Done......"
echo "---------"
sleep 5


# Test ollama and tinyllama
ollama run tinyllama
# Test langfloe
uv run langflow --version
# uv run langflow --help

# 2.2 Test Flowise:
npx flowise start

# Test docker
sudo docker run hello-world
