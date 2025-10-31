#!/bin/bash

# Last amended: 30th Oct, 2025

echo "========script=============="
echo "Will update Ubuntu"
echo "Will install cuda toolkit"
echo "Will install docker"
echo "Will install python venv"
echo "Install portainer"
echo "Will install flowise docker"
echo "Will install ollama docker for gpu"
echo "Will install chromadb docker"
echo "Will install n8n docker"
echo "Will install dify docker"
echo "Will install mongodb and mongosh:"
echo "Installs postgres db and pgvector"
echo "Installs xinference"
echo "Installs AutoGen Studio"
echo "Install latest anaconda"
echo "Install Visual Studio Coder"
echo "Will install Ragflow docker"
echo "==========================="
sleep 2


################
# Update Ubuntu
# Also install postgresql
################

cd /home/$USER
if [ ! -f /home/$USER/ubuntu_updated.txt ]; then
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
    echo "Ubuntu is updated" > /home/$USER/ubuntu_updated.txt   # To avoid repeat updation
    # Download docker installation scripts
    wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/ubuntu_docker1.sh -P /home/$USER
    wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/ubuntu_docker2.sh -P /home/$USER
    perl -pi -e 's/\r\n/\n/g' /home/$USER/ubuntu_docker1.sh
    perl -pi -e 's/\r\n/\n/g' /home/$USER/ubuntu_docker2.sh
    chmod +x /home/$USER/*.sh
    echo " "
    echo "Ubuntu upgraded ......"               
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
    echo "====NOTE====="
    echo "Machine will be rebooted several times. After each reboot, execute the following script:"
    echo " "
    echo "=>   ./ollama_flowise_chroma_n8n_ubuntu.sh"
    echo "=========="
    sleep 15
    reboot
fi

##################
# Install CUDA toolkit
#################

cd /home/$USER
if [ ! -f /home/$USER/cuda_installed.txt ]; then
    cd /home/$USER
    echo " "
    echo " "
    echo "------------"        
    echo " "
    echo "  "
    echo "==>For Ubuntu 22.04 ONLY<=="
    echo "Shall I install NVIDIA Toolkit (cuda-13) for Ubuntu-22.04? [Y,n]"    
    read input
    input=${input:-Y}
    if [[ $input == "Y" || $input == "y" ]]; then
       # Remove old gpg key
        sudo apt-key del 7fa2af80
        # Now follow the instructions as on this page:
        #  https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=WSL-Ubuntu&target_version=2.0&target_type=deb_local
        # Added on 27th Sep, 2025
       wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
       sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
       wget https://developer.download.nvidia.com/compute/cuda/13.0.1/local_installers/cuda-repo-ubuntu2204-13-0-local_13.0.1-580.82.07-1_amd64.deb
       sudo dpkg -i cuda-repo-ubuntu2204-13-0-local_13.0.1-580.82.07-1_amd64.deb
       sudo cp /var/cuda-repo-ubuntu2204-13-0-local/cuda-*-keyring.gpg /usr/share/keyrings/
       sudo apt-get update
       sudo apt-get -y install cuda-toolkit-13-0
       # NVIDIA Driver Instructions
       sudo apt-get install -y nvidia-open
       sudo apt autoremove -y
       sleep 3
       echo "cuda is installed" > /home/$USER/cuda_installed.txt   # To avoid repeat cuda installation
       reboot
    else
       echo "No installation of cuda toolkit"
    fi  
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
    echo "Ubuntu will be closed/rebooted "
    echo "After opening/restart, execute:"
    sleep 9
    reboot
else
   echo "Docker is installed"
fi  

mkdir /home/$USER/docker
cd /home/$USER/docker
echo "Download script to print names of docker containers"
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/docker/names_dockers.sh
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
    #
    # PReparing docker for GPU
    # Ref StackOverflow: https://stackoverflow.com/a/77269071
    # Ref: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#installation
    # 1.0 Configure the repository (it is one command):
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey |sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
    && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list \
    && sudo apt-get update
    #
    # 2.0 Install the NVIDIA Container Toolkit packages:
    #
    sudo apt-get install -y nvidia-container-toolkit
    #
    # 3.0  Configure the container runtime by using the nvidia-ctk command:
    #
    sudo nvidia-ctk runtime configure --runtime=docker
    #
    # 4.0 Restart the Docker daemon:
    #
    sudo systemctl restart docker
    #
    # Store docker help files
    mkdir /home/$USER/Documents/dockers
    cd /home/$USER/Documents/dockers
    wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/docker/Understanding%20docker%20technology.pdf?raw=true
    wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/docker/docker%20commands.txt?raw=true
    wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/docker/dockers%20in%20brief.pdf?raw=true
    cd /home/$USER/
    #
    echo "Docker installation completed" > /home/$USER/docker_installed_1.txt   # To avoid repeat installation
    echo "Machine will be rebooted "
    reboot
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
        pip install wheel
        pip install ipython
        pip install notebook
        pip install streamlit
        pip install --upgrade setuptools
        echo "venv_installed.txt" > /home/$USER/venv_installed.txt
        # Required for spyder:
        sudo apt install pyqt5-dev-tools -y
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
     else
        echo "Python venv not installed"
     fi   
fi   

###########################
# Install latest anaconda
# https://askubuntu.com/a/841224
###########################

cd /home/$USER
echo " "
echo " "
echo "------------"        
echo "Shall I latest anaconda? [Y,n]"    
read input
input=${input:-Y}
if [[ $input == "Y" || $input == "y" ]]; then
    DIRECTORY=/home/$USER/anaconda3
    if [ ! -d "$DIRECTORY" ]; then
        CONTREPO=https://repo.continuum.io/archive/
        # Stepwise filtering of the html at $CONTREPO
        # Get the topmost line that matches our requirements, extract the file name.
        ANACONDAURL=$(wget -q -O - $CONTREPO index.html | grep "Anaconda3-" | grep "Linux" | grep "86_64" | head -n 1 | cut -d \" -f 2)
        wget -O ~/Downloads/anaconda.sh $CONTREPO$ANACONDAURL
        bash ~/Downloads/anaconda.sh -b -p $HOME/anaconda3
        rm ~/Downloads/anaconda.sh
        echo 'export PATH="~/anaconda3/bin:$PATH"' >> ~/.bashrc 
        # Reload default profile
        source ~/.bashrc
        conda update conda -y
     else
        echo "Anaconda is already installed in /home/$USER/anaconda3"
     fi   
 else
    echo "Anaconda not installed"
 fi
 
#####################3
# portrainer docker
######################

cd /home/$USER
echo " "
echo " "
echo "------------"        
echo "Shall I install portainer docker? [Y,n]"    # Else docker chromadb may be installed
read input
input=${input:-Y}
if [[ $input == "Y" || $input == "y" ]]; then
   # Installing portrainer
   echo "Installing portainer docker "                             | tee -a /home/$USER/info.log
   # Script to start portainer container
   echo '#!/bin/bash'                                              > /home/$USER/start/start_portainer.sh
   echo " "                                                       >> /home/$USER/start/start_portainer.sh
   echo "cd /home/$USER"                                          >> /home/$USER/start/start_portainer.sh
   echo "echo '#========'"                                        >> /home/$USER/start/start_portainer.sh
   echo "echo '#Access portainer at:'"                            >> /home/$USER/start/start_portainer.sh
   echo "echo '#https://127.0.0.1:9443'"                          >> /home/$USER/start/start_portainer.sh
   echo "echo '#User: admin; password: foreschoolmgt'"            >> /home/$USER/start/start_portainer.sh
   echo "echo '#=========='"                                      >> /home/$USER/start/start_portainer.sh
   #echo "cd /home/$USER/portainer/"                               >> /home/$USER/start/start_portainer.sh
   echo "docker start portainer"                                  >> /home/$USER/start/start_portainer.sh
   echo "netstat -aunt | grep 9443"                               >> /home/$USER/start/start_portainer.sh
   #
   echo '#!/bin/bash'                                              > /home/$USER/stop/stop_portainer.sh
   echo " "                                                       >> /home/$USER/stop/stop_portainer.sh
   echo "cd /home/$USER"                                          >> /home/$USER/stop/stop_portainer.sh
   #echo "cd /home/$USER/portainer/"                               >> /home/$USER/stop/stop_portainer.sh
   echo "docker stop portainer"                                   >> /home/$USER/stop/stop_portainer.sh
   echo "netstat -aunt | grep 9443"                               >> /home/$USER/stop/stop_portainer.sh
   #
   cd /home/$USER
   docker volume create portainer_data
   # This is one long line command
   # To change port 8000 to a different value, see: https://github.com/portainer/portainer-docs/issues/91#issuecomment-1184225862
   # Install portainer community edition (ce)
   #docker run -d -p 8888:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.21.5
   docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:lts
else
   echo "Portainer not installed"
fi   
   

chmod +x /home/$USER/*.sh
chmod +x /home/$USER/start/*.sh
chmod +x /home/$USER/stop/*.sh
 

##########################
### Install chromadb docker
# Ref: https://docs.trychroma.com/production/containers/docker
#      https://cookbook.chromadb.dev/strategies/cors/
##########################

cd /home/$USER
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
    echo "docker run -d --rm --network host -e CHROMA_SERVER_CORS_ALLOW_ORIGINS='[\"http://localhost:3000\"]' -v /home/$USER/chroma_data:/chroma/chroma -p 8000:8000 --name chroma chromadb/chroma:0.6.3 "   | tee -a /home/$USER/start_chroma.sh 

    # Pulling chromadb docker image  
    cd /home/$USER/
    echo " "                                       | tee -a /home/$USER/error.log
    echo " Pulling chromadb docker image"          | tee -a /home/$USER/error.log
    # Refer: https://cookbook.chromadb.dev/strategies/cors/
    docker run -d --rm --network host -e CHROMA_SERVER_CORS_ALLOW_ORIGINS='["http://localhost:3000"]' -v /home/$USER/chroma_data:/chroma/chroma -p 8000:8000 --name chroma  chromadb/chroma:0.6.3 
    echo "------------"                            | tee -a /home/$USER/error.log
    echo " "                                       | tee -a /home/$USER/error.log
    sleep 3
else
    echo "Skipping install of chromadb docker"
fi   
#
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
else
    echo "n8n docker will not be installed"
fi

chmod +x /home/$USER/*.sh

##########################
### ollama docker
##########################

echo " "
echo " "
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
      echo "echo '6. Test ollama, as: http://host.docker.internal:11434'"                                       >> /home/$USER/start_ollama.sh
      echo "echo '   Or, as: http://hostip:11434 (hostip maybe: 172.17.0.1 but NOT 127.0.0.1)'"                 >> /home/$USER/start_ollama.sh
      echo "echo '7. Pulled models are available at /var/lib/docker/volumes/ollama/ '"                          >> /home/$USER/start_ollama.sh
      echo "echo '8. Remember ollama is now an alias NOT the actual command '"                                  >> /home/$USER/start_ollama.sh
      echo "docker start ollama "                                                                               >> /home/$USER/start_ollama.sh     
      # Script to stop ollama
      echo '#!/bin/bash'                                                                                        > /home/$USER/stop_ollama.sh
      echo " "                                                                                                  >> /home/$USER/stop_ollama.sh
      echo "docker stop ollama "                                                                                >> /home/$USER/stop_ollama.sh      
      chmod +x /home/$USER/*.sh
      # For model storage local folder ollama is mounted.
      echo "Local folder ollama for models is: /var/lib/docker/volumes/ollama/"
      echo "Will install ollama for GPU..."
      sleep 4
      # Creating alias for command: docker exec -it ollama
      echo "alias ollama='docker exec -it ollama ollama'" >> /home/$USER/.bashrc
      #docker run -d --gpus=all -v /home/$USER/ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
      # network host would be local mashine
      docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --network host --name ollama ollama/ollama
else
        echo "Skipping install of ollama docker"
fi

chmod +x /home/$USER/*.sh


#####################3
# flowise docker
######################

echo " "
echo " "
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
   echo "cd /home/$USER/Flowise"                              >> /home/$USER/start_flowise.sh
   echo "docker start flowise"                                >> /home/$USER/start_flowise.sh
   echo "netstat -aunt | grep 3000"                           >> /home/$USER/start_flowise.sh
   # Stop script
   echo '#!/bin/bash'                                        >  /home/$USER/stop_docker_flowise.sh
   echo " "                                                  >> /home/$USER/stop_docker_flowise.sh
   echo "cd ~/"                                              >> /home/$USER/stop_docker_flowise.sh
   echo "echo 'Flowise Stopping'"                            >> /home/$USER/stop_docker_flowise.sh
   echo "cd /home/$USER/Flowise"                             >> /home/$USER/stop_docker_flowise.sh
   echo "docker stop flowise"                                >> /home/$USER/stop_docker_flowise.sh
   echo "netstat -aunt | grep 3000"                           >> /home/$USER/stop_docker_flowise.sh
   sleep 4
   cd ~/
   git clone https://github.com/FlowiseAI/Flowise.git
   cd Flowise/
   sudo docker build --no-cache -t flowise .
   sudo docker run -d --name flowise -p 3000:3000 --network host flowise
   #    docker run -d --name flowise -p 3000:3000 --network host flowise
   echo "In future to start/stop containers, proceed, as:"
   echo "            cd /home/$USER/Flowise"                  
   echo "            docker start flowise"                    
   echo "            docker stop flowise"                     
   echo " Also, check all containers available, as:"
   echo "             docker ps -a "     
   #ln -sT /home/$USER/start_flowise.sh start_flowise.sh
   #ln -sT /home/$USER/stop_docker_flowise.sh stop_flowise.sh
 else
   echo "Flowise docker will not be installed"
 fi  

chmod +x /home/$USER/*.sh
chmod +x /home/$USER/*.sh


##########################
### Install dify
# Ref: https://github.com/langgenius/dify?tab=readme-ov-file#quick-start
##########################
  
    echo " "
    echo " "
    echo "------------"   
    echo "Shall I install dify docker? [Y,n]"    # 
    read input
    input=${input:-Y}
    if [[ $input == "Y" || $input == "y" ]]; then
        cd /home/$USER/
        echo " "
        echo "======"                                             
        echo "Installing dify docker"
        echo "Access it at: http://localhost:8887/install"
        echo "======"                                              
        echo " "
        sleep 5
        cd /home/$USER
        git clone https://github.com/langgenius/dify.git
        cd /home/$USER/dify/docker
        cp .env.example .env
        sed -i 's/NGINX_PORT=80/NGINX_PORT=8887/' .env
        sed -i 's/EXPOSE_NGINX_PORT=80/EXPOSE_NGINX_PORT=8887/' .env
        sed -i 's/NGINX_SSL_PORT=443/NGINX_SSL_PORT=4443/' .env
        docker compose up -d
        # Start script
        echo '#!/bin/bash'                                          >  /home/$USER/start_dify.sh
        echo " "                                                   >> /home/$USER/start_dify.sh
        echo "echo '======'"                                       >> /home/$USER/start_dify.sh
        echo "echo 'dify port is 8887'"                            >> /home/$USER/start_dify.sh
        echo "echo 'Access it at: http://localhost:8887/install'"  >> /home/$USER/start_dify.sh
        echo "echo '======'"                                       >> /home/$USER/start_dify.sh
        echo "sleep 4"                                             >> /home/$USER/start_dify.sh
        echo "cd /home/$USER/dify/docker"                          >> /home/$USER/start_dify.sh
        echo "docker compose up -d"                                >> /home/$USER/start_dify.sh
        echo "netstat -aunt | grep 8887"                           >> /home/$USER/start_dify.sh
        # Stop script
        echo '#!/bin/bash'                                         >  /home/$USER/stop_dify.sh
        echo " "                                                  >> /home/$USER/stop_dify.sh
        echo "echo 'dify Stopping'"                               >> /home/$USER/stop_dify.sh
        echo "cd /home/$USER/dify/docker"                         >> /home/$USER/stop_dify.sh
        echo "docker compose stop"                                >> /home/$USER/stop_dify.sh
        sleep 4
    else
        echo "dify not installed"
    fi


################
# Install postgresql and sqlite3
################

echo " "
echo " "
echo "------------"   
echo "Shall I install postgres  db and pgvector? [Y,n]"    # 
read input
input=${input:-Y}
if [[ $input == "Y" || $input == "y" ]]; then
    cd /home/$USER/
    echo "Installing postgresql and sqlite3"
    sudo apt install postgresql postgresql-contrib sqlite3   -y
    # Postgresql start/stop script
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
    cd /home/$USER/psql
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
    # Download scripts that will inturn, help create user and password
    # in postgresql
    ##############
    cd /home/$USER/
    wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/psql/createpostgresuser.sh
    wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/psql/show_postgres_databases.sh
    wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/psql/createvectordb.sh
    wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/psql/delete_postgres_db.sh
    wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/psql/psql.sh
    wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/psql/postgres_notes.txt
    chmod +x /home/$USER/*.sh
    # Create links
    mkdir /home/$USER/psql
    cd /home/$USER/psql
    ln -sT /home/$USER/createpostgresuser.sh         createpostgresuser.sh
    ln -sT /home/$USER/show_postgres_databases.sh    show_postgres_databases.sh
    ln -sT /home/$USER/createvectordb.sh             createvectordb.sh
    ln -sT /home/$USER/delete_postgres_db.sh         delete_postgres_db.sh
    ln -sT /home/$USER/psql.sh                       psql.sh
    cd ~/
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
    git clone --branch v0.8.0 https://github.com/pgvector/pgvector.git
    cd pgvector
    make
    sudo make install 
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
 else
   echo "Postgres not installed"
 fi  


#########################
### Install mongodb and mongosh
# https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-ubuntu/
# Mongosh: https://www.mongodb.com/docs/mongodb-shell/install/
#########################

echo " "
echo " "
echo "------------"   
echo "Mongodb install depends upon your ubuntu version"
echo "Check (release or) version now:"
echo "========"
lsb_release -a
echo "========"
echo "Shall I install mongodb db for Ubuntu 22.04? [Y,n]"    # 
read input
input=${input:-Y}
if [[ $input == "Y" || $input == "y" ]]; then
    cd /home/$USER/
    sudo apt-get install gnupg curl
    curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
            sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg \
            --dearmor
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
    sudo apt-get update
    sudo apt-get install -y mongodb-org
    sudo systemctl start mongod
    #On error
    #sudo systemctl daemon-reload
   # Mongosh
   echo "Will install mongosh"
   sleep 4
   wget -qO- https://www.mongodb.org/static/pgp/server-8.0.asc | sudo tee /etc/apt/trusted.gpg.d/server-8.0.asc
   sudo apt-get install gnupg
   wget -qO- https://www.mongodb.org/static/pgp/server-8.0.asc | sudo tee /etc/apt/trusted.gpg.d/server-8.0.asc
   echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
   sudo apt-get update
   sudo apt-get install -y mongodb-mongosh
   mongosh --version
   netstat a-aunt | grep 27017
   # mongodb start script
   echo '#!/bin/bash'                                                      > /home/$USER/start_mongodb.sh  
   echo " "                                                               >> /home/$USER/start_mongodb.sh  
   echo "cd ~/"                                                           >> /home/$USER/start_mongodb.sh  
   echo "echo 'mongodb will be available on port 27017'"                  >> /home/$USER/start_mongodb.sh  
   echo "sudo systemctl start mongod"                                     >> /home/$USER/start_mongodb.sh  
   echo "sleep 2"                                                         >> /home/$USER/start_mongodb.sh  
   echo "netstat -aunt | grep 27017"                                      >> /home/$USER/start_mongodb.sh  
   # mongodb stop script
   echo '#!/bin/bash'                                                      > /home/$USER/stop_mongodb.sh  
   echo " "                                                               >> /home/$USER/stop_mongodb.sh  
   echo "cd ~/"                                                           >> /home/$USER/stop_mongodb.sh  
   echo "sudo systemctl stop mongod"                                     >> /home/$USER/stop_mongodb.sh  
   echo "sleep 2"                                                         >> /home/$USER/stop_mongodb.sh  
   echo "netstat -aunt | grep 27017"                                      >> /home/$USER/stop_mongodb.sh  
   chmod +x /home/$USER/*.sh
   # Dowload some files
   mkdir -p /home/$USER/Documents/mongodb/datasets
   cd /home/$USER/Documents/mongodb/datasets
   wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/datasets/catalog.books.json
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/datasets/credit_card_customers.json
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/datasets/howToImport.txt
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/datasets/primer-dataset.json
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/datasets/restaurant.json
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/datasets/students.json
   cd /home/$USER/Documents/mongodb
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/0.about%20json-0.txt
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/1.mongo_CRUD.txt
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/3.mongo_qyeryTextSearch.txt
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/4.fullTextSearch.txt
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/5.mongo_aggregationPipe.txt
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/7.mongo_backupRestore.txt
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/12.accessControl_class_mongo.txt
else
    echo "Mongodb for Ubuntu 22.04 not installed"
fi    

echo " "
echo " "
echo "------------"  
echo "Mongodb install depends upon your ubuntu version"
echo "Check (release or) version now:"
echo "========"
lsb_release -a
echo "========"
echo "Shall I install mongodb db for Ubuntu 24.04? [Y,n]"    # 
read input
input=${input:-Y}
if [[ $input == "Y" || $input == "y" ]]; then
    cd /home/$USER/
    sudo apt-get install gnupg curl
    curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
            sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg \
            --dearmor
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
    sudo apt-get update
    sudo apt-get install -y mongodb-org
    sudo systemctl start mongod
    #On error
    #sudo systemctl daemon-reload
   # Mongosh
   echo "Will install mongosh"
   sleep 4
   wget -qO- https://www.mongodb.org/static/pgp/server-8.0.asc | sudo tee /etc/apt/trusted.gpg.d/server-8.0.asc
   sudo apt-get install gnupg
   wget -qO- https://www.mongodb.org/static/pgp/server-8.0.asc | sudo tee /etc/apt/trusted.gpg.d/server-8.0.asc
   echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
   sudo apt-get update
   sudo apt-get install -y mongodb-mongosh
   mongosh --version
   netstat a-aunt | grep 27017
   # mongodb start script
   echo '#!/bin/bash'                                                      > /home/$USER/start_mongodb.sh  
   echo " "                                                               >> /home/$USER/start_mongodb.sh  
   echo "cd ~/"                                                           >> /home/$USER/start_mongodb.sh  
   echo "echo 'mongodb will be available on port 27017'"                  >> /home/$USER/start_mongodb.sh  
   echo "sudo systemctl start mongod"                                     >> /home/$USER/start_mongodb.sh  
   echo "sleep 2"                                                         >> /home/$USER/start_mongodb.sh  
   echo "netstat -aunt | grep 27017"                                      >> /home/$USER/start_mongodb.sh 
   # mongodb stop script
   echo '#!/bin/bash'                                                      > /home/$USER/stop_mongodb.sh  
   echo " "                                                               >> /home/$USER/stop_mongodb.sh  
   echo "cd ~/"                                                           >> /home/$USER/stop_mongodb.sh  
   echo "sudo systemctl stop mongod"                                     >> /home/$USER/stop_mongodb.sh  
   echo "sleep 2"                                                         >> /home/$USER/stop_mongodb.sh  
   echo "netstat -aunt | grep 27017"                                      >> /home/$USER/stop_mongodb.sh  
   chmod +x /home/$USER/*.sh
   # Dowload some files
   mkdir -p /home/$USER/Documents/mongodb/datasets
   cd /home/$USER/Documents/mongodb/datasets
   wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/datasets/catalog.books.json
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/datasets/credit_card_customers.json
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/datasets/howToImport.txt
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/datasets/primer-dataset.json
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/datasets/restaurant.json
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/datasets/students.json
   cd /home/$USER/Documents/mongodb
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/0.about%20json-0.txt
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/1.mongo_CRUD.txt
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/3.mongo_qyeryTextSearch.txt
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/4.fullTextSearch.txt
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/5.mongo_aggregationPipe.txt
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/7.mongo_backupRestore.txt
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/12.accessControl_class_mongo.txt
else
    echo "Mongodb for Ubuntu24.04 not installed"
fi   

# Prevent docker restarts on OS reboot
docker update --restart=no $(docker ps -a -q)


###################
# llama.cpp install
# python env remains activated
# source /home/$USER/venv/bin/activate
###################
cuda_version=$(nvidia-smi | grep CUDA | awk '{print $9}')
echo " "
echo "==========="
echo "Your installed CUDA version is: $cuda_version"
echo "If this version is different from 12.4, you will have to first"
echo "change cu124, to say, cu127 for version 12.7 before installing"
echo "llama.cpp."
echo "==========="
echo " "
echo "Shall I now install llama.cpp (if your CUDA version is correct)? [Y,n]"   
read input
input=${input:-Y}
if [[ $input == "Y" || $input == "y" ]]; then
  # Installing llama.cpp
  source /home/$USER/venv/bin/activate
   # Huggingface and llama.cpp related
  pip install huggingface_hub
  pip install transformers
  pip install accelerate
  #cu124: is as per cuda version. Get cuda version from nvidia-smi
  pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124
  echo " "                                         | tee -a /home/$USER/error.log
  echo "Installing llama.cpp"                      | tee -a /home/$USER/error.log
  echo "------------"                              | tee -a /home/$USER/error.log
  echo " "                                         | tee -a /home/$USER/error.log
  git clone https://github.com/ggerganov/llama.cpp
  cd llama.cpp
  cmake -B build
  cmake --build build --config Release
  cd /home/$USER
  sleep 2
  # Create a symlink to models and to gguf folder
  ln -s /home/$USER/llama.cpp/models/ /home/$USER/
  ln -s /home/$USER/llama.cpp/models/ /home/$USER/gguf
  echo "PATH=\$PATH:/home/$USER/llama.cpp/build/bin" >> .bashrc
  echo " "                                        | tee -a /home/$USER/error.log
  echo "-------"                                  | tee -a /home/$USER/error.log
  echo "llama.cpp installed"                      | tee -a /home/$USER/error.log
  echo "10. llama.cpp installed"                  | tee -a /home/$USER/info.log
  echo "-------"                                  | tee -a /home/$USER/error.log
  # Script to start llama.cpp server
  echo '#!/bin/bash'                                         | tee    /home/$USER/start/start_llamacpp_server.sh
  echo " "                                                   | tee -a /home/$USER/start/start_llamacpp_server.sh
  echo "cd /home/$USER"                                               | tee -a /home/$USER/start/start_llamacpp_server.sh
  echo " "                                                   | tee -a /home/$USER/start/start_llamacpp_server.sh
  echo "echo 'llama.cpp server will be available at port: 8080'"            | tee -a /home/$USER/start/start_llamacpp_server.sh
  echo "echo 'Script will use model: llama-thinker-3b-preview-q8_0.gguf'"   | tee -a /home/$USER/start/start_llamacpp_server.sh
  echo "echo 'Change it, if you like, by changing the script'"              | tee -a /home/$USER/start/start_llamacpp_server.sh
  echo " "                                                                  | tee -a /home/$USER/start/start_llamacpp_server.sh
  echo "sleep 10"                                                           | tee -a /home/$USER/start/start_llamacpp_server.sh
  echo "source /home/$USER/venv/bin/activate"                          | tee -a /home/$USER/start/start_llamacpp_server.sh
  echo "llama-server -m /home/$USER/gguf/llama-thinker-3b-preview-q8_0.gguf -c 2048"  | tee -a /home/$USER/start/start_llamacpp_server.sh
  mkdir /home/$USER/gguf
  cd /home/$USER/gguf
  echo "Downloading llama-thinker-3b-preview.q8_0.gguf. Takes time..."
  sleep 4
  wget -c https://huggingface.co/mradermacher/Llama-Thinker-3B-Preview-GGUF/resolve/main/Llama-Thinker-3B-Preview.Q8_0.gguf?download=true
  mv 'Llama-Thinker-3B-Preview.Q8_0.gguf?download=true'  llama-thinker-3b-preview.q8_0.gguf
  echo "Done...."
  cd /home/$USER
else
  echo "Skipping install of llama.cpp"
fi
  
chmod +x /home/$USER/start/*.sh
chmod +x /home/$USER/*.sh



##########################
### Install xinference docker
# Ref: https://inference.readthedocs.io/en/latest/getting_started/using_docker_image.html
##########################

cd /home/$USER
echo " "
echo " "
echo "------------"        
echo "Shall I build and install xinference docker? [Y,n]"    
read input
input=${input:-Y}
if [[ $input == "Y" || $input == "y" ]]; then
	# clone git repo
	git clone https://github.com/xorbitsai/inference.git
	cd inference
	echo "Building docker image...takes time...."
	sleep 3
	# Build docker image
	docker build --progress=plain -t test -f xinference/deploy/docker/Dockerfile .
	# Our cached models would be downloaded and stored here	
	mkdir /home/$USER/xmodels
	cd /home/$USER/inference/xinference/deploy/docker/
	# Run docker
	docker run --name xinference -d -p 9997:9997 -e XINFERENCE_HOME=/data -v /home/$USER/xmodels:/data \
	           --gpus all xprobe/xinference:latest xinference-local -H 0.0.0.0

    # Start script
    #--------------
    echo '#!/bin/bash'                                         >  /home/$USER/start_docker_xinference.sh
    echo " "                                                   >> /home/$USER/start_docker_xinference.sh
    echo "echo '======'"                                       >> /home/$USER/start_docker_xinference.sh
    echo "echo 'Access xinference, as: http://<hostIP>:9997'"  >> /home/$USER/start_docker_xinference.sh
    echo "echo 'Models are stored in folder ~/xmodels'"        >> /home/$USER/start_docker_xinference.sh
    echo "echo 'Even cached models must first be LAUNCHED to become available'"   >> /home/$USER/start_docker_xinference.sh
    echo "echo 'See file LLMs/xinference.ipynb'"             >> /home/$USER/start_docker_xinference.sh
    echo "echo '======'"                                       >> /home/$USER/start_docker_xinference.sh
    echo "sleep 5"                                             >> /home/$USER/start_docker_xinference.sh
    echo "cd /home/$USER/inference/xinference/deploy/docker/"  >> /home/$USER/start_docker_xinference.sh
    echo "docker start xinference"        			>> /home/$USER/start_docker_xinference.sh
    #
    #--------------
    echo '#!/bin/bash'                                         >  /home/$USER/launch_xinference.sh
    echo " "                                                   >> /home/$USER/launch_xinference.sh
    echo "Launching xinference bge-reranker-v2-m3"             >> /home/$USER/launch_xinference.sh
    echo "cd /home/$USER"                                     >> /home/$USER/launch_xinference.sh
    echo "source /home/$USER/venv/bin/activate"          >> /home/$USER/launch_xinference.sh
    echo "xinference launch --model-name bge-reranker-v2-m3 --model-type rerank --model-engine vllm --model-format pytorch --quantization none --replica 1 --gpu_memory_utilization 0.7 "     >> /home/$USER/launch_xinference.sh
    #    
    chmod +x *.sh
else
     echo "xinference will not be installed"
fi   




##########################
### Install xinference
# Ref: https://github.com/harnalashok/LLMs/blob/main/xinference.ipynb
##########################

cd /home/$USER
echo " "
echo " "
echo "------------"        
echo "Shall I install xinference? [Y,n]"    
read input
input=${input:-Y}
if [[ $input == "Y" || $input == "y" ]]; then
   source /home/$USER/venv/bin/activate
   pip install xllamacpp --force-reinstall --index-url https://xorbitsai.github.io/xllamacpp/whl/cu124 --extra-index-url https://pypi.org/simple
   sleep 3
   pip install "xinference[llama_cpp]"
   sleep 3
   pip install "xinference[vllm]"
   sleep 3
   pip install "xinference[transformers]"
   sleep 3
    # Start script
    #--------------
    echo '#!/bin/bash'                                         >  /home/$USER/start_xinference.sh
    echo " "                                                   >> /home/$USER/start_xinference.sh
    echo "echo '======'"                                       >> /home/$USER/start_xinference.sh
    echo "echo 'This terminal will remain engaged'"            >> /home/$USER/start_xinference.sh
    echo "echo 'Access xinference, as: http://<hostIP>:9997'"  >> /home/$USER/start_xinference.sh
    echo "echo 'Models are stored in folder ~/.xinference'"   >> /home/$USER/start_xinference.sh
    echo "echo 'Even cached models must first be LAUNCHED to become available'"   >> /home/$USER/start_xinference.sh
    echo "echo 'See file LLMs/xinference.ipynb'"             >> /home/$USER/start_xinference.sh
    echo "echo '======'"                                       >> /home/$USER/start_xinference.sh
    echo "sleep 5"                                             >> /home/$USER/start_xinference.sh
    echo "cd /home/$USER"                                     >> /home/$USER/start_xinference.sh
    echo "source /home/$USER/venv/bin/activate"          >> /home/$USER/start_xinference.sh
    echo "xinference-local --host 0.0.0.0 --port 9997"        >> /home/$USER/start_xinference.sh
    #
    #--------------
    echo '#!/bin/bash'                                         >  /home/$USER/launch_xinference.sh
    echo " "                                                   >> /home/$USER/launch_xinference.sh
    echo "Launching xinference bge-reranker-base"              >> /home/$USER/launch_xinference.sh
    echo "cd /home/$USER"                                     >> /home/$USER/launch_xinference.sh
    echo "source /home/$USER/venv/bin/activate"          >> /home/$USER/launch_xinference.sh
    echo "xinference launch --model-name bge-reranker-base --model-type rerank --model-engine vllm --model-format pytorch --quantization none --replica 1 --gpu_memory_utilization 0.7 "     >> /home/$USER/launch_xinference.sh
    #    
    chmod +x *.sh
else
     echo "xinference will not be installed"
fi   

##########################
### Install AutoGen Studio
# Ref: https://microsoft.github.io/autogen/stable/user-guide/autogenstudio-user-guide/index.html
# Video: https://www.youtube.com/watch?v=oum6EI7wohM
##########################

cd /home/$USER
echo " "
echo " "
echo "------------"        
echo "Shall I install AutoGen Studio? [Y,n]"    
read input
input=${input:-Y}
if [[ $input == "Y" || $input == "y" ]]; then
   source /home/$USER/venv/bin/activate
   pip install -U autogenstudio
   sleep 3
   # Start script
    #--------------
    echo '#!/bin/bash'                                         >  /home/$USER/start_autogenstudio.sh
    echo " "                                                   >> /home/$USER/start_autogenstudio.sh
    echo "echo '======'"                                       >> /home/$USER/start_autogenstudio.sh
    echo "echo 'This terminal will remain engaged'"            >> /home/$USER/start_autogenstudio.sh
    echo "echo 'Access AutoGen Studio, as: http://localhost:8081'"  >> /home/$USER/start_autogenstudio.sh
    echo "echo 'Project folder is: /home/$USER/autogenProject'"  >> /home/$USER/start_autogenstudio.sh
    echo "echo 'Delete earlier project folder as: rm -rf ~/autogenProject'"  >> /home/$USER/start_autogenstudio.sh
    echo "echo '======'"                                       >> /home/$USER/start_autogenstudio.sh
    echo "sleep 5"                                             >> /home/$USER/start_autogenstudio.sh
    echo "cd /home/$USER"                                      >> /home/$USER/start_autogenstudio.sh
    echo "source /home/$USER/venv/bin/activate"           >> /home/$USER/start_autogenstudio.sh
    echo "autogenstudio ui --host 127.0.0.1 --port 8081 --appdir ./autogenProject"       >> /home/$USER/start_autogenstudio.sh
    chmod +x *.sh
else
     echo "AutoGen Studio will not be installed!"
fi 

##########################
### Install Visual Studio Coder
### Only install it in Ubuntu and NOT in WSL 
##########################

echo " "
echo " "
echo "-----"
cd /home/$USER/
echo "Shall I install Visual Studio Coder (not installable on WSL)? [Y,n]"    
echo "It is NOT installable on WSL Windows. If you are in WSL environment, then answer n"
read input
input=${input:-Y}
if [[ $input == "Y" || $input == "y" ]]; then
    echo " "
    echo " "
    # Activate python virtual environment
    source /home/$USER/venv/bin/activate
    # 1.8 Install visual studio code
    # REf: https://code.visualstudio.com/docs/setup/linux#_debian-and-ubuntu-based-distributions
    mkdir /home/$USER/1234
    cd /home/$USER/1234
    # Direct download link
    wget -c 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
    # Fill in filename from above
    mv * code.deb
    sudo apt install /home/$USER/1234/code.deb  -y
    cd /home/$USER
    rm -rf /home/$USER/1234/
    #    
    sleep 5
    #
    # Deactivate the environment
    deactivate
else
    echo "OK. Visual code coder not installed."
fi    





##########################
### Install RAGflow
# Ref: https://github.com/infiniflow/ragflow
#      https://github.com/infiniflow/ragflow/issues/9866   
##########################

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
    echo "echo 'Check docker logs as: docker logs -f ragflow-server'" >> /home/$USER/start_ragflow.sh
    echo "echo 'Memory parameter: MEM_LIMIT is in ragflow/docker/.env file'" >> /home/$USER/start_ragflow.sh
    echo "echo '======'"                                       >> /home/$USER/start_ragflow.sh
    echo "sleep 4"                                             >> /home/$USER/start_ragflow.sh
    echo "cd /home/$USER/ragflow/docker"                        >> /home/$USER/start_ragflow.sh
    echo "docker compose -f docker-compose.yml up -d"       >> /home/$USER/start_ragflow.sh
    echo "netstat -aunt | grep 800"                             >> /home/$USER/start_ragflow.sh

    echo '#!/bin/bash'                                          > /home/$USER/volumes_ragflow.sh
    echo "echo 'RagFlow docker volumes'"                        > /home/$USER/volumes_ragflow.sh
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
    echo "docker logs -f ragflow-server"                       >> /home/$USER/logs_ragflow.sh


    echo '#!/bin/bash'                                          > /home/$USER/docker/del_rf_containers.sh
    echo "echo 'Will delete RagFlow dockers'"                  >> /home/$USER/docker/del_rf_containers.sh
    echo "echo 'Press ctrl+c to exit now'"                     >> /home/$USER/docker/del_rf_containers.sh
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
    echo "docker rm ragflow-server"                            >> /home/$USER/docker/del_rf_containers.sh
    #
    echo "echo '2.Deleting ragflow-mysql'"                     >> /home/$USER/docker/del_rf_containers.sh
    echo "docker rm ragflow-mysql"                             >> /home/$USER/docker/del_rf_containers.sh
    #
    echo "echo '3.Deleting ragflow-redis'"                      >> /home/$USER/docker/del_rf_containers.sh
    echo "docker rm ragflow-redis"                              >> /home/$USER/docker/del_rf_containers.sh
    #
    echo "echo '4.Deleting ragflow-minio'"                     >> /home/$USER/docker/del_rf_containers.sh
    echo "docker rm ragflow-minio"                             >> /home/$USER/docker/del_rf_containers.sh
    #
    echo "echo '5.Deleting ragflow-es-01'"                     >> /home/$USER/docker/del_rf_containers.sh
    echo "docker rm ragflow-es-01"                             >> /home/$USER/docker/del_rf_containers.sh
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
    cd /home/$USER/docker
    chmod +x *.sh
    cd /home/$USER
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
    #
    sudo sysctl -w vm.max_map_count=262144
    echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
    git clone https://github.com/infiniflow/ragflow.git
    
    cd ragflow/docker
    sed -i 's/SVR_WEB_HTTP_PORT=80/SVR_WEB_HTTP_PORT=800/' .env
    sed -i 's/SVR_WEB_HTTPS_PORT=443/SVR_WEB_HTTPS_PORT=1443/' .env
    #
    # Increase memory available for docker as files may be large (20gb)
    echo "Will now set memory for ragflow docker container. It should be large enough"
    sleep 4
    # Use GPU
    sed -i '1i DEVICE=gpu' .env
    # Change RAM available
    sed -i '/MEM_LIMIT=8073741824/c\MEM_LIMIT=20073741824' /home/$USER/ragflow/docker/.env
    docker compose -f docker-compose.yml up -d
    echo " "
    echo " "
    echo "==========="
    echo "Will Initialise ragflow. Use ctrl+c to break AFTER process has started."
    echo "==========="
    echo " "
    echo " "
    docker logs -f docker-ragflow-gpu-1
else
     echo "Ragflow will not be installed"
fi    
# Prevent docker restarts on OS reboot
docker update --restart=no $(docker ps -a -q)

 

