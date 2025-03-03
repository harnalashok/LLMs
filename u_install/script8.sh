o #!/bin/bash


echo "========script8=============="
echo "Will install n8n docker"
echo "Will install LM Studio"
echo "Will install AnythingLLM"
echo "Will install open webui docker"
echo "You may execute script9.sh after this"
echo "You may call download_models.sh to download gguf models or from ollama library"
echo "==========================="
sleep 10

cd ~/

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

cd ~/
curl -fsSL https://cdn.useanything.com/latest/installer.sh | sh

cd ~/
# Script to start anythingLLM
echo '#!/bin/bash'                                                      > /home/ashok/start/start_anythingllm.sh
echo " "                                                                >> /home/ashok/start/start_anythingllm.sh
echo "cd ~/"                                                            >> /home/ashok/start/start_anythingllm.sh
echo "cd /home/ashok/AnythingLLMDesktop/anythingllm-desktop"           >> /home/ashok/start/start_anythingllm.sh
echo "./anythingllm-desktop start"                                     >>  /home/ashok/start/start_anythingllm.sh
chmod +x /home/ashok/start/*.sh


##########################
### Install OpenWebUI docker
# Ref: https://docs.openwebui.com/getting-started/quick-start
##########################

cd ~/
echo "Open webui will be available at"
echo "http://127.0.0.1:3000"
echo "Pulling images"
docker pull ghcr.io/open-webui/open-webui:main

echo "Running docker"
# Start docker--NonGPU support
docker run -d -p 3000:8080 -v open-webui:/app/backend/data --name open-webui ghcr.io/open-webui/open-webui:main
# Start docker GPU support
docker run -d -p 3000:8080 --gpus all -v open-webui:/app/backend/data --name open-webui ghcr.io/open-webui/open-webui:cuda

# Container name:  open-webui
echo" Next stime start/stop as: docker start/stop  open-webui "

## Script to start open-webui
echo '#!/bin/bash'                                       > /home/ashok/start/start_openwebui.sh
echo " "                                                 >> /home/ashok/start/start_openwebui.sh
echo "cd /home/ashok"                                    >> /home/ashok/start/start_openwebui.sh
echo "echo 'Access it as: http://127.0.0.1:3000'"             >> /home/ashok/start/start_openwebui.sh
echo "docker start open-webui"                           >> /home/ashok/start/start_openwebui.sh
chmod +x /home/ashok/start/*.sh

## Script to stop open-webui
echo '#!/bin/bash'                                       > /home/ashok/stop/stop_openwebui.sh
echo " "                                                 >> /home/ashok/stop/stop_openwebui.sh
echo "cd /home/ashok"                                    >> /home/ashok/stop/stop_openwebui.sh
echo "docker stop open-webui"                            >> /home/ashok/stop/stop_openwebui.sh
chmod +x /home/ashok/stop/*.sh



# Misc 
chmod +x /home/ashok/*.sh
chmod +x /home/ashok/start/*.sh
chmod +x /home/ashok/stop/*.sh

echo "You may like to execute:"
echo "       ./script9.sh"
sleep 10
kill $PPID






 
