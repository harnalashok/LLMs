#!/bin/bash

# Last amended: 15th Jan, 2026

clear
echo "  "
echo "=====***======"
echo "WSL ubuntu window will close many times during installation"
echo "Each time, double click to open it, and each time "
echo "issue the command:"
echo "            ./ollama_wsl_nogpu.sh"
echo "   Answer Y to most questions"
echo "      till, all software is installed."
echo "================"
echo "   "
echo "   "
echo "    "
echo -en "\007"

cd /home/$USER
if [ ! -f /home/$USER/first_time.txt ]; then
    sleep 15
    echo "  "
    echo "------------"                            
	echo "========script=============="
	echo "Will update Ubuntu and install nodejs"
	echo "Will install docker"
	echo "Will install flowise docker"
	echo "Will install ollama docker without gpu"
	echo "Will install chromadb docker"
	echo "Will install n8n docker"
	echo "Installs postgres db and pgvector"
	echo "Install latest anaconda"
	echo "Will install Ragflow docker"
	echo "==========================="
	sleep 5
	echo "first_time.txt" > /home/$USER/first_time.txt
else 
    sleep 5
fi	

################
# Update Ubuntu
# Also install postgresql
################

cd /home/$USER
if [ ! -f /home/$USER/ubuntu_updated.txt ]; then
    echo "  "
    echo "------------"                            
    echo " Will update Ubuntu. Takes time..."                     
    echo " When asked for password...supply it..."
    echo "----------"                              
    echo " "
    sleep 2
	echo -en "\007"
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
    echo "Ubuntu is updated" > /home/$USER/ubuntu_updated.txt   # To avoid repeat updation
    # Download docker installation scripts
    wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/ubuntu_docker1.sh -P /home/$USER
    wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/ubuntu_docker2.sh -P /home/$USER
    perl -pi -e 's/\r\n/\n/g' /home/$USER/ubuntu_docker1.sh
    perl -pi -e 's/\r\n/\n/g' /home/$USER/ubuntu_docker2.sh
    chmod +x /home/$USER/*.sh
    echo " "
    echo "Ubuntu upgraded ......"  
    echo "  "
	echo "  "
	echo "===="
	echo "Installing nodejs ver 22.x"
	echo "===="
	echo "  "
	sleep 4
	# First, update your package list
    sudo apt update
    # Install curl if you don't have it
    sudo apt install curl -y
    # Download and run the setup script for the desired Node.js version (e.g., Node.js 22.x LTS)
    # Replace '22.x' with the desired major version if needed
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    # Now install Node.js and npm
    sudo apt install nodejs -y
	echo "NodeJS installed"
	echo " "
	sleep 3
	# Install uv
	curl -LsSf https://astral.sh/uv/install.sh | sh
    # Script to stop all dockers
    echo '#!/bin/bash'                                         | tee    /home/$USER/stop_alldockers.sh
    echo "echo 'Will stop all dockers:'"                       | tee -a /home/$USER/stop_alldockers.sh
    echo " "                                                   | tee -a /home/$USER/stop_alldockers.sh
    echo "cd /home/$USER/"                                     | tee -a /home/$USER/stop_alldockers.sh
    echo "docker stop \$(docker ps -q)"                         | tee -a /home/$USER/stop_alldockers.sh
    echo "docker ps"                                           | tee -a /home/$USER/stop_alldockers.sh
    chmod +x *.sh   
    # Folders for start/stop scripts
    mkdir /home/$USER/start
    mkdir /home/$USER/stop
    echo " "
    echo " "
    if [[ ! -n "$WSLSYSTEM" ]] ; then
        # WSL installed
        echo "====NOTE====="
        echo "Ubuntu shell will be closed several times. After each closure, reopen it and execute again the following script:"
        echo " "
        echo "=>   ./ollama_wsl.sh"
        echo "=========="
        sleep 15
        wsl.exe --shutdown
    else
        echo "====NOTE====="
        echo "Machine will be rebooted several times. After each reboot, execute the following script:"
        echo " "
        echo "=>   ./ollama_wsl.sh"
        echo "=========="
        sleep 15
        wsl.exe --shutdown
    fi
    wsl.exe --shutdown
fi

##################
# Docker installation-I
#################

cd /home/$USER
if [ ! -f /home/$USER/docker_installed.txt ]; then
    # Ref: https://docs.docker.com/engine/install/ubuntu/
    #      https://docs.docker.com/engine/install/linux-postinstall/
    # Add Docker's official GPG key:
    echo "Installing docker.."
    sleep 2
	echo -en "\007"
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    # Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin  -y
    echo "Docker is installed" > /home/$USER/docker_installed.txt   # To avoid repeat installation
    echo "WSL-Ubuntu will be closed"
    echo "Open the shell and execute:    ./ollama_wsl_nogpu.sh:"
    sleep 9
    if [[ ! -n "$WSLSYSTEM" ]] ; then
        wsl.exe --shutdown
    else
        wsl.exe --shutdown
    fi  
else
   echo "Docker is installed"
fi  

mkdir /home/$USER/docker
cd /home/$USER/docker
echo "Download script to print names of docker containers"
wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/docker/names_dockers.sh
chmod +x *.sh
cd /home/$USER

##################
# Docker installation-II
#################

cd /home/$USER
if [ ! -f /home/$USER/docker_installed_1.txt ]; then
    # Ref: https://docs.docker.com/engine/install/ubuntu/
    #      https://docs.docker.com/engine/install/linux-postinstall/
    echo "Testing if docker is properly installed"
    echo "AND running docker without root privilegs.."
    sleep 2
    # Check if docker installed
	echo -en "\007"
    sudo docker run hello-world
    # Run docker witout root privileges
    sudo groupadd docker
    sudo usermod -aG docker $USER
    #
    sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
    sudo chmod g+rwx "$HOME/.docker" -R
    #
    sudo systemctl disable docker.service
    sudo systemctl disable containerd.service
    # 4.0 Restart the Docker daemon:
    sudo systemctl restart docker
    #
    # Store docker help files
    mkdir /home/$USER/Documents/dockers
    cd /home/$USER/Documents/dockers
    wget -Nc https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/docker/Understanding%20docker%20technology.pdf?raw=true
    wget -Nc https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/docker/docker%20commands.txt?raw=true
    wget -Nc https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/docker/dockers%20in%20brief.pdf?raw=true
    cd /home/$USER/
    #
    echo "Docker installation completed" > /home/$USER/docker_installed_1.txt   # To avoid repeat installation
    echo "Machine will be rebooted "
   if [[ ! -n "$WSLSYSTEM" ]] ; then
        wsl.exe --shutdown
    else
        wsl.exe --shutdown
    fi  
else
    echo "Docker installation process completed"
fi    

# Prevent any docker restarts on OS reboot
docker update --restart=no $(docker ps -a -q)

##############
# Create python virtual env
# source /home/$USER/venv/bin/activate
##############

if [ ! -f /home/$USER/venv_installed.txt ]; then
    cd /home/$USER
    echo " "
    echo " "
    echo "------------"        
    echo "Shall I create python virtual env by name of venv? [Y,n]"    
    read input
    input=${input:-Y}
    if [[ $input == "Y" || $input == "y" ]]; then
        # Clear earlier directory, if it exists
        python3 -m venv --clear /home/$USER/venv
        source /home/$USER/venv/bin/activate
        # 1.6 Essentials software
        pip install spyder numpy scipy pandas matplotlib sympy cython
        pip install jupyterlab
        pip install ipython
        pip install notebook
        pip install streamlit
        echo "venv_installed.txt" > /home/$USER/venv_installed.txt
        # Required for spyder:
		echo " "
		echo " "
		echo -en "\007"
        sudo apt install pyqt5-dev-tools -y
        # Download file that creates a fresh python enviroemnet
        wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/quick_flowise_ollama/venv/create_python_venv.sh -P /home/$USER
		chmod +x *.sh   
        # Huggingface and  related
        #pip install huggingface_hub
        # cu124: is as per cuda version. Get cuda version from nvidia-smi
        #pip install transformers torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124
        #pip install huggingface_hub
        # Create script to activate 'venv' env
        echo '#!/bin/bash'                                                        | tee   /home/$USER/activate_venv.sh
        echo "echo 'Execute this file as: source activate_venv.sh' "              | tee -a  /home/$USER/activate_venv.sh
        echo "echo 'To use or install any python package, first activate python venv as:' "        | tee -a  /home/$USER/activate_venv.sh
        echo "echo 'source /home/$USER/venv/bin/activate' "                       | tee -a  /home/$USER/activate_venv.sh
        echo "echo '(Note the change in prompt after activating)' "                | tee -a  /home/$USER/activate_venv.sh
        echo "echo '(To deactivate, just enter the command: deactivate)' "         | tee -a  /home/$USER/activate_venv.sh
        echo "source /home/$USER/venv/bin/activate"                                | tee -a  /home/$USER/activate_venv.sh
        chmod +x /home/$USER/*.sh
        sleep 2
      
        cp /home/$USER/activate_venv.sh  /home/$USER/start/activate_venv.sh
        cp /home/$USER/activate_venv.sh  /home/$USER/stop/activate_venv.sh
		wsl.exe --shutdown
     else
        echo "Python venv not installed"
     fi   
fi   


##########################
### Install chromadb docker
# Ref: https://docs.trychroma.com/production/containers/docker
#      https://cookbook.chromadb.dev/strategies/cors/
##########################

cd /home/$USER
if [ ! -f /home/$USER/chromadb_installed.txt ]; then
	echo " "
	echo " "
	echo "------------"  
	echo "Shall I install chromadb docker? [Y,n]"    # Else docker chromadb may be installed
	read input
	input=${input:-Y}
	if [[ $input == "Y" || $input == "y" ]]; then
	    # Write chroma start script
	    echo '#!/bin/bash'                                         | tee    /home/$USER/start_chroma.sh  
	    echo " "                                                   | tee -a /home/$USER/start_chroma.sh  
	    echo "cd ~/"                                               | tee -a /home/$USER/start_chroma.sh  
	    echo "echo 'Chromadb will be available at port 8000'"      | tee -a /home/$USER/start_chroma.sh 
	    echo "echo 'Data dir is ~/chroma_data/'"                   | tee -a /home/$USER/start_chroma.sh 
	    echo "echo 'In flowise, access it as: http://hostip:8000'"                   | tee -a /home/$USER/start_chroma.sh 
	    echo " docker run -d --rm --network host -e CHROMA_SERVER_CORS_ALLOW_ORIGINS='["http://localhost:3000"]' -v /home/$USER/chroma_data:/chroma/chroma -p 8000:8000 --name chroma  chromadb/chroma:1.0.20 "   | tee -a /home/$USER/start_chroma.sh 
	
	    # Pulling chromadb docker image  
	    cd /home/$USER/
	    echo " "                                       | tee -a /home/$USER/error.log
	    echo " Pulling chromadb docker image"          | tee -a /home/$USER/error.log
	    # Refer: https://cookbook.chromadb.dev/strategies/cors/
	    docker run -d --rm --network host -e CHROMA_SERVER_CORS_ALLOW_ORIGINS='["http://localhost:3000"]' -v /home/$USER/chroma_data:/chroma/chroma -p 8000:8000 --name chroma  chromadb/chroma:1.0.20 
	    echo "------------"                            | tee -a /home/$USER/error.log
	    echo " "                                       | tee -a /home/$USER/error.log
		echo "chromadb_installed.txt"  > /home/$USER/chromadb_installed.txt
	    sleep 3
		wsl.exe --shutdown
	else
	    echo "Skipping install of chromadb docker"
	fi   
fi
chmod +x /home/$USER/*.sh


##########################
### n8n docker
##########################

# Refer: https://github.com/n8n-io/n8n?tab=readme-ov-file#quick-start
# Workflow automation with n8n:
#                https://community.n8n.io/tags/c/tutorials/28/course-beginner


cd /home/$USER
echo " "
echo " "
if [ ! -f /home/$USER/n8n_installed.txt ]; then
	echo "------------"   
	echo "------------"   
	echo "Shall I install n8n docker? [Y,n]"    
	read input
	input=${input:-Y}
	if [[ $input == "Y" || $input == "y" ]]; then
	    cd ~/
	    mkdir /home/$USER/n8n  # Redundant step
	    #cd /home/$USER/n8n
	    # Volumes are automatically created below: /var/lib/docker/volumes/
	    docker volume create n8n_data
	    #   https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
	    #   https://docs.n8n.io/hosting/scaling/memory-errors/#increase-old-memory
	    # Access at localhost:5678
	    # --rm implies remove docker when stopped. So docker will not show up in 'docker ps -a' call
	    # docker run -it -d --rm  --network host   --name n8n -p 5678:5678 -e NODE_OPTIONS="--max-old-space-size=4096" --network host  -v n8n_data:/home/$USER/n8n/node/.n8n docker.n8n.io/n8nio/n8n
	    # Access at localhost:5678
	    docker run -it -d --rm \
	                --name n8n \
	                 -p 5678:5678 \
	                 -e NODE_OPTIONS="--max-old-space-size=4096" \
	                --network host   \
	                 -v n8n_data:/home/node/.n8n \
	                    docker.n8n.io/n8nio/n8n
	    # n8n start script for Ubuntu
	    echo '#!/bin/bash'                                                                                                        > /home/$USER/start_n8n.sh
	    echo " "                                                                                                                  >> /home/$USER/start_n8n.sh
	    echo "echo 'Access n8n at port 5678. Wait...starting...'"                                                                 >> /home/$USER/start_n8n.sh
	    echo "echo 'To stop it, issue command:  docker stop n8n'"                                                                 >> /home/$USER/start_n8n.sh
	    echo "echo 'Use \"top -u $USER\" OR \"free -g \" command to see memory usage'"                                             >>  /home/$USER/start_n8n.sh
	    echo "sleep 9"                                                                                                             >> /home/$USER/start_n8n.sh
	    #echo "cd /home/$USER/n8n"                                                                                                  >> /home/$USER/start_n8n.sh
	    #echo "docker run -d -it --rm  --network host  --name n8n -p 5678:5678  -e NODE_OPTIONS=\"--max-old-space-size=4096\"  -v /home/$USER/n8n_data:/home/$USER/n8n/node/.n8n docker.n8n.io/n8nio/n8n"   >> /home/$USER/start_n8n.sh
	    echo "docker run -it -d --rm --name n8n -p 5678:5678 -e NODE_OPTIONS=\"--max-old-space-size=4096\" --network host -v n8n_data:/home/node/.n8n docker.n8n.io/n8nio/n8n"   >> /home/$USER/start_n8n.sh
	    # n8n start script for WSL
	    echo '#!/bin/bash'                                                                                                         > /home/$USER/start_wsl_n8n.sh
	    echo " "                                                                                                                   >> /home/$USER/start_wsl_n8n.sh
	    echo "echo 'Access n8n at port 5678. Wait...starting...'"                                                                 >> /home/$USER/start_wsl_n8n.sh
	    #echo "echo 'To stop it, issue command: cd /home/$USER/n8n/ ; docker stop n8n'"                                             >> /home/$USER/start_wsl_n8n.sh
	    echo "sleep 9"                                                                                                             >> /home/$USER/start_wsl_n8n.sh
	    #echo "cd /home/$USER/n8n"                                                                                                  >> /home/$USER/start_wsl_n8n.sh
	    # REf: https://community.n8n.io/t/communication-issue-between-n8n-and-ollama-on-ubuntu-installed-on-windows/48285/6
	    #echo "docker run -d -it --rm --network host --name n8n -p 5678:5678  -e NODE_OPTIONS=\"--max-old-space-size=4096\" -v /home/$USER/n8n_data:/home/$USER/n8n/node/.n8n docker.n8n.io/n8nio/n8n"  >> /home/$USER/start_wsl_n8n.sh
	    echo "docker run -it -d --rm --name n8n -p 5678:5678 -e NODE_OPTIONS=\"--max-old-space-size=4096\" --network host -v n8n_data:/home/node/.n8n docker.n8n.io/n8nio/n8n"   >> /home/$USER/start_wsl_n8n.sh
	    cd ~/
	    #ln -sT /home/$USER/start_n8n.sh start_n8n.sh
	    #ln -sT /home/$USER/start_wsl_n8n.sh    start_wsl_n8n.sh
		echo "n8n_installed.txt "  > /home/$USER/n8n_installed.txt
		sleep 3
		wsl.exe --shutdown
	else
	    echo "n8n docker will not be installed"
	fi
fi	

chmod +x /home/$USER/*.sh

##########################
### ollama docker for CPU
##########################

echo " "
echo " "
cd /home/$USER
if [ ! -f /home/$USER/ollama_installed.txt ]; then
	echo "------------"   
	echo "------------"   
	echo "Shall I install ollama docker? [Y,n]"
	read input
	input=${input:-Y}
	if [[ $input == "Y" || $input == "y" ]]; then
	      cd /home/$USER/
	      # Start ollama docker in future
	      echo '#!/bin/bash'                                                                                        > /home/$USER/start_ollama.sh
		  echo " "                                                                                                  >> /home/$USER/start_ollama.sh
		  echo "echo '==========Help: HowTo=============='"                                                         >> /home/$USER/start_ollama.sh
		  echo "echo '1. Stop ollama docker, as: docker stop ollama'"                                               >> /home/$USER/start_ollama.sh
		  echo "echo '2. Ollama is at port 11434'"                                                                  >> /home/$USER/start_ollama.sh
		  echo "echo '3. Pull model from ollama library: ollama pull <modelName'"                                   >> /home/$USER/start_ollama.sh
		  echo "echo '4. Run ollama model as: ollama run <modelName'"                                               >> /home/$USER/start_ollama.sh
		  echo "echo '5. Alias for command=> docker exec -it ollama => has a name: ollama'"                         >> /home/$USER/start_ollama.sh
		  echo " "                                                                                                  >> /home/$USER/start_ollama.sh
		  echo "echo '========'"                                                                                     >> /home/$USER/start_ollama.sh
		  echo "echo '6. Access ollama, as:'"                                                                       >> /home/$USER/start_ollama.sh
		  echo "echo '       http://host.docker.internal:11434'"                                                    >> /home/$USER/start_ollama.sh
		  echo "echo '   Or as:'"                                                                                   >> /home/$USER/start_ollama.sh
		  echo "echo '       http://hostip:11434 '"                                                                 >> /home/$USER/start_ollama.sh
		  echo "echo '    Get your IP (in either WSL or in ubuntu) as the Ist address of:'"                         >> /home/$USER/start_ollama.sh
		  echo "echo '         hostnae -I'"                                                                         >> /home/$USER/start_ollama.sh
		  echo "echo '========'"                                                                                    >> /home/$USER/start_ollama.sh
		  echo " "                                                                                                  >> /home/$USER/start_ollama.sh
		  echo "echo '7. Pulled models are available at /var/lib/docker/volumes/ollama/ '"                          >> /home/$USER/start_ollama.sh
		  echo "echo '8. Remember ollama is now an alias NOT the actual command '"                                  >> /home/$USER/start_ollama.sh
		  echo "echo '  '"                                                                                                  >> /home/$USER/start_ollama.sh
		  echo "echo '  '"                                                                                                  >> /home/$USER/start_ollama.sh
		  echo "echo 'IP:  '"                                                                                                  >> /home/$USER/start_ollama.sh
		  echo " hostname -I | awk '{ print \$1 }'"                                                                  >> /home/$USER/start_ollama.sh
		  echo "sleep 3"                                                                                            >> /home/$USER/start_ollama.sh
		  echo "echo '  '"                                                                                                  >> /home/$USER/start_ollama.sh
		  echo "docker start ollama "                                                                               >> /home/$USER/start_ollama.sh    
	      # Script to stop ollama
	      echo '#!/bin/bash'                                                                                        > /home/$USER/stop_ollama.sh
	      echo " "                                                                                                  >> /home/$USER/stop_ollama.sh
	      echo "docker stop ollama "                                                                                >> /home/$USER/stop_ollama.sh      
	      chmod +x /home/$USER/*.sh
	      # For model storage local folder ollama is mounted.
	      echo "Local folder ollama for models is: /var/lib/docker/volumes/ollama/"
	      echo "Will install ollama for CPU..."
	      sleep 4
	      # Creating alias for command: docker exec -it ollama
	      echo "alias ollama='docker exec -it ollama ollama'" >> /home/$USER/.bashrc
		  echo "docker start ollama"                          >> /home/$USER/.bashrc
	      #docker run -d --gpus=all -v /home/$USER/ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
	      # network host would be local mashine
		  echo -en "\007"
	      docker run -d  -v ollama:/root/.ollama -p 11434:11434 --network host --name ollama ollama/ollama
		  echo "ollama_installed.txt " > /home/$USER/ollama_installed.txt
		  sleep 2
		  wsl.exe --shutdown
	else
	      echo "Skipping install of ollama docker"
	fi
fi	

chmod +x /home/$USER/*.sh

##########################
### Download some minimum ollama models
##########################

echo " "
echo " "
if [ ! -f /home/$USER/models_installed.txt ]; then
	echo "------------"   
	echo "Shall I download a few ollama models? [Y,n]"
	read input
	input=${input:-Y}
	if [[ $input == "Y" || $input == "y" ]]; then
	      cd /home/$USER/
	      # Start ollama docker in future
	      docker start ollama 
		  sleep 4
		  ollama list
		  sleep 2
		  echo "Pulling bge-m3"
	      docker exec -it ollama ollama pull bge-m3
		  echo "Pulling llama3.2"
		  docker exec -it ollama ollama pull llama3.2:latest
		  echo " "
		  echo " "
		  #ollama list
		  echo "models installed" > /home/$USER/models_installed.txt
		  sleep 2
		  wsl.exe --shutdown
	else
	        echo "Skipping download of ollama models"
	fi
fi

chmod +x /home/$USER/*.sh

#####################3
# flowise docker
######################

echo " "
echo " "
cd /home/$USER
if [ ! -f /home/$USER/flowise_installed.txt ]; then
	echo "------------"   
	echo "Shall I install flowise docker? [Y,n]"    # Default is yes
	read input
	# Provide a default value of yes to 'input' 'https://stackoverflow.com/a/2642592
	input=${input:-y}
	if [[ $input == "Y" || $input == "y" ]]; then
	   cd /home/$USER/
	   # Install Flowise through docker"
	   # Ref: https://docs.flowiseai.com/getting-started
	   echo "Installing flowise docker. Takes time.."          
	   # Start script
	   echo '#!/bin/bash'                                         >  /home/$USER/start_flowise.sh
	   echo " "                                                   >> /home/$USER/start_flowise.sh
	   echo "cd ~/"                                               >> /home/$USER/start_flowise.sh
	   echo "echo 'Flowise port 3000 onstarting'"                 >> /home/$USER/start_flowise.sh
	   echo "echo 'Access flowise as: http://localhost:3000'"     >> /home/$USER/start_flowise.sh
	   echo " "                                                   >> /home/$USER/start_flowise.sh
	   echo "echo '======='"                                      >> /home/$USER/start_flowise.sh
	   echo "echo 'To reset flowise password, STOP flowise and then issue the command:'"   >> /home/$USER/start_flowise.sh
	   echo "echo '              sudo rm -rf .flowise/'"          >> /home/$USER/start_flowise.sh
	   echo "echo '  OR:            ./reset_flowise.sh'"          >> /home/$USER/start_flowise.sh
	   echo "echo '======='"                                      >> /home/$USER/start_flowise.sh
	   echo " "                                                   >> /home/$USER/start_flowise.sh
	   echo "cd /home/$USER/Flowise"                              >> /home/$USER/start_flowise.sh
	   echo "docker start docker-flowise-1"                       >> /home/$USER/start_flowise.sh
	   echo "sleep 3"                                             >> /home/$USER/start_flowise.sh
	   echo "netstat -aunt | grep 3000"                           >> /home/$USER/start_flowise.sh
	   # Reset flowise password
  	   echo '#!/bin/bash'                                         >  /home/$USER/reset_flowise.sh
	   echo " "                                                   >> /home/$USER/reset_flowise.sh
	   echo "echo '===Stopping flowise===='"                      >> /home/$USER/reset_flowise.sh
	   echo "cd /home/$USER/Flowise"                              >> /home/$USER/reset_flowise.sh
	   echo "docker stop docker-flowise-1"                        >> /home/$USER/reset_flowise.sh
	   echo "cd /home/$USER"                                      >> /home/$USER/reset_flowise.sh
	   echo "sudo rm -rf .flowise/"                               >> /home/$USER/reset_flowise.sh
	   echo "echo '===Restarting flowise===='"                    >> /home/$USER/reset_flowise.sh
	   echo " "                                                   >> /home/$USER/reset_flowise.sh
	   echo "cd /home/$USER/Flowise"                              >> /home/$USER/reset_flowise.sh
	   echo "docker start docker-flowise-1"                       >> /home/$USER/reset_flowise.sh
	   echo "sleep 3"                                             >> /home/$USER/reset_flowise.sh
	   echo "netstat -aunt | grep 3000"                           >> /home/$USER/reset_flowise.sh
       # logs script
	   echo '#!/bin/bash'                                         >  /home/$USER/logs_flowise.sh
	   echo " "                                                   >> /home/$USER/logs_flowise.sh
	   echo "cd /home/$USER/"                                     >> /home/$USER/logs_flowise.sh
	   #echo "echo 'Flowise version is:'"                          >> /home/$USER/logs_flowise.sh
	   #echo "docker logs flowise | grep start:default | head -1 | awk '{print \$2}'"  >> /home/$USER/logs_flowise.sh
	   #echo "sleep 4"                                             >> /home/$USER/logs_flowise.sh
	   echo "docker logs docker-flowise-1"                         >> /home/$USER/logs_flowise.sh
 	   # Stop script
	   echo '#!/bin/bash'                                        >  /home/$USER/stop_docker_flowise.sh
	   echo " "                                                  >> /home/$USER/stop_docker_flowise.sh
	   echo "cd /home/$USER/"                                    >> /home/$USER/stop_docker_flowise.sh
	   echo "echo 'Flowise Stopping'"                            >> /home/$USER/stop_docker_flowise.sh
	   echo "cd /home/$USER/Flowise"                             >> /home/$USER/stop_docker_flowise.sh
	   echo "docker stop docker-flowise-1"                                >> /home/$USER/stop_docker_flowise.sh
	   echo "netstat -aunt | grep 3000"                           >> /home/$USER/stop_docker_flowise.sh
	   sleep 4
	   cd ~/
	   git clone https://github.com/FlowiseAI/Flowise.git
	   cd Flowise/
	   sudo docker build --no-cache -t flowise .
	   # The '--network host' option removes network isolation between the container and
	   #   the Docker host machine, meaning the container directly shares the host's networking stack
	   # The container operates as if it were a process running directly on the host machine,
	   #   using the host's IP address and network interfaces.  
	   # sudo docker run -d --name flowise -p 3000:3000 --network host flowise
	   #      docker run -d --name flowise -p 3000:3000 --network host flowise
	   cd /home/$USER/Flowise/docker
	   cp .env.example .env
	   docker compose up -d
	   cd /home/$USER/
	   echo "In future to start/stop containers, proceed, as:"
	   echo "            cd /home/$USER/Flowise"                  
	   echo "            docker start docker-flowise-1"                    
	   echo "            docker stop docker-flowise-1"                     
	   echo " Also, check all containers available, as:"
	   echo "             docker ps -a "     
	   #ln -sT /home/$USER/start_flowise.sh start_flowise.sh
	   ln -sT /home/$USER/stop_docker_flowise.sh stop_flowise.sh
	   echo "flowise installed" > /home/$USER/flowise_installed.txt
	   mkdir -p /home/$USER/Documents/flowise
	   cd /home/$USER/Documents/flowise
	   wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/flowise/DesignChatflowsWithFlowise.pdf
	   wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/huggingface/huggingfaceAcessToken.pdf
	   cd /home/$USER
	   chmod +x /home/$USER/*.sh
	   sleep 2
	   wsl.exe --shutdown
	 else
	   echo "Flowise docker will not be installed"
	 fi  
	  echo "Flowise docker already installed"
 fi

chmod +x /home/$USER/*.sh

###########################
# Install latest anaconda
# https://askubuntu.com/a/841224
###########################

cd /home/$USER
echo " "
echo " "
if [ ! -f /home/$USER/anaconda_installed.txt ]; then
	echo " "
	echo " "
	echo "------------"        
	echo "Shall I install latest anaconda? [Y,n]"    
	read input
	input=${input:-Y}
	if [[ $input == "Y" || $input == "y" ]]; then
	    DIRECTORY=/home/$USER/anaconda3
	    if [ ! -d "$DIRECTORY" ]; then
	        CONTREPO=https://repo.continuum.io/archive/
			# In WSL Downloads folder does not exist
			mkdir /home/$USER/Downloads
	        # Stepwise filtering of the html at $CONTREPO
	        # Get the topmost line that matches our requirements, extract the file name.
	        ANACONDAURL=$(wget -q -O - $CONTREPO index.html | grep "Anaconda3-" | grep "Linux" | grep "86_64" | head -n 1 | cut -d \" -f 2)
	        wget -O /home/$USER/Downloads/anaconda.sh $CONTREPO$ANACONDAURL
	        bash /home/$USER//Downloads/anaconda.sh -b -p $HOME/anaconda3
	        rm /home/$USER/Downloads/anaconda.sh
	        echo 'export PATH="/home/$USER/anaconda3/bin:$PATH"' >> /home/$USER/.bashrc 
	        # Reload default profile
	        source /home/$USER/.bashrc
	        conda update conda -y
			# Download script to create conda venv
			wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/quick_flowise_ollama/venv/create_conda_venv.sh -P /home/$USER
			echo "anaconda_installed.txt" > /home/$USER/anaconda_installed.txt
		    chmod +x *.sh  
			wsl.exe --shutdown
	     else
	        echo "Anaconda is already installed in /home/$USER/anaconda3"
	     fi   
	 else
	    echo "Anaconda not installed"
	 fi
fi	 
 
chmod +x /home/$USER/*.sh
chmod +x /home/$USER/start/*.sh
chmod +x /home/$USER/stop/*.sh

################
# Install postgresql and sqlite3
################

echo " "
echo " "
cd /home/$USER
if [ ! -f /home/$USER/postgresql_installed.txt ]; then
	echo "------------"   
	echo "Shall I install postgres  db and pgvector? [Y,n]"    # 
	read input
	input=${input:-Y}
	if [[ $input == "Y" || $input == "y" ]]; then
	
	    # Install postgresql
	    cd /home/$USER/
	    echo "Installing postgresql and sqlite3"
		echo -en "\007"
	    sudo apt install postgresql postgresql-contrib sqlite3   -y
		
		# Postgresql start/stop script
		# Start script
		echo '#!/bin/bash'                                                      > /home/$USER/start_postgresql.sh  
	    echo " "                                                               >> /home/$USER/start_postgresql.sh  
	    echo "cd ~/"                                                           >> /home/$USER/start_postgresql.sh  
	    echo "echo 'postgresql will be available on port 5432'"                >> /home/$USER/start_postgresql.sh  
	    echo "sudo systemctl start postgresql.service"                         >> /home/$USER/start_postgresql.sh  
	    echo "sleep 2"                                                         >> /home/$USER/start_postgresql.sh  
	    echo "netstat -aunt | grep 5432"                                       >> /home/$USER/start_postgresql.sh  
	   
		# Stop script
	    echo '#!/bin/bash'                                                      > /home/$USER/stop_postgresql.sh  
	    echo " "                                                               >> /home/$USER/stop_postgresql.sh  
	    echo "cd ~/"                                                           >> /home/$USER/stop_postgresql.sh  
	    echo "sudo systemctl stop postgresql.service"                          >> /home/$USER/stop_postgresql.sh  
	    echo "sleep 2"                                                         >> /home/$USER/stop_postgresql.sh  
	    echo "netstat -aunt | grep 5432"                                       >> /home/$USER/stop_postgresql.sh  
		
		mkdir /home/$USER/psql
	    cd /home/$USER/psql
		
	    # Script to create sqlite database
		# A small help script
	    echo '#!/bin/bash'                                                     > /home/$USER/create_sqlite_db.sh 
	    echo " "                                                               >> /home/$USER/create_sqlite_db.sh 
	    echo "# Create sqlite3 database"                                       >> /home/$USER/create_sqlite_db.sh 
	    echo " "                                                               >> /home/$USER/create_sqlite_db.sh  
	    echo " "                                                               >> /home/$USER/create_sqlite_db.sh 
	    echo "echo 'How to create sqlite3 database?'"                          >> /home/$USER/create_sqlite_db.sh 
	    echo "echo 'To create database: mydatabase.db'"                        >> /home/$USER/create_sqlite_db.sh 
	    echo "echo 'issue command:'"                                           >> /home/$USER/create_sqlite_db.sh 
	    echo "echo '         sqlite3 mydatabase.db'"                           >> /home/$USER/create_sqlite_db.sh 
	    echo " "                                                               >> /home/$USER/create_sqlite_db.sh 
	    chmod +x *.sh
		
	    #############
	    # psql related
	    # Download help scripts that will inturn, help create user and password
	    # in postgresql
	    ##############
	    cd /home/$USER/
	    wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/psql/createpostgresuser.sh
	    wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/psql/show_postgres_databases.sh
	    wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/psql/createvectordb.sh
	    wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/psql/delete_postgres_db.sh
	    wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/psql/psql.sh
	    wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/psql/postgres_notes.txt
		wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/psql/permit_remote_con.sh
	    chmod +x /home/$USER/*.sh
	    
		# Create symlinks
	    cd /home/$USER/psql
	    ln -sT /home/$USER/createpostgresuser.sh         createpostgresuser.sh
	    ln -sT /home/$USER/show_postgres_databases.sh    show_postgres_databases.sh
	    ln -sT /home/$USER/createvectordb.sh             createvectordb.sh
	    ln -sT /home/$USER/delete_postgres_db.sh         delete_postgres_db.sh
	    ln -sT /home/$USER/psql.sh                       psql.sh
		ln -sT /home/$USER/permit_remote_con.sh          permit_remote_con.sh
	    cd /home/$USER
	    
		###########
	    ## Add postgres vector storage capability
	    ############
	    # Add vector storage capability to postgres
	    # My version of postgres db is 14.
	    # (Check as: pg_config --version)
	    # Install a needed package (depending upon your version of postgres)
	    # Check version as: pg_config --version
	    # Assuming version 16
	    pg_config --version    # Version is 16.9 so install: postgresql-server-dev-16 
	    psql -V | awk '{print $3}' |  cut -d '.' -f 1 | tr -d '\n'
	    version=$(psql -V | awk '{print $3}' |  cut -d '.' -f 1 | tr -d '\n')
	    sudo apt install postgresql-server-dev-$version  -y
	    #sudo apt install postgresql-server-dev-16  -y
	    # Ref: https://github.com/pgvector/pgvector
	    cd /tmp
	    git clone --branch v0.8.1 https://github.com/pgvector/pgvector.git
	    cd pgvector
	    make
	    sudo make install 

		# Create user ashok and database ashok
	    cd /home/$USER/
	    # Creating user 'ashok', and database 'ashok'. 
	    # User 'ashok' has full authority over database 'ashok'
	    echo " "
	    echo " "
	    echo "========="
	    echo "Creating user 'ashok' and database 'askok'"
	    echo "User 'ashok' has full authority over database 'ashok'"
	    echo "User 'ashok' has password: ashok"
	    echo "Database 'ashok' can also be used as vector database"
	    echo "========="
	    echo " "
	    echo " "
	    sleep 5
	    sudo -u postgres psql -c 'create database ashok;'
	    sudo -u postgres psql -c 'create user ashok;'
	    sudo -u postgres psql -c 'grant all privileges on database ashok to ashok;'
	    sudo -u postgres psql -c "alter user ashok with encrypted password 'ashok';"
	    sudo -u postgres psql -c "CREATE EXTENSION vector;" -d ashok
		
		sudo -u postgres psql -c "\du" 
		sudo -u postgres psql -c "\l"

		# Finally change postgresql.conf and pg_hba.conf and make them highly permissive
		version=$(psql -V | awk '{print $3}' |  cut -d '.' -f 1 | tr -d '\n')
		cd /etc/postgresql/$version/main
        echo "listen_addresses = '*'" |  sudo tee -a /etc/postgresql/$version/main/postgresql.conf
        echo "host    all             all             0.0.0.0/0               scram-sha-256" |  sudo tee -a /etc/postgresql/$version/main/pg_hba.conf
        sudo systemctl restart postgresql
        
		cd /home/$USER
		echo "postgresql installed" > /home/$USER/postgresql_installed.txt
		wsl.exe --shutdown
	 else
	   echo "Postgres not installed"
	 fi  
 fi

##########################
### Install RAGflow
# Ref: https://github.com/infiniflow/ragflow
#      https://github.com/infiniflow/ragflow/issues/9866   
##########################

echo " "
echo " "
cd /home/$USER
if [ ! -f /home/$USER/ragflow_installed.txt ]; then
    echo " "
    echo " "
	echo "------------"   
	echo "Shall I install RAGFlow docker? [Y,n]"    # 
	read input
	input=${input:-Y}
	if [[ $input == "Y" || $input == "y" ]]; then
	    echo " "
	    echo " "
	    echo "============"
	    echo "Will also set memory for ragflow docker container. It should be large enough"
	    echo "Memory parameter is MEM_LIMIT in ragflow/docker/.env file"
	    echo "You can press ctrl+c just now to review it."
	     echo "============"
	    sleep 10
	    cd /home/$USER/
	    echo "Installing RagFlow docker"
	    echo "After installation, access ragflow, as: http://<hostIP>:800"
	    sleep 5
	    # Start script
	    #--------------
	    echo '#!/bin/bash'                                         >  /home/$USER/start_ragflow.sh
	    echo " "                                                   >> /home/$USER/start_ragflow.sh
	    echo "echo '======'"                                       >> /home/$USER/start_ragflow.sh
	    echo "echo 'RagFlow port is 800'"                          >> /home/$USER/start_ragflow.sh
	    echo "echo 'Access ragflow, as: http://<hostIP>:800'"       >> /home/$USER/start_ragflow.sh
		echo "echo 'Your IP is' "                                   >> /home/$USER/start_ragflow.sh
		echo "hostname -I | awk ' {print \$1 } '"                   >> /home/$USER/start_ragflow.sh
	    echo "echo 'Check docker logs as: docker-ragflow-gpu-1'"   >> /home/$USER/start_ragflow.sh
	    echo "echo 'Memory parameter: MEM_LIMIT is in ragflow/docker/.env file'" >> /home/$USER/start_ragflow.sh
	    echo "echo '======'"                                       >> /home/$USER/start_ragflow.sh
	    echo "sleep 4"                                             >> /home/$USER/start_ragflow.sh
	    echo "cd /home/$USER/ragflow/docker"                        >> /home/$USER/start_ragflow.sh
	    echo "docker compose -f docker-compose.yml up -d"       >> /home/$USER/start_ragflow.sh
	    echo "netstat -aunt | grep 800"                             >> /home/$USER/start_ragflow.sh
        # ReStart script
	    #--------------
	    echo '#!/bin/bash'                                         >  /home/$USER/restart_ragflow.sh
	    echo " "                                                   >> /home/$USER/restart_ragflow.sh
	    echo "echo '======'"                                       >> /home/$USER/restart_ragflow.sh
	    echo "echo 'RagFlow will be restarted'"                    >> /home/$USER/restart_ragflow.sh
	    echo "echo '======'"                                       >> /home/$USER/restart_ragflow.sh
	    echo "sleep 4"                                             >> /home/$USER/restart_ragflow.sh
	    echo "bash stop_ragflow.sh"                                >> /home/$USER/restart_ragflow.sh
	    echo "sleep 3"                                             >> /home/$USER/restart_ragflow.sh
	    echo "bash start_ragflow.sh"                               >> /home/$USER/restart_ragflow.sh
	    echo '#!/bin/bash'                                          > /home/$USER/volumes_ragflow.sh
	    echo "echo 'RagFlow docker volumes'"                        >> /home/$USER/volumes_ragflow.sh
	    echo "echo 'Located under /var/lib/docker/volumes/'"        >> /home/$USER/volumes_ragflow.sh
	    echo "echo 'Should be: esdata01, mysql_data, minio_data, redis_data'"  >> /home/$USER/volumes_ragflow.sh
	    echo "sudo ls -la /var/lib/docker/volumes/"                 >> /home/$USER/volumes_ragflow.sh
	    ln -T /home/$USER/volumes_ragflow.sh  /home/$USER/about_ragflow.sh
	
	    echo '#!/bin/bash'                                          > /home/$USER/logs_ragflow.sh
	    echo " "                                                   >> /home/$USER/logs_ragflow.sh
	    echo "echo '======'"                                       >> /home/$USER/logs_ragflow.sh
	    echo "echo 'This terminal will remain engaged'"            >> /home/$USER/logs_ragflow.sh
	    echo "echo 'logs will continue to flow into this terminal'"      >> /home/$USER/logs_ragflow.sh
	    echo "echo 'logs will also be saved to ~/logs_ragflow.txt'"      >> /home/$USER/logs_ragflow.sh
	    echo "echo 'You can come out of it by pressing ctrl+c'"      >> /home/$USER/logs_ragflow.sh
	    echo "echo '======'"                                       >> /home/$USER/logs_ragflow.sh
	    echo "sleep 10"                                             >> /home/$USER/logs_ragflow.sh
	    echo "cd /home/$USER/ragflow/docker"                       >> /home/$USER/logs_ragflow.sh
	    echo "docker logs -f docker-ragflow-gpu-1"                 >> /home/$USER/logs_ragflow.sh
        #
	    # Start all
	    #--------------
	    echo '#!/bin/bash'                                         >  /home/$USER/start_all.sh
	    echo " "                                                   >> /home/$USER/start_all.sh
	    echo "echo '======'"                                       >> /home/$USER/start_all.sh
	    echo "echo 'Starting ollama, ragflow, xinference'"         >> /home/$USER/start_all.sh
	    echo "echo '======'"                                       >> /home/$USER/start_all.sh
	    echo "sleep 3"                                             >> /home/$USER/start_all.sh
	    echo "bash start_ollama.sh"                                >> /home/$USER/start_all.sh
		echo "sleep 1"                                             >> /home/$USER/start_all.sh
	    echo "bash start_xinference.sh"                            >> /home/$USER/start_all.sh
		echo "sleep 1"                                             >> /home/$USER/start_all.sh
	    echo "bash start_ragflow.sh"                               >> /home/$USER/start_all.sh
		echo "bash launch_xinference_model.sh"                     >> /home/$USER/start_all.sh
		# -------------------------
	    # Delete/Remove ragflow containers, images and volumes
		#---------------
	    echo '#!/bin/bash'                                          > /home/$USER/docker/del_rf_containers.sh
		echo "echo '=============='"           >> /home/$USER/docker/del_rf_containers.sh
	    echo "echo 'Will delete RagFlow containers, images and volumes'"      >> /home/$USER/docker/del_rf_containers.sh
	    echo "echo 'Press ctrl+c to exit now. Will wait for 8secs'"           >> /home/$USER/docker/del_rf_containers.sh
		echo "echo '================'"           >> /home/$USER/docker/del_rf_containers.sh
	    echo "sleep 8"                                             >> /home/$USER/docker/del_rf_containers.sh
	    echo "cd /home/$USER"                                      >> /home/$USER/docker/del_rf_containers.sh
	    echo " "                                                   >> /home/$USER/docker/del_rf_containers.sh
	    echo "echo '======'"                                       >> /home/$USER/docker/del_rf_containers.sh
	    echo "echo 'Stopping RagFlow'"                             >> /home/$USER/docker/del_rf_containers.sh
	    echo "echo '======'"                                       >> /home/$USER/docker/del_rf_containers.sh
	    echo "./stop_ragflow.sh"                                   >> /home/$USER/docker/del_rf_containers.sh
	    echo "echo 'Deleting containers now...'"                   >> /home/$USER/docker/del_rf_containers.sh
	    #
	    echo "echo '1.Deleting ragflow-server'"                    >> /home/$USER/docker/del_rf_containers.sh
	    echo "docker rm docker-ragflow-gpu-1"                      >> /home/$USER/docker/del_rf_containers.sh
	    #
	    echo "echo '2.Deleting ragflow-mysql'"                     >> /home/$USER/docker/del_rf_containers.sh
	    echo "docker rm docker-mysql-1"                             >> /home/$USER/docker/del_rf_containers.sh
	    #
	    echo "echo '3.Deleting ragflow-redis'"                      >> /home/$USER/docker/del_rf_containers.sh
	    echo "docker rm docker-redis-1"                              >> /home/$USER/docker/del_rf_containers.sh
	    #
	    echo "echo '4.Deleting ragflow-minio'"                     >> /home/$USER/docker/del_rf_containers.sh
	    echo "docker rm docker-minio-1"                             >> /home/$USER/docker/del_rf_containers.sh
	    #
	    echo "echo '5.Deleting ragflow-es-01'"                     >> /home/$USER/docker/del_rf_containers.sh
	    echo "docker rm docker-es01-1"                             >> /home/$USER/docker/del_rf_containers.sh
	    echo "echo ' '"                                            >> /home/$USER/docker/del_rf_containers.sh
	    echo "echo 'Deleting volumes'"                             >> /home/$USER/docker/del_rf_containers.sh 
	    echo "cd /home/$USER/ragflow/docker"                       >> /home/$USER/docker/del_rf_containers.sh
	    echo "docker compose down --volumes"                       >> /home/$USER/docker/del_rf_containers.sh
	    echo "echo ' '"                                            >> /home/$USER/docker/del_rf_containers.sh
	    echo "echo 'Deleting images..'"                            >> /home/$USER/docker/del_rf_containers.sh
	    echo "docker compose down --rmi all"                       >> /home/$USER/docker/del_rf_containers.sh
	    echo "echo '  '"                                           >> /home/$USER/docker/del_rf_containers.sh
	    echo "echo 'Next, delete folder: /home/$USER/ragflow/'"     >> /home/$USER/docker/del_rf_containers.sh
	    echo "echo ' '"                                            >> /home/$USER/docker/del_rf_containers.sh
	    echo "echo ' '"                                            >> /home/$USER/docker/del_rf_containers.sh
	    echo "cd /home/$USER"                                      >> /home/$USER/docker/del_rf_containers.sh
	    echo "./volumes_ragflow.sh"                                >> /home/$USER/docker/del_rf_containers.sh   
		echo "rm /home/$USER/ragflow_installed.txt"                >> /home/$USER/docker/del_rf_containers.sh  
		echo "sudo rm -rf /home/$USER/ragflow"                     >> /home/$USER/docker/del_rf_containers.sh 
		echo "rm /home/$USER/docker/del_rf_containers.sh"          >> /home/$USER/docker/del_rf_containers.sh
		echo "rm /home/$USER/rm_ragflow.sh"                        >> /home/$USER/docker/del_rf_containers.sh
		echo "rm /home/$USER/delete_ragflow.sh"                    >> /home/$USER/docker/del_rf_containers.sh
		echo "rm /home/$USER/about_ragflow.sh"                     >> /home/$USER/docker/del_rf_containers.sh
	    cd /home/$USER/docker
	    chmod +x *.sh
	    cd /home/$USER
		ln -sT /home/$USER/docker/del_rf_containers.sh   delete_ragflow.sh
		ln -sT /home/$USER/docker/del_rf_containers.sh   rm_ragflow.sh
		#
	    chmod +x *.sh  
	    #
	    # Stop script
	    #-------------
	    echo '#!/bin/bash'                                        >  /home/$USER/stop_ragflow.sh
	    echo " "                                                  >> /home/$USER/stop_ragflow.sh
	    echo "cd ~/"                                              >> /home/$USER/stop_ragflow.sh
	    echo "echo 'ragflow Stopping'"                            >> /home/$USER/stop_ragflow.sh
	    echo "cd /home/$USER/ragflow/docker"                      >> /home/$USER/stop_ragflow.sh
	    echo "docker compose -f docker-compose.yml stop "     >> /home/$USER/stop_ragflow.sh
	    #
	    chmod +x /home/$USER/*.sh
	    chmod +x /home/$USER/*.sh
	    # Installation script
	    sudo sysctl -w vm.max_map_count=262144
	    echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
	    git clone https://github.com/infiniflow/ragflow.git
	    
	    cd ragflow/docker
		# which version to install
		git checkout v0.23.1
		# Change some port numbers as per our conveience
	    sed -i 's/SVR_WEB_HTTP_PORT=80/SVR_WEB_HTTP_PORT=800/' .env
	    sed -i 's/SVR_WEB_HTTPS_PORT=443/SVR_WEB_HTTPS_PORT=1443/' .env
	    #
	    # Increase memory available for docker as files may be large (20gb)
	    echo "Will now set memory for ragflow docker container. It should be large enough"
	    sleep 4
	    # Use GPU for deepdoc
	    sed -i '1i DEVICE=gpu' .env
	    # Change RAM available
	    sed -i '/MEM_LIMIT=8073741824/c\MEM_LIMIT=20073741824' /home/$USER/ragflow/docker/.env
	    docker compose -f docker-compose.yml up -d
		sleep 80
	    echo " "
	    echo " "
	    echo "==========="
	    echo "Will Initialise ragflow. Use ctrl+c to break AFTER process has started."
	    echo "==========="
	    echo " "
	    echo " "
		echo "ragflow_installed.txt" > /home/$USER/ragflow_installed.txt
	    docker logs -f docker-ragflow-gpu-1
		# Prevent docker restarts on OS reboot
        docker update --restart=no $(docker ps -a -q)
		
	else
	     echo "Ragflow will not be installed"
	fi  
fi
# Prevent docker restarts on OS reboot
docker update --restart=no $(docker ps -a -q)

 

