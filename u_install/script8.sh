#!/bin/bash

  # These scripts run in sequence.
      #     script0.sh
      #     script1.sh
      #     script2.sh
      #     docker_install.sh
      #     script3.sh
      #     script4.sh
      #     script5.sh
      #     script6.sh
      #     script7.sh
      #     script8.sh
      #     script9.sh


echo "========script8=============="
echo "Will install FAISS"
echo "Will install redis-stack-server docker"
echo "Will install n8n docker"
echo "Will install LM Studio"
echo "Will install AnythingLLM"
echo "You may execute script.sh after this"
echo "You may call download_models.sh to download gguf models or from ollama library"
echo "==========================="
sleep 10

cd ~/

##########################
### Install FAISS library
##########################

# Create venv for FAISS
python3 -m venv /home/ashok/faiss
source /home/ashok/faiss/bin/activate
pip3 install faiss-cpu
deactivate
## Script to activate FAISS library
echo '#!/bin/bash'                                                      > /home/ashok/start/activate_faiss.sh
echo " "                                                                >> /home/ashok/start/activate_faiss.sh
echo "cd ~/"                                                            >> /home/ashok/start/activate_faiss.sh
echo "echo 'Activate FAISS library, as:'"                                >> /home/ashok/start/activate_faiss.sh                             
echo "echo 'source /home/ashok/start/activate_faiss.sh'"                 >> /home/ashok/start/activate_faiss.sh
echo "echo 'To deactivate issue just the command: deactivate'"           >> /home/ashok/start/activate_faiss.sh
echo "source /home/ashok/faiss/bin/activate"                             >> /home/ashok/start/activate_faiss.sh
deactivate


##########################
### redis-stack-server docker install
##########################
# Ref: https://redis.io/docs/latest/operate/oss_and_stack/install/install-stack/docker/

mkdir /home/ashok/redis
docker run -d --name redis-stack-server -p 6379:6379 redis/redis-stack-server:latest

# redis start script
echo '#!/bin/bash'                                                                                             > /home/ashok/start/start_redis.sh
echo " "                                                                                                       >> /home/ashok/start/start_redis.sh
echo "echo 'Access redis server port 6379. Wait...starting...'"                                                >> /home/ashok/start/start_redis.sh
echo "echo 'To stop it, issue command: cd /home/ashok/redis/ ; docker stop redis-stack-server'"                 >> /home/ashok/start/start_redis.sh
echo "echo 'To connect to redis cli, after start, issue command: docker exec -it  redis-stack-server redis-cli'"   >> /home/ashok/start/start_redis.sh
echo "sleep 9"                                                                                                  >> /home/ashok/start/start_redis.sh
echo "cd /home/ashok/redis"                                                                                      >> /home/ashok/start/start_redis.sh
echo " docker start redis-stack-server"                                                                          >> /home/ashok/start/start_redis.sh
echo "netstat -aunt | grep 6379"                                                                                 >> /home/ashok/start/start_redis.sh


