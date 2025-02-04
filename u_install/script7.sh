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


echo "========script7=============="
echo "Will install FAISS"
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

## Script to activate FAISS library
echo '#!/bin/bash'                                                      > /home/ashok/start/activate_faiss.sh
echo " "                                                                >> /home/ashok/start/activate_faiss.sh
echo "cd ~/"                                                            >> /home/ashok/start/activate_faiss.sh
echo "echo 'Activate FAISS library, as:'"                                >> /home/ashok/start/activate_faiss.sh                             
echo "echo 'source /home/ashok/start/activate_faiss.sh'"                 >> /home/ashok/start/activate_faiss.sh
echo "echo 'To deactivate issue just the command: deactivate'"           >> /home/ashok/start/activate_faiss.sh
echo "source /home/ashok/faiss/bin/activate"                             >> /home/ashok/start/activate_faiss.sh


##########################
### n8n
##########################
# Refer: https://github.com/n8n-io/n8n?tab=readme-ov-file#quick-start

cd ~/
docker volume create n8n_data
docker run -it --rm --name n8n -p 5678:5678 -v n8n_data:/home/ashok/node/.n8n docker.n8n.io/n8nio/n8n
# Access at localhost:5678

# n8n start script
echo '#!/bin/bash'                                                                                            > /home/ashok/start/start_n8n.sh
echo " "                                                                                                      >> /home/ashok/start/start_n8n.sh
echo "echo 'Access n8n at port 5678. Wait...starting...'"                                                                         >> /home/ashok/start/start_n8n.sh
echo "sleep 9"                                                                                                >> /home/ashok/start/start_n8n.sh
echo "cd ~/"                                                                                                  >> /home/ashok/start/start_n8n.sh
echo "docker run -it --rm --name n8n -p 5678:5678 -v n8n_data:/home/ashok/node/.n8n docker.n8n.io/n8nio/n8n"  >> /home/ashok/start/start_n8n.sh
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
echo "       ./script8.sh"
sleep 10
kill $PPID






 
