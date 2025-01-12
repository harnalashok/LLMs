

# These sscripts run in sequence.
#     script0.sh
#     script1.sh
#     script2.sh
#     script3.sh
#     script4.sh
#     docker_install.sh


# Test ollama and tinyllama
ollama run tinyllama
# Test langfloe
uv run langflow --version
# uv run langflow --help

# 2.2 Test Flowise:
npx flowise start

# Test docker
sudo docker run hello-world