# redis stop script
echo '#!/bin/bash'                                                                                              > /home/ashok/stop/stop_redis.sh
echo "echo 'Stopping redis server'"                                                                             >> /home/ashok/stop/stop_redis.sh
echo "cd /home/ashok/redis"                                                                                      >> /home/ashok/stop/stop_redis.sh
echo " docker stop redis-stack-server"                                                                           >> /home/ashok/stop/stop_redis.sh
echo "netstat -aunt | grep 6379"                                                                                 >> /home/ashok/stop/stop_redis.sh
chmod +x /home/ashok/start/*.sh
chmod +x /home/ashok/stop/*.sh


##########################
### n8n docker
##########################
# Refer: https://github.com/n8n-io/n8n?tab=readme-ov-file#quick-start
# Workflow automation with n8n:
#                https://community.n8n.io/tags/c/tutorials/28/course-beginner

cd ~/
mkdir /home/ashok/n8n
cd /home/ashok/n8n
docker volume create n8n_data
docker run -it -d --rm --name n8n -p 5678:5678 -v n8n_data:/home/ashok/n8n/node/.n8n docker.n8n.io/n8nio/n8n
# Access at localhost:5678

# n8n start script for Ubuntu
echo '#!/bin/bash'                                                                                                        > /home/ashok/start/start_docker_n8n.sh
echo " "                                                                                                                  >> /home/ashok/start/start_docker_n8n.sh
echo "echo 'Access n8n at port 5678. Wait...starting...'"                                                                 >> /home/ashok/start/start_docker_n8n.sh
echo "echo 'To stop it, issue command: cd /home/ashok/n8n/ ; docker stop n8n'"                                             >> /home/ashok/start/start_docker_n8n.sh
echo "sleep 9"                                                                                                             >> /home/ashok/start/start_docker_n8n.sh
echo "cd /home/ashok/n8n"                                                                                                  >> /home/ashok/start/start_docker_n8n.sh
echo "docker run -d -it --rm --name n8n -p 5678:5678 -v n8n_data:/home/ashok/n8n/node/.n8n docker.n8n.io/n8nio/n8n"        >> /home/ashok/start/start_docker_n8n.sh

# n8n start script for WSL
echo '#!/bin/bash'                                                                                                              > /home/ashok/start/start_wsl_n8n.sh
echo " "                                                                                                                        >> /home/ashok/start/start_wsl_n8n.sh
echo "echo 'Access n8n at port 5678. Wait...starting...'"                                                                       >> /home/ashok/start/start_wsl_n8n.sh
echo "echo 'To stop it, issue command: cd /home/ashok/n8n/ ; docker stop n8n'"                                                  >> /home/ashok/start/start_wsl_n8n.sh
echo "sleep 9"                                                                                                                  >> /home/ashok/start/start_wsl_n8n.sh
echo "cd /home/ashok/n8n"                                                                                                       >> /home/ashok/start/start_wsl_n8n.sh
# REf: https://community.n8n.io/t/communication-issue-between-n8n-and-ollama-on-ubuntu-installed-on-windows/48285/6
echo "docker run -d -it --rm --network host  --name n8n -p 5678:5678 -v n8n_data:/home/ashok/n8n/node/.n8n docker.n8n.io/n8nio/n8n"        >> /home/ashok/start/start_wsl_n8n.sh


cd ~/
ln -sT /home/ashok/start/start_docker_n8n.sh start_docker_n8n.sh
ln -sT /home/ashok/start/start_wsl_n8n.sh    start_wsl_n8n.sh

chmod +x /home/ashok/start/*.sh
##########################
### Install LMStudio
##########################

# Install LM Studio
# sudo apt install libnss3-dev libgdk-pixbuf2.0-dev libgtk-3-dev libxss-dev
# sudo apt-get install libasound2

mkdir lms
cd lms
# Download current lm studio. Check the download link
wget -c https://installers.lmstudio.ai/linux/x64/0.3.9-3/LM-Studio-0.3.9-3-x64.AppImage
chmod +x *.AppImage
cd ~/

## Script to start lmstudio
echo '#!/bin/bash'                                       > /home/ashok/start/start_lmstudio.sh
echo " "                                                 >> /home/ashok/start/start_lmstudio.sh
echo "cd /home/ashok/lms"                                >> /home/ashok/start/start_lmstudio.sh
echo "./LM-Studio-0.3.9-3-x64.AppImage"                  >> /home/ashok/start/start_lmstudio.sh
cp /home/ashok/start/start_lmstudio.sh  /home/ashok/lms/
chmod +x /home/ashok/lms/*.sh

## Script to develop a symlink for any gguf file in
#  in ~/llama.cpp/models folder (target is:  ~/.lmstudio/models)

echo '#!/bin/bash'                                       > /home/ashok/lms/symlink_gguf.sh
echo " "                                                 >> /home/ashok/lms/symlink_gguf.sh
echo "if [ "\$\#" -ne 2 ]"                               >> /home/ashok/lms/symlink_gguf.sh
echo "then"                                              >> /home/ashok/lms/symlink_gguf.sh
   echo "echo '  '"                                       >> /home/ashok/lms/symlink_gguf.sh
   echo "echo 'Incorrect number of arguments.'"           >> /home/ashok/lms/symlink_gguf.sh
   echo "echo '  '"                                       >> /home/ashok/lms/symlink_gguf.sh
   echo "echo 'Usage: ./symlink_gguf.sh YourModelName  ggufFileName'"  >> /home/ashok/lms/symlink_gguf.sh
   echo "echo 'Example:'"                                      >> /home/ashok/lms/symlink_gguf.sh
   echo "echo './symlink_gguf gemma gemma-2-2b-it.Q6_K.gguf'"  >> /home/ashok/lms/symlink_gguf.sh
   echo "echo '    (file gemma-2-2b-it.Q6_K.gguf must be in ~/llama.cpp/models folder)'"   >> /home/ashok/lms/symlink_gguf.sh
   echo "exit 1"                                         >> /home/ashok/lms/symlink_gguf.sh
echo "fi"                                                >> /home/ashok/lms/symlink_gguf.sh
echo "echo 'After starting LMStudio, change Models directory to:'"  >> /home/ashok/lms/symlink_gguf.sh
echo "echo '    /home/ashok/.lmstudio to list the gguf file'"       >> /home/ashok/lms/symlink_gguf.sh
echo "sleep 9"                                           >> /home/ashok/lms/symlink_gguf.sh
echo "mkdir ~/.lmstudio/models/\$1"                       >> /home/ashok/lms/symlink_gguf.sh
# ii) Move to your home folder
echo "cd ~/"                                             >> /home/ashok/lms/symlink_gguf.sh
# iii) Create a softlink of a gguf file in the current folder:
echo "ln -s ~/llama.cpp/models/\$2"                       >> /home/ashok/lms/symlink_gguf.sh
# iv) Move this symlink to flder created above:
echo "mv \$2 /home/ashok/.lmstudio/models/\$1"             >> /home/ashok/lms/symlink_gguf.sh
chmod +x /home/ashok/lms/*.sh
cp ~/lms/symlink_gguf.sh  ~/


mv /home/ashok/script8.sh       /home/ashok/done/
mv /home/ashok/next/script9.sh  /home/ashok/


##########################
### Install AnythingLLM
##########################
curl -fsSL https://cdn.useanything.com/latest/installer.sh | sh

# Script to start anythingLLM
echo '#!/bin/bash'                                                      > /home/ashok/start/start_anythingllm.sh
echo " "                                                                >> /home/ashok/start/start_anythingllm.sh
echo "cd ~/"                                                            >> /home/ashok/start/start_anythingllm.sh
echo "cd /home/ashok/AnythingLLMDesktop/anythingllm-desktop"           >> /home/ashok/start/start_anythingllm.sh
echo "./anythingllm-desktop start"                                     >>  /home/ashok/start/start_anythingllm.sh


# Misc 
chmod +x /home/ashok/*.sh
chmod +x /home/ashok/start/*.sh
chmod +x /home/ashok/stop/*.sh

echo "You may like to execute:"
echo "       ./script9.sh"
sleep 10
kill $PPID






 
