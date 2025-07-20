#!/bin/bash

# REf: https://github.com/mudler/LocalAI

 
echo "========script4=============="
echo "Install n8n with npm"
echo "Will install LocalAI docker"
echo "==========================="
sleep 10



#####################
## n8n install (with npm)
####################


# 2.1 Install n8n as NORMAL user
echo " "
echo "Installing n8n...Takes time..."                       | tee -a /home/$USER/error.log
echo "------"                                               | tee -a /home/$USER/error.log
echo " "                                                    | tee -a /home/$USER/error.log
sleep 2


npm install -g n8n                                          2>> /home/$USER/error.log
echo " "
echo " "                                                    | tee -a /home/$USER/error.log
echo "n8n installed"                                        | tee -a /home/$USER/error.log
echo " "                                                    | tee -a /home/$USER/error.log
echo "n8n installed"                                        | tee -a /home/$USER/info.log
echo "n8n port is: 5678"                                    | tee -a /home/$USER/info.log
echo " "                                                    | tee -a /home/$USER/info.log


echo '#!/bin/bash'                                         | tee    /home/$USER/start/start_npx_n8n.sh  
echo " "                                                   | tee -a /home/$USER/start/start_npx_n8n.sh
echo "cd ~/"                                               | tee -a /home/$USER/start/start_npx_n8n.sh
echo "echo 'n8n will be available at port 5678'"           | tee -a /home/$USER/start/start_npx_n8n.sh
echo "echo 'Use \"top -u ashok\" command to see memory usage'"           | tee -a /home/$USER/start/start_npx_n8n.sh
echo "sleep 5"           | tee -a /home/$USER/start/start_npx_n8n.sh
# To escape JavaScript Heap Space error:
# Refer: https://docs.n8n.io/hosting/scaling/memory-errors/#increase-old-memory
#        https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
echo " NODE_OPTIONS="--max-old-space-size=8000" npx n8n"       | tee -a /home/$USER/start/start_npx_n8n.sh
echo "netstat -aunt | grep 5678"                           | tee -a /home/$USER/start/start_npx_n8n.sh

chmod +x /home/$USER/start/*.sh


mv /home/$USER/script4.sh       /home/$USER/done/
mv /home/$USER/next/script5.sh  /home/$USER/


#####################
## LocalAI install
####################

mkdir /home/$USER/localai
cd /home/$USER/localai

# PReparing docker for GPU
# Ref StackOverflow: https://stackoverflow.com/a/77269071

# 1.0 Configure the repository (it is one command):
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey |sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
&& curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list \
&& sudo apt-get update

# 2.0 Install the NVIDIA Container Toolkit packages:

sudo apt-get install -y nvidia-container-toolkit

# 3.0  Configure the container runtime by using the nvidia-ctk command:

sudo nvidia-ctk runtime configure --runtime=docker

# 4.0 Restart the Docker daemon:

sudo systemctl restart docker


# Should run in detached mode
#  docker run -ti -d --name local-ai -p 8080:8080 localai/localai:latest-cpu

# Install localai using Nvidia GPU:
# https://github.com/mudler/LocalAI
docker run -ti --name local-ai -p 8080:8080 --gpus all localai/localai:latest-gpu-nvidia-cuda-12

#echo "Download localai model"
#echo "Process will run in background"
sleep 5

# Start local-ai in future
echo '#!/bin/bash'                                                                         > /home/$USER/start/start_localai.sh
echo " "                                                                                  >> /home/$USER/start/start_localai.sh
echo "cd /home/$USER/localai"                                                             >> /home/$USER/start/start_localai.sh
echo "echo 'Localai will be available at port 8080'"                                      >> /home/$USER/start/start_localai.sh
echo "docker start local-ai"                                                              >> /home/$USER/start/start_localai.sh
echo "netstat -aunt | grep 8080"                                                          >> /home/$USER/start/start_localai.sh
chmod +x /home/$USER/start/*.sh

# Stop local-ai in future
echo '#!/bin/bash'                                                                         > /home/$USER/stop/stop_localai.sh
echo " "                                                                                  >> /home/$USER/stop/stop_localai.sh
echo "cd /home/$USER/localai"                                                                >> /home/$USER/stop/stop_localai.sh
echo "docker stop local-ai"                                                              >> /home/$USER/stop/stop_localai.sh
chmod +x /home/$USER/stop/*.sh

# Download sh files to download models
wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/localai/download_bert_embeddings.sh   -P /home/$USER/localai
wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/localai/download_gemma3_4b_it.sh      -P /home/$USER/localai
#wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/localai/download_localaiModel3.sh    -P /home/$USER/localai
wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/localai/download_mistral_7b_instruct.sh    -P /home/$USER/localai
wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/localai/download_stablediffusion.sh   -P /home/$USER/localai
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/localai/download_gemma_3_27b_it.sh     -P /home/$USER/localai

wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/localai/get_download_status.sh        -P /home/$USER/localai
wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/localai/find_file.sh                  -P /home/$USER/localai
wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/localai/find_file.sh                  -P /home/$USER/localai
wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/localai/search_docker_data.sh         -P /home/$USER/
wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/localai/search_docker_data.sh         -P /home/$USER/localai

# MAke symbolic links
cd /home/$USER
ln -sT /home/$USER/start/start_localai.sh start_localai.sh
ln -sT /home/$USER/stop/stop_localai.sh stop_localai.sh
ln -sT /home/$USER/start/start_chroma.sh start_chroma.sh
ln -sT /home/$USER/start/start_npx_flowise.sh start_flowise.sh
ln -sT /home/$USER/start/start_debug_flowise.sh start_debug_flowise.sh

ln -sT /home/$USER/start/start_npx_n8n.sh start_n8n.sh
ln -sT /home/$USER/start/start_uv_langflow.sh start_langflow.sh
ln -sT /home/$USER/start/start_postgresql.sh start_postgresql.sh

ln -sT /home/$USER/stop/stop_chroma.sh stop_chroma.sh
ln -sT /home/$USER/stop/stop_localai.sh stop_localai.sh
ln -sT /home/$USER/stop/stop_postgresql.sh stop_postgresql.sh


# Download to files to create create images

wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/localai/generate_image.sh   -P /home/$USER/localai
wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/localai/generate_image2.sh  -P /home/$USER/localai

chmod +x /home/$USER/*.sh
chmod +x /home/$USER/localai/*.sh

cd ~/
echo "You may like to execute:"
echo "       ./script5.sh"
sleep 10
reboot

