#!/bin/bash

# Last amended: 17th July, 2025



if [[ $USER != 'ashok' ]]; then
    echo "First change user name to 'ashok' or create a user 'ashok'. Run the script when user is 'ashok'"  
    sleep 9
    exit
fi


echo "========script=============="
echo "Will update Ubuntu"
echo "Will install flowise docker"
echo "Will install ollama docker for gpu"
echo "Will install chromadb docker"
echo "Will install n8n docker"

echo "==========================="
sleep 4


################
# Update Ubuntu
# Also install postgresql
################

cd /home/$USER
echo "Shall I update ubuntu? Answer 'n' if update already done [Y,n]"  
read input
input=${input:-Y}
if [[ $input == "Y" || $input == "y" ]]; then
    echo "  "
    echo "------------"                            
    echo " Will update Ubuntu"                     
    echo " You will be asked for password...supply it..."
    echo "----------"                              
    echo " "
    sleep 2
    sudo apt update
    sudo apt upgrade -y
    
    # To get multiple python versions, install repo
    # See: https://askubuntu.com/a/1538589
    sudo add-apt-repository ppa:deadsnakes/ppa -y
    sudo apt update 
    
    # pipx to install poetry
    sudo apt install zip unzip net-tools cmake  build-essential python3-pip tilde curl git  python3-dev python3-venv gcc g++ make jq  openssh-server libfuse2 pipx -y  
    sudo apt -y install python3-pip python3-dev python3-venv gcc g++ make jq 
    sudo apt-get install python3-tk -y
    sudo apt-get install libssl-dev libcurl4-openssl-dev -y
    
    echo " "
    echo "Ubuntu upgraded ......"               
    
    # Folders for start/stop scripts
    mkdir /home/$USER/start
    mkdir /home/$USER/stop
    echo " "
    echo " "
    echo "====NOTE====="
    echo "Reboot the machine. After reboot, execute following three scripts in sequence:"
    echo "And, after executing EACH script, reboot the machine"
    echo " "
    echo "1=>   ./ubuntu_docker1.sh "
    echo "2=>   ./ubuntu_docker2.sh "
    echo "3=>   ./ollama_flowise_chroma_n8n.sh"
    echo "=========="
    sleep 5
    #reboot
else
    echo "Ubuntu will not be updated"
fi


##########################
### Install chromadb docker
# Ref: https://docs.trychroma.com/production/containers/docker
#      https://cookbook.chromadb.dev/strategies/cors/
##########################

cd /home/$USER
echo "Shall I install chromadb docker? [Y,n]"    # Else docker chromadb may be installed
read input
input=${input:-Y}
if [[ $input == "Y" || $input == "y" ]]; then

    # Write chroma start script
    echo '#!/bin/bash'                                         | tee    /home/$USER/start/start_chroma.sh  
    echo " "                                                   | tee -a /home/$USER/start/start_chroma.sh  
    echo "cd ~/"                                               | tee -a /home/$USER/start/start_chroma.sh  
    echo "echo 'Chromadb will be available at port 8000'"      | tee -a /home/$USER/start/start_chroma.sh 
    echo "echo 'Data dir is ~/chroma_data/'"                   | tee -a /home/$USER/start/start_chroma.sh 
    echo "echo 'In flowise, access it as: http://127.0.0.1:8000'"                   | tee -a /home/$USER/start/start_chroma.sh 
    echo "docker run -e CHROMA_SERVER_CORS_ALLOW_ORIGINS='[\"http://localhost:3000\"]' -v /home/$USER/chroma_data:/chroma/chroma -p 8000:8000 chromadb/chroma:0.6.3 "   | tee -a /home/$USER/start/start_chroma.sh 

    # Pulling chromadb docker image  
    cd /home/$USER/
    echo " "                                       | tee -a /home/$USER/error.log
    echo " Pulling chromadb docker image"          | tee -a /home/$USER/error.log
    # Refer: https://cookbook.chromadb.dev/strategies/cors/
    docker run -e CHROMA_SERVER_CORS_ALLOW_ORIGINS='["http://localhost:3000"]' -v /home/$USER/chroma_data:/chroma/chroma -p 8000:8000 chromadb/chroma:0.6.3 
    echo "------------"                            | tee -a /home/$USER/error.log
    echo " "                                       | tee -a /home/$USER/error.log
    sleep 3
