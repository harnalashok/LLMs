#!/bin/bash
# Last amended: 03rd April, 2025

      
echo "========script7=============="
echo "Will install langchain"
echo "Will install LangGraph"
echo "Will install LangServe"
echo "Will install LangChain CLI"
echo "Will install LlamaIndex"
echo "Will install litellm"
echo "Will install Open WebUI--needs ollama behind the scenes"
echo "You may call script8.sh "
echo "==========================="
sleep 10

cd ~/

#################
# langchain & langraph
#################


# Create python environment at 'langchain'
#  for installing langchain and llama-index

python3 -m venv /home/ashok/langchain
source /home/ashok/langchain/bin/activate
pip install langchain
pip install langchain-openai
pip install langchain-community
pip install langchain-experimental
pip install langgraph
pip install "langserve[all]"
pip install langchain-cli

#################
# llamaindex
#################

# 1.0 LLamaindex install
# Mostly openai related
echo "Installing llama-index"
echo
pip install llama-index

# 1,1 Ollama, huggingface and localai (openailike) oriented
pip install --upgrade transformers
pip install llama-index-core llama-index-readers-file llama-index-llms-ollama llama-index-embeddings-ollama llama-index-embeddings-huggingface llama-index-llms-openai-like llama-index-vector-stores-faiss 
pip install llama-index-readers-file llama-index-embeddings-fastembed
# Needed inspite of code repeated above
pip install --upgrade transformers

# 1.2 Vector stores
pip install faiss-cpu
pip install qdrant-client llama-index-vector-stores-chroma 
pip install llama-index-vector-stores-qdrant fastembed

# 1.3 Web access site
pip install tavily-python

# 1.4 Yahoo finance data
pip install yfinance

# 1.5 For groq, together, mistralAI access
pip install llama-index-llms-groq
pip install llama-index-llms-together
pip install llama-index-llms-mistralai

# 1.6 Essentials/Misc
pip install spyder numpy scipy pandas matplotlib sympy cython
pip install jupyterlab
pip install ipython
pip install notebook
pip install streamlit
# Required for spyder:
sudo apt install pyqt5-dev-tools

# 1.7 Install litellm
#     Cal call 100+ LLMs in the OpenAI format
#     Refer: https://docs.litellm.ai/docs/#quick-start-proxy---cli
pip install 'litellm[proxy]'



# 1.7 Install visual studio code
# REf: https://code.visualstudio.com/docs/setup/linux#_debian-and-ubuntu-based-distributions
cd /home/ashok/Downloads
wget -c https://go.microsoft.com/fwlink/?LinkID=760868
# Fill in filename from above
sudo apt install ./<file>.deb  

sleep 5

# Deactivate the environment
deactivate

# Create script to activate 'langchain' env
echo "echo 'To activate langchain+llamaIndex virtual envs, activate as:' "  > /home/ashok/activate_langchain_venv.sh
echo "echo 'source /home/ashok/langchain/bin/activate' "                   >>  /home/ashok/activate_langchain_venv.sh
echo "echo '(Note the change in prompt after activating)' "                >>  /home/ashok/activate_langchain_venv.sh
echo "echo '(To deactivate, just enter the command: deactivate)' "         >>  /home/ashok/activate_langchain_venv.sh
echo "source /home/ashok/langchain/bin/activate"                           >>  /home/ashok/activate_langchain_venv.sh
chmod +x /home/ashok/*.sh
sleep 2

cp /home/ashok/activate_langchain_venv.sh  /home/ashok/start/activate_langchain_venv.sh
cp /home/ashok/activate_langchain_venv.sh  /home/ashok/stop/activate_langchain_venv.sh

# Move scripts
mv /home/ashok/script7.sh        /home/ashok/done/
mv /home/ashok/next/script8.sh   /home/ashok/

#################
# openwebui
#################

# Install openwebui using pip. Refer its github site
# Ref: https://github.com/open-webui/open-webui?tab=readme-ov-file#installation-via-python-pip-
# OpenWebUI utilizes Ollama to run GGUF models, so you'll need to be familiar 
#  with Ollama's functionality to fully manage your GGUF models

echo " "
echo "---------------"
echo "Will begin installing open-webui. Python version needed is exactly 3.11"
echo "Note: Open WebUI connects to Ollama to work with"
echo "Better install ollama if not already installed."
echo "---------------"
echo " "
sleep 9
# Check existing installed python versions on your machine
echo "Existing python versions on your machine are are as below"
echo " "

ls /usr/bin/ | grep python

read -p "Do you want to continue to install python3.11 ? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi
echo " "
echo "---------"
echo "Installing python3.11"
echo "Open Webui needs python3.11"
echo "----- "
sleep 4

# Install python 3.11 now
sudo apt update
sudo apt install python3.11 -y

# Install tool to create python venv
# invokable with its own Python executable

sudo apt install python3.11-venv  -y

# Check again python versions
echo "Installed python versions now are:"
echo " "
ls /usr/bin/ | grep python
sleep 9

# Create python virtual env at openwebui
echo "Creating python virtual env at openwebui"
# Using python3.11 package
python3.11 -m venv /home/ashok/openwebui

echo "Activating the new python env"
# Activate the python env
source /home/ashok/openwebui/bin/activate
sleep 2

echo "--------------"
echo "Installing openwebui....Takes lots of time...."
echo "If it breaks, try again....."
echo "--------------"
echo " "
sleep 9

# Installing openwebui. Takes time
pip3.11 install open-webui

echo " "
echo " "
echo "------------"
echo "Done. Starting openwebui........"
echo "During initial startup it imports many files"
echo "Access it at port 7860"
echo "You can kill it after starting with ctrl+c"
echo "------------"
echo " "
sleep 9

# Create script to start openwebui thenext time
# Activate the env
echo "source /home/ashok/openwebui/bin/activate" >  /home/ashok/start/start_openwebui.sh
echo "open-webui serve"                          >> /home/ashok/start/start_openwebui.sh

chmod +x /home/ashok/*.sh
chmod +x /home/ashok/start/*.sh
chmod +x /home/ashok/stop/*.sh


# Start open-webui once
open-webui serve

deactivate

echo "You may like to execute:"
echo "       ./script8.sh"
sleep 10
kill $PPID