else
    echo "Skipping install of chromadb docker"
fi   

chmod +x /home/$USER/start/*.sh

##########################
### n8n docker
##########################

# Refer: https://github.com/n8n-io/n8n?tab=readme-ov-file#quick-start
# Workflow automation with n8n:
#                https://community.n8n.io/tags/c/tutorials/28/course-beginner

cd ~/
mkdir /home/$USER/n8n
cd /home/$USER/n8n
docker volume create n8n_data
docker run -it -d --rm --name n8n -p 5678:5678 -v n8n_data:/home/$USER/n8n/node/.n8n docker.n8n.io/n8nio/n8n
# Access at localhost:5678

# n8n start script for Ubuntu
echo '#!/bin/bash'                                                                                                        > /home/$USER/start/start_docker_n8n.sh
echo " "                                                                                                                  >> /home/$USER/start/start_docker_n8n.sh
echo "echo 'Access n8n at port 5678. Wait...starting...'"                                                                 >> /home/$USER/start/start_docker_n8n.sh
echo "echo 'To stop it, issue command: cd /home/$USER/n8n/ ; docker stop n8n'"                                             >> /home/$USER/start/start_docker_n8n.sh
echo "sleep 9"                                                                                                             >> /home/$USER/start/start_docker_n8n.sh
echo "cd /home/$USER/n8n"                                                                                                  >> /home/$USER/start/start_docker_n8n.sh
echo "docker run -d -it --rm --name n8n -p 5678:5678 -v /home/$USER/n8n_data:/home/$USER/n8n/node/.n8n docker.n8n.io/n8nio/n8n"        >> /home/$USER/start/start_docker_n8n.sh

# n8n start script for WSL
echo '#!/bin/bash'                                                                                                         > /home/$USER/start/start_wsl_n8n.sh
echo " "                                                                                                                   >> /home/$USER/start/start_wsl_n8n.sh
echo "echo 'Access n8n at port 5678. Wait...starting...'"                                                                  >> /home/$USER/start/start_wsl_n8n.sh
echo "echo 'To stop it, issue command: cd /home/$USER/n8n/ ; docker stop n8n'"                                             >> /home/$USER/start/start_wsl_n8n.sh
echo "sleep 9"                                                                                                             >> /home/$USER/start/start_wsl_n8n.sh
echo "cd /home/$USER/n8n"                                                                                                  >> /home/$USER/start/start_wsl_n8n.sh
# REf: https://community.n8n.io/t/communication-issue-between-n8n-and-ollama-on-ubuntu-installed-on-windows/48285/6
echo "docker run -d -it --rm --network host  --name n8n -p 5678:5678 -v /home/$USER/n8n_data:/home/$USER/n8n/node/.n8n docker.n8n.io/n8nio/n8n"  >> /home/$USER/start/start_wsl_n8n.sh


cd ~/
ln -sT /home/$USER/start/start_docker_n8n.sh start_docker_n8n.sh
ln -sT /home/$USER/start/start_wsl_n8n.sh    start_wsl_n8n.sh

chmod +x /home/$USER/start/*.sh

##########################
### ollama docker
##########################

echo "Shall I install ollama docker? [Y,n]"
read input
input=${input:-n}
if [[ $input == "Y" || $input == "y" ]]; then
      # Start ollama docker in future
      echo '#!/bin/bash'                                                                                        > /home/$USER/start/start_docker_ollama.sh
      echo " "                                                                                                  >> /home/$USER/start/start_docker_ollama.sh
      echo "echo '1. Run a model as: docker exec -it ollama ollama run <modelName>'"                            >> /home/$USER/start/start_docker_ollama.sh
      echo "echo '   and not as: ollama run <modelName>'"                                                       >> /home/$USER/start/start_docker_ollama.sh
      echo "echo '2. Start/stop ollama docker: docker start/stop ollama'"                                       >> /home/$USER/start/start_docker_ollama.sh
      echo "echo '3. Ollama is at port 11434'"                                                                  >> /home/$USER/start/start_docker_ollama.sh
      echo "echo '   Access as: http://host.docker.internal:11434'"                                             >> /home/$USER/start/start_docker_ollama.sh
      echo "echo '   Or, as: http://hostip:11434 (hostip maybe: 172.17.0.1 but NOT 127.0.0.1)'"                 >> /home/$USER/start/start_docker_ollama.sh
      echo "echo '4. Pull model from ollama library: ollama pull <modelName'"                                   >> /home/$USER/start/start_docker_ollama.sh
      echo "echo '5. Pulled models are available at /var/lib/docker/volumes/ollama/ '"                          >> /home/$USER/start/start_docker_ollama.sh
      chmod +x /home/$USER/start/*.sh

      # For model storage local folder ollama is mounted.
      echo "Local folder ollama for models is: /var/lib/docker/volumes/ollama/"
      echo "Will install ollama for GPU..."
      sleep 4
      docker run -d --gpus=all -v /home/$USER/ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
else
        echo "Skipping install of ollama docker"
fi

chmod +x /home/$USER/start/*.sh


#####################3
# flowise docker
######################


echo "Shall I install flowise docker? [Y,n]"    
read input
# Provide a default value of yes to 'input' 'https://stackoverflow.com/a/2642592
input=${input:-n}
if [[ $input == "Y" || $input == "y" ]]; then
   # Install Flowise through docker"
   # Ref: https://docs.flowiseai.com/getting-started
   echo "Installing flowise docker"                          | tee -a /home/$USER/info.log
   # Start script
   echo '#!/bin/bash'                                         >  /home/$USER/start/start_docker_flowise.sh
   echo " "                                                   >> /home/$USER/start/start_docker_flowise.sh
   echo "cd ~/"                                               >> /home/$USER/start/start_docker_flowise.sh
   echo "echo 'Flowise port 3000 onstarting'"                 >> /home/$USER/start/start_docker_flowise.sh
   echo "cd /home/$USER/Flowise"                              >> /home/$USER/start/start_docker_flowise.sh
   echo "docker start flowise"                                >> /home/$USER/start/start_docker_flowise.sh
   echo "netstat -aunt | grep 3000"                           >> /home/$USER/start/start_docker_flowise.sh

   # Stop script
   echo '#!/bin/bash'                                        >  /home/$USER/stop/stop_docker_flowise.sh
   echo " "                                                  >> /home/$USER/stop/stop_docker_flowise.sh
   echo "cd ~/"                                              >> /home/$USER/stop/stop_docker_flowise.sh
   echo "echo 'Flowise Stopping'"                            >> /home/$USER/stop/stop_docker_flowise.sh
   echo "cd /home/$USER/Flowise"                             >> /home/$USER/stop/stop_docker_flowise.sh
   echo "docker stop flowise"                                >> /home/$USER/stop/stop_docker_flowise.sh
   echo "netstat -aunt | grep 3000"                           >> /home/$USER/stop/stop_docker_flowise.sh
   sleep 4
   
   cd ~/
   git clone https://github.com/FlowiseAI/Flowise.git
   cd Flowise/
   sudo docker build --no-cache -t flowise .
   sudo docker run -d --name flowise -p 3000:3000 flowise
   echo "In future to start/stop containers, proceed, as:"
   echo "            cd /home/$USER/Flowise"                  
   echo "            docker start flowise"                    
   echo "            docker stop flowise"                     
   echo " Also, check all containers available, as:"
   echo "             docker ps -a "                          
 else
   echo "Flowise docker will not be installed"
 fi  

chmod +x /home/$USER/start/*.sh
chmod +x /home/$USER/stop/*.sh
