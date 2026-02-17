#!/bin/bash

# Last amended: 15th Feb, 2026

echo "========script=============="
echo "Will update Ubuntu and also install nodeJS"
echo "Will install cuda toolkit"
echo "Will install docker"
echo "Will install python venv"
echo "Install portainer"
echo "Will install flowise docker"
echo "Will install ollama docker for gpu"
echo "Will install milvus vector store"
echo "Will install meilisearch vector store"
echo "Will install chromadb docker"
echo "Will install n8n docker"
echo "Will install dify docker"
echo "Will install mongodb and mongosh:"
echo "Installs postgres db and pgvector"
echo "Installs xinference"
echo "Installs AutoGen Studio"
echo "Install latest anaconda"
echo "Install Visual Studio Coder"
echo "Install FAISS vector store"
echo "Install langchain+llamaIndex"
echo "Install Google antigravity"
echo "Install flatpak and JASP"
echo "TorchStudio installation for deeplearning"
echo "Install OpenNotebook"
echo "Install  to tunnel access of local website"
echo "Will install ragflow docker"
echo "Will upgrade ragflow"
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
	nvidia_driver_version=`modinfo nvidia | grep ^version`
    echo " Will update Ubuntu and also NVIDIA driver for GPU"                     
    echo " NVIDIA driver is: $nvidia_driver_version"
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
	# For reading markdown documents
	sudo apt install retext  -y
    # pipx to install poetry
    sudo apt install zip p7zip-full unzip net-tools cmake  build-essential python3-pip tilde curl git  python3-dev python3-venv gcc g++ make jq  openssh-server libfuse2 pipx -y  
    sudo apt -y install python3-pip python3-dev python3-venv gcc g++ make jq 
    sudo apt-get install python3-tk -y
    sudo apt-get install libssl-dev libcurl4-openssl-dev -y
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
	# I(nstall filezilla for ssh access to bridged network 
	sudo apt install filezilla -y
    # Download and run the setup script for the desired Node.js version (e.g., Node.js 22.x LTS)
    # Replace '22.x' with the desired major version if needed
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    # Now install Node.js and npm
    sudo apt install nodejs -y
	echo "NodeJS installed"
	echo " "
	sleep 3
	echo "Ubuntu is updated and NodeJS installed" > /home/$USER/ubuntu_updated.txt   # To avoid repeat updation
    # Download docker installation scripts
    wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/ubuntu_docker1.sh -P /home/$USER
    wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/ubuntu_docker2.sh -P /home/$USER
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
	now_nvidia_driver_version=`modinfo nvidia | grep ^version`
	# Folders for start/stop scripts
    mkdir /home/$USER/start
    mkdir /home/$USER/stop
	echo "  "
	echo "   "
	echo "Will install homebrew"
	sudo apt update
    sudo apt install build-essential procps curl file git
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$USER/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    echo " "
    echo " "
	echo "  "
	echo "===="
	# Install uv
	echo "===="
	echo "  "
	curl -LsSf https://astral.sh/uv/install.sh | sh
	sleep 3
	echo "====NOTE====="
	echo " NVIDIA driver ver was: $nvidia_driver_version"        
    echo " NVIDIA driver ver  is: $now_nvidia_driver_version"
	echo "==>> You may like to search for cuda-toolkit compatible with this driver ==<<"
    echo "Machine will be rebooted several times. After each reboot, execute the following script:"
	# Print IP of machine while opening terminal
	echo "hostname -I | awk '{print \$1}'  " >> /home/$USER/.bashrc
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
	nvidia-settings
	echo "https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=22.04&target_type=deb_local"
	echo "Archive: https://developer.nvidia.com/cuda-toolkit-archive"
    echo "cuda-toolkit does not change GPU drivers."
	echo "But higher versions of cuda-toolkit may have installation problems"
	echo "Shall I install NVIDIA Toolkit (cuda-13.0.1) for Ubuntu-22.04? [Y,n]" 
	read input
    input=${input:-Y}
    if [[ $input == "Y" || $input == "y" ]]; then
       # Remove old gpg key
        sudo apt-key del 7fa2af80
        # Now follow the instructions as on this page:
        #  https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=22.04&target_type=deb_local
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
		nvidia-settings
        sleep 8
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
    wget -Nc https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/docker/Understanding%20docker%20technology.pdf?raw=true
    wget -Nc https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/docker/docker%20commands.txt?raw=true
    wget -Nc https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/docker/dockers%20in%20brief.pdf?raw=true
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
		echo "####"
		echo "Install pdfminer to extract text from pdf"
		# Ref: https://github.com/pdfminer/pdfminer.six
		pip install pdfminer.six
		echo "####"
		echo "Install pymupdf4llm to extract text/json"
		# Ref: https://github.com/pymupdf/pymupdf4llm
	    pip install pymupdf4llm pymupdf4llm[layout]
		mkdir -p /home/$USER/Documents/samples/in
		mkdir -p /home/$USER/Documents/samples/out
		cd /home/$USER/Documents/samples
        wget -nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/misc/convert_pdf_to_text.py
		cd /home/$USER
		echo "####"
        # Create script to activate 'venv' env
        echo '#!/bin/bash'                                                        | tee   /home/$USER/activate_venv.sh
        echo "echo 'Execute this file as: source activate_venv.sh' "              | tee -a  /home/$USER/activate_venv.sh
        echo "echo 'To use or install any python package, first activate python venv as:' "        | tee -a  /home/$USER/activate_venv.sh
        echo "echo 'source /home/$USER/venv/bin/activate' "                       | tee -a  /home/$USER/activate_venv.sh
        echo "echo '(Note the change in prompt after activating)' "                | tee -a  /home/$USER/activate_venv.sh
        echo "echo '(To deactivate, just enter the command: deactivate)' "         | tee -a  /home/$USER/activate_venv.sh
        echo "source /home/$USER/venv/bin/activate"                                | tee -a  /home/$USER/activate_venv.sh
		# Download script to create python venv
		wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/quick_flowise_ollama/venv/create_python_venv.sh -P /home/$USER
	    chmod +x /home/$USER/*.sh
        sleep 2
      
        cp /home/$USER/activate_venv.sh  /home/$USER/start/activate_venv.sh
        cp /home/$USER/activate_venv.sh  /home/$USER/stop/activate_venv.sh
		reboot
     else
        echo "Python venv not installed"
     fi   
fi   

###########################
# Install latest anaconda
# https://askubuntu.com/a/841224
###########################

cd /home/$USER
DIRECTORY=/home/$USER/anaconda3
if [ ! -d "$DIRECTORY" ]; then
	if [ ! -f /home/$USER/anaconda_installed.txt ]; then
		echo " "
		echo " "
		echo "------------"        
		echo "To install Google Antigravity one does need anaconda"
		echo "Shall I latest anaconda? [Y,n]"    
		read input
		input=${input:-Y}
		if [[ $input == "Y" || $input == "y" ]]; then
		    DIRECTORY=/home/$USER/anaconda3          # Redundant
		    if [ ! -d "$DIRECTORY" ]; then
		        CONTREPO=https://repo.continuum.io/archive/
		        # Stepwise filtering of the html at $CONTREPO
		        # Get the topmost line that matches our requirements, extract the file name.
		        ANACONDAURL=$(wget -q -O - $CONTREPO index.html | grep "Anaconda3-" | grep "Linux" | grep "86_64" | head -n 1 | cut -d \" -f 2)
		        wget -O /home/$USER/Downloads/anaconda.sh $CONTREPO$ANACONDAURL
		        bash /home/$USER/Downloads/anaconda.sh -b -p $HOME/anaconda3
		        rm /home/$USER/Downloads/anaconda.sh
		        echo 'export PATH="/home/$USER/anaconda3/bin:$PATH"' >> /home/$USER/.bashrc 
	            # Accept terms of service of conda channels
				# Refer: StackOverflow: https://stackoverflow.com/a/79702898
				conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main \
	               && conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
		        # Reload default profile
		        source /home/$USER/.bashrc
		        conda update conda -y
				# Download script to create conda venv
			    wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/quick_flowise_ollama/venv/create_conda_venv.sh -P /home/$USER
		        chmod +x *.sh  
				echo "anaconda_installed.txt" > /home/$USER/anaconda_installed.txt
				chmod +x /home/$USER/*.sh
				chmod +x /home/$USER/start/*.sh
				chmod +x /home/$USER/stop/*.sh
				reboot
		     else
		        echo "Anaconda is already installed in /home/$USER/anaconda3"
		     fi   
		 else
		    echo "Anaconda not installed"
		 fi
	 fi
fi	 


###############
# Milvus install
# Webui avaiable at: http://localhost:9091/webui
# Ref: https://milvus.io/docs/install_standalone-docker.md
################
echo "  "
echo "   "
cd /home/$USER/
if [ ! -f /home/$USER/milvus_installed.txt ]; then
	echo " "
	echo " "
	echo "------------"        
	echo "Shall I install milvus docker? [Y,n]"    # Else docker milvus may be installed
	read input
	input=${input:-Y}
	if [[ $input == "Y" || $input == "y" ]]; then
	    echo "====  "    
		echo "Installing milvus vector database using docker"       
		echo "You may be asked for the password. Supply it..."     
		echo "====  "                                                   
		sleep 3
		curl -sfL https://raw.githubusercontent.com/milvus-io/milvus/master/scripts/standalone_embed.sh -o standalone_embed.sh
		bash standalone_embed.sh start
		echo " "
		echo "Milvus vector database installed"                      
		echo "Ports used are: 9091 and 19530."                       
		echo "To restart/stop docker use the following commands:"            
		echo "     sudo bash standalone_embed.sh restart|start|stop|upgrade|delete"                      
		mkdir /home/$USER/milvus
		mv standalone_embed.sh /home/$USER/milvus/
		echo 'export PATH="$PATH:/home/$USER/milvus/"' >> /home/$USER/.bashrc
		# Our milvus start script		
		echo '#!/bin/bash'                                         | tee    /home/$USER/start/start_milvus.sh
		echo " "                                                   | tee -a /home/$USER/start/start_milvus.sh
		echo "cd ~/"                                               | tee -a /home/$USER/start/start_milvus.sh
		echo "echo 'Ports are: 9091 and 19530.'"                   | tee -a /home/$USER/start/start_milvus.sh
		echo "echo 'Data is in /home/$USER/volumes/milvus/'"                   | tee -a /home/$USER/start/start_milvus.sh
		echo "echo 'Access in flowise as: http://<hostIP>:19530.'"           | tee -a /home/$USER/start/start_milvus.sh
		echo "cd /home/$USER/milvus"                               | tee -a /home/$USER/start/start_milvus.sh
		echo "bash standalone_embed.sh start"                      | tee -a /home/$USER/start/start_milvus.sh
		echo "cd /home/$USER"                                       | tee -a /home/$USER/stop/start_milvus.sh 
		echo "netstat -aunt | grep 19530"                          | tee -a /home/$USER/start/start_milvus.sh
		# Stop script		
		echo '#!/bin/bash'                                         | tee    /home/$USER/stop/stop_milvus.sh 
		echo " "                                                   | tee -a /home/$USER/stop/stop_milvus.sh 
		echo "cd ~/"                                               | tee -a /home/$USER/stop/stop_milvus.sh 
		echo "cd /home/$USER/milvus"                               | tee -a /home/$USER/stop/stop_milvus.sh 
		echo "sudo bash standalone_embed.sh stop"                  | tee -a /home/$USER/stop/stop_milvus.sh 
		echo "cd /home/$USER"                                      | tee -a /home/$USER/stop/stop_milvus.sh 
		echo "netstat -aunt | grep 19530"                           | tee -a /home/$USER/stop/stop_milvus.sh 
		#
		# Delete milvus database as also the container
		echo "cd /home/$USER/milvus"                            > /home/$USER/start/delete_milvus_db.sh
		echo "echo 'Will delete milvus database'"              >> /home/$USER/start/delete_milvus_db.sh 
		echo "echo 'Data is in /home/$USER/volumes/milvus/'"   >> /home/$USER/start/delete_milvus_db.sh
		echo "sleep 5"                                         >> /home/$USER/start/delete_milvus_db.sh
		echo "sudo bash standalone_embed.sh delete"             >> /home/$USER/start/delete_milvus_db.sh
        #
        ln -sT /home/$USER/start/start_milvus.sh       /home/$USER/start_milvus.sh  
		ln -sT /home/$USER/stop/stop_milvus.sh        /home/$USER/stop_milvus.sh  
		ln -sT /home/$USER/start/delete_milvus_db.sh   /home/$USER/delete_milvus_db.sh  
		#
		echo "milvus_installed.txt" > /home/$USER/milvus_installed.txt
		chmod +x /home/$USER/*.sh
		chmod +x /home/$USER/start/*.sh
		chmod +x /home/$USER/stop/*.sh
		sleep 3
		reboot
	else
		echo "Milvus db not installed"
	fi
	echo "Milvus db is installed"
fi	

chmod +x /home/$USER/*.sh
chmod +x /home/$USER/start/*.sh
chmod +x /home/$USER/stop/*.sh

###############
# Meilisearch install
# Ref: https://www.meilisearch.com/docs/guides/docker
################

echo "  "
echo "   "
cd /home/$USER/
if [ ! -f /home/$USER/meilisearch_installed.txt ]; then
	echo " "
	echo " "
	echo "------------"        
	echo "Shall I install meilisearch docker? [Y,n]"    # Else docker milvus may be installed
	read input
	input=${input:-Y}
	if [[ $input == "Y" || $input == "y" ]]; then
	    echo "====  "    
		echo "Installing meilisearch vector database using docker"       
		echo "You may be asked for the password. Supply it..."     
		echo "====  "                                                   
		sleep 3
		echo "Installing mellisearch vector database using docker"       
		docker pull getmeili/meilisearch:latest
		docker run -d --rm \
		           -p 7700:7700 \
		           -v $(pwd)/meili_data:/meili_data \
		             getmeili/meilisearch:latest
		echo "Mellisearch installed"
		echo '#!/bin/bash'                                         | tee    /home/$USER/start/start_meilisearch.sh
		echo " "                                                   | tee -a /home/$USER/start/start_meilisearch.sh
		echo "cd ~/"                                               | tee -a /home/$USER/start/start_meilisearch.sh
		echo "echo ' '"                                            | tee -a /home/$USER/start/start_meilisearch.sh  
		echo "echo '=====Useful info========'"                     | tee -a /home/$USER/start/start_meilisearch.sh  
		echo "echo 'Port is: 7700'"                                | tee -a /home/$USER/start/start_meilisearch.sh
		echo "echo 'Data folder is: /home/$USER/meili_data'"       | tee -a /home/$USER/start/start_meilisearch.sh
		echo "echo 'Access in flowise as: http://<hostIP>:7700'"   | tee -a /home/$USER/start/start_meilisearch.sh
		echo "echo 'Press ctrl+c to terminate'"                    | tee -a /home/$USER/start/start_meilisearch.sh  
		echo "echo '================='"                            | tee -a /home/$USER/start/start_meilisearch.sh  
		echo "sleep 4"                                             | tee -a /home/$USER/start/start_meilisearch.sh  
		echo "docker run -d --rm -p 7700:7700 -v $(pwd)/meili_data:/meili_data   getmeili/meilisearch:latest"  | tee  -a  /home/$USER/start/start_meilisearch.sh
		ln -sT /home/$USER/start/start_meilisearch.sh    /home/$USER/start_meilisearch.sh 
		echo "meilisearch_installed.txt"   >   meilisearch_installed.txt
		chmod +x /home/$USER/*.sh
		chmod +x /home/$USER/start/*.sh
		chmod +x /home/$USER/stop/*.sh
		sleep 3
		reboot
    else
	    echo "Meilisearch not installedd"
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
		echo "chromadb_installed" > /home/$USER/chromadb_installed.txt
		chmod +x /home/$USER/*.sh
		chmod +x /home/$USER/start/*.sh
		chmod +x /home/$USER/stop/*.sh
	    sleep 3
		reboot
	else
	    echo "Skipping install of chromadb docker"
	fi   
fi

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
		echo "n8n_installed" > /home/$USER/n8n_installed.txt
		chmod +x /home/$USER/*.sh
		chmod +x /home/$USER/start/*.sh
		chmod +x /home/$USER/stop/*.sh
		sleep 3
		reboot
	else
	    echo "n8n docker will not be installed"
	fi
fi





##########################
### ollama docker
##########################

echo " "
echo " "
cd /home/$USER
if [ ! -f /home/$USER/ollama_installed.txt ]; then
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
		  echo "echo '    Get your IP as:'"                                                                         >> /home/$USER/start_ollama.sh
		  echo "echo '         hostname -I'"                                                                        >> /home/$USER/start_ollama.sh
		  echo "echo '    Your IP is:' "                                   										    >> /home/$USER/start_ollama.sh
		  echo "hostname -I | awk ' {print \$1 } '"                  												>> /home/$USER/start_ollama.sh
		  echo "echo '========'"                                                                                    >> /home/$USER/start_ollama.sh
		  echo " "                                                                                                  >> /home/$USER/start_ollama.sh
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
		  echo "docker start ollama"                          >> /home/$USER/.bashrc
		  echo "echo 'Ollama docker started'"                  >> /home/$USER/.bashrc
	      #docker run -d --gpus=all -v /home/$USER/ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
	      # network host would be local mashine
	      docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --network host --name ollama ollama/ollama
		  echo "ollama_installed" > /home/$USER/ollama_installed.txt
		  sleep 4
	      chmod +x /home/$USER/*.sh
		  chmod +x /home/$USER/start/*.sh
		  chmod +x /home/$USER/stop/*.sh
		  sleep 3
		  reboot
	else
	        echo "Skipping install of ollama docker"
	fi
fi


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
		  echo "Pulling bge-m3"
	      docker exec -it ollama ollama pull bge-m3
		  echo "Pulling llama3.2"
		  docker exec -it ollama ollama pull llama3.2:latest
		  echo " "
		  echo " "
		  #ollama list
		  mkdir -p /home/$USER/Documents/huggingface
		  cd /home/$USER/Documents/huggingface
		  wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/huggingface/huggingfaceAcessToken.pdf
		  mv 'Huggingface access token.pdf' Huggingface_access_token.pdf
		  cd /home/$USER/
		  echo "models installed" > /home/$USER/models_installed.txt
	else
	        echo "Skipping download of ollama models"
	fi
fi

chmod +x /home/$USER/*.sh

#####################3
# flowise docker
# Ref: https://docs.flowiseai.com/getting-started#docker-compose
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
       echo "echo '==**====**====='"                                      >> /home/$USER/start_flowise.sh
       echo "echo 'For uniformity, keep userid and passwd as follows:'"   >> /home/$USER/start_flowise.sh
	   echo "echo '   Adm name:   ashok'"             >> /home/$USER/start_flowise.sh
       echo "echo '   userid:     ashok@fsm.ac.in'"   >> /home/$USER/start_flowise.sh
       echo "echo '   password:   Ashok@12345'"       >> /home/$USER/start_flowise.sh
       echo "echo '==**====**====='"                                      >> /home/$USER/start_flowise.sh
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
       echo "echo '==**====**====='"                              >> /home/$USER/reset_flowise.sh
       echo "echo 'For uniformity, keep userid and passwd as follows:'"   >> /home/$USER/reset_flowise.sh
       echo "echo '   Adm name:   ashok'"                          >> /home/$USER/reset_flowise.sh
       echo "echo '   userid:     ashok@fsm.ac.in'"                >> /home/$USER/reset_flowise.sh
       echo "echo '   password:   Ashok@12345'"                    >> /home/$USER/reset_flowise.sh
       echo "echo '==**====**====='"                               >> /home/$USER/reset_flowise.sh
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
	   #sudo docker build --no-cache -t flowise .
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
	   ln -sT /home/$USER/stop_docker_flowise.sh /home/$USER/stop_flowise.sh
	   mkdir -p /home/$USER/Documents/flowise
	   cd /home/$USER/Documents/flowise
	   wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/flowise/DesignChatflowsWithFlowise.pdf
	   wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/huggingface/huggingfaceAcessToken.pdf
	   cd /home/$USER
	   echo "flowise installed" > /home/$USER/flowise_installed.txt
	   chmod +x /home/$USER/*.sh
	   sleep 2
	   reboot
	 else
	   echo "Flowise docker will not be installed"
	 fi  
	  echo "Flowise docker already installed"
 fi

chmod +x /home/$USER/*.sh


################
# Install postgresql and sqlite3
# https://stackoverflow.com/questions/18223665/postgresql-query-from-bash-script-as-database-user-postgres
################

echo " "
echo " "
cd /home/$USER
if [ ! -f /home/$USER/postgresql_installed.txt ]; then
	echo "------------"   
	echo "Shall I install postgres db and pgvector? [Y,n]"    # 
	read input
	input=${input:-Y}
	if [[ $input == "Y" || $input == "y" ]]; then
	  	# Install postgresql
	    cd /home/$USER/
	    echo "Installing postgresql and sqlite3"
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

		# Download RAG data files
        mkdir -p /home/$USER/Documents/data
        cd /home/$USER/Documents/data
        wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/essays/bertrandRusselEssays.txt
        wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/essays/goodWriting.txt
        wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/essays/iWorkedOnEssay.txt
        wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/essays/sherlockHolmes.txt
        wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/essays/slyFox.txt
        wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/essays/threewishes.txt
        cd /home/$USER
		echo "postgresql installed" > /home/$USER/postgresql_installed.txt
		chmod +x /home/$USER/*.sh
		chmod +x /home/$USER/start/*.sh
		chmod +x /home/$USER/stop/*.sh
		sleep 3
		reboot
	 else
	   echo "Postgres not installed"
	 fi  
 fi

 ##########################
### Install Visual Studio Coder
### Only install it in Ubuntu and NOT in WSL 
##########################

echo " "
echo " "
echo "-----"
cd /home/$USER
if [ ! -f /home/$USER/vscode_installed.txt ]; then
    echo " "
    echo " "
	echo "------------"  
	echo "Shall I install Visual Studio Coder (not installable on WSL)? [Y,n]"    
	echo "It is NOT installable on WSL Windows. For WSL environment answer no"
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
	    wget -Nc 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
	    # Fill in filename from above
	    mv * code.deb
	    sudo apt install /home/$USER/1234/code.deb  -y
	    cd /home/$USER
	    rm -rf /home/$USER/1234/
		mkdir /home/$USER/Documents/vscode
		cd /home/$USER/Documents/vscode
		wget -Nc https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/quick_flowise_ollama/venv/vscode_help.pdf
		echo "vscode_installed" > /home/$USER/vscode_installed.txt
	    #    
	    sleep 5
	    #
	    # Deactivate the environment
	    deactivate
		echo "Will reboot system now"
		sleep 5
		reboot
	else
	    echo "OK. Visual Studio coder not installed."
	fi 
fi

chmod +x /home/$USER/*.sh
chmod +x /home/$USER/start/*.sh
chmod +x /home/$USER/stop/*.sh


#####################
## langflow install
####################

echo " "
echo " "
echo "-----"
cd /home/$USER
if [ ! -f /home/$USER/langflow_installed.txt ]; then
    echo " "
    echo " "
	echo "------------"  
	echo "Shall I install langflow? [Y,n]"    
	read input
	input=${input:-Y}
	if [[ $input == "Y" || $input == "y" ]]; then
	    echo " "
	    echo " "
		# Install langflow
		echo " "                                      
		echo "Installing langflow...takes time ..."   
		echo "------"                                 
		echo " "                                      
		sleep 2
		# Create default .venv environment in the current folder
		# Existing environment is first deleted
		uv venv
		# Install in the default environment ie .venv
		uv pip install langflow  2>> /home/$USER/error.log
		sleep 2
		echo "  "                                    
		echo "  "                                    
		echo "langflow installed"                    
		echo "langflow installed"                    
		# https://docs.langflow.org/configuration-cli
		echo "Ref: https://docs.langflow.org/configuration-cli"     
		# 		
		echo '#!/bin/bash'                                         | tee    /home/$USER/start/start_uv_langflow.sh  
		echo " "                                                   | tee -a /home/$USER/start/start_uv_langflow.sh  
		echo "cd ~/"                                               | tee -a /home/$USER/start/start_uv_langflow.sh  
        echo "echo 'Run following command to get langflow CLI options:'"    | tee -a /home/$USER/start/start_uv_langflow.sh  
		echo "echo '        uv run langflow'"                               | tee -a /home/$USER/start/start_uv_langflow.sh  
		echo "echo 'Generate api-key, as: '"                                | tee -a /home/$USER/start/start_uv_langflow.sh  
		echo "echo '        uv run langflow api-key'"                       | tee -a /home/$USER/start/start_uv_langflow.sh  
		echo "echo 'Run langflow, as: '"                                     | tee -a /home/$USER/start/start_uv_langflow.sh  
		echo "echo '        uv run langflow run'"                           | tee -a /home/$USER/start/start_uv_langflow.sh  
		echo "echo '---------- '"                                           | tee -a /home/$USER/start/start_uv_langflow.sh  
		echo "  "                                                      		| tee -a /home/$USER/start/start_uv_langflow.sh  
		echo "echo 'Langflow will be available at port 7860'"     		     | tee -a /home/$USER/start/start_uv_langflow.sh  
		echo "echo 'deactivate venv with, deactivate, command'"    			| tee -a /home/$USER/start/start_uv_langflow.sh  
		echo "source .venv/bin/activate"                           			| tee -a /home/$USER/start/start_uv_langflow.sh  
		echo "uv run langflow run"                                 			| tee -a /home/$USER/start/start_uv_langflow.sh  
		echo "netstat -aunt | grep 7860"                           			| tee -a /home/$USER/start/start_uv_langflow.sh  
		chmod +x /home/$USER/*.sh
		chmod +x /home/$USER/start/*.sh
		chmod +x /home/$USER/stop/*.sh
		sleep 2
		reboot
	else
		echo "langflow NOT installed"
	fi
fi	


#################
# langchain & langraph
#################
echo " "
echo " "
echo "-----"
cd /home/$USER
if [ ! -f /home/$USER/langchain_installed.txt ]; then
    echo " "
    echo " "
	echo "------------"  
	echo "Shall I install langchain and llamaindex? [Y,n]"    
	read input
	input=${input:-Y}
	if [[ $input == "Y" || $input == "y" ]]; then
		# Activate python environment at 'langchain'
		#  for installing langchain and llama-index
		##############
		# Create python virtual env
		##############
		python3 -m venv /home/$USER/langchain
		source /home/$USER/langchain/bin/activate
		# 1.6 Essentials software
		pip install spyder numpy scipy pandas matplotlib sympy cython
		pip install jupyterlab
		pip install ipython
		pip install notebook
		pip install streamlit
		# Required for spyder:
		sudo apt install pyqt5-dev-tools -y
		# Huggingface and llama.cpp related
		pip install huggingface_hub
		# Create script to activate 'langchain' env
		echo "echo 'To activate langchain+llamaIndex virtual envs, activate as:' "  > /home/$USER/activate_langchain_venv.sh
		echo "echo 'source /home/$USER/langchain/bin/activate' "                   >>  /home/$USER/activate_langchain_venv.sh
		echo "echo '(Note the change in prompt after activating)' "                >>  /home/$USER/activate_langchain_venv.sh
		echo "echo '(To deactivate, just enter the command: deactivate)' "         >>  /home/$USER/activate_langchain_venv.sh
		echo "source /home/$USER/langchain/bin/activate"                           >>  /home/$USER/activate_langchain_venv.sh
		chmod +x /home/$USER/*.sh
		sleep 2
		cp /home/$USER/activate_langchain_venv.sh  /home/$USER/start/activate_langchain_venv.sh
		cp /home/$USER/activate_langchain_venv.sh  /home/$USER/stop/activate_langchain_venv.sh
		source /home/$USER/langchain/bin/activate
		pip install langchain
		pip install langchain-openai
		pip install langchain-community
		pip install langchain-experimental
		pip install langgraph
		pip install "langserve[all]"
		pip install langchain-cli
		#################
		# llamaindex
		# To be installed ONLY in langchain virtual env
		#################
		# 1.0 LLamaindex install
		# Mostly openai related
		echo "Installing llama-index"
		echo "  "
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
		# Download llamaindex tutorials
		mkdir -p /home/$USER/Documents/llamaindex
		cd /home/$USER/Documents/llamaindex
		wget -nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/llamaindex/llamaindex_fundamentals.ipynb
		wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/llamaindex/1_basic_agent.py
		wget -nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/llamaindex/L0_simple_csv_moodle-expt.ipynb
		wget -nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/llamaindex/L0_simple_skill_gap.ipynb
		wget -nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/llamaindex/L1_Router_Engine.ipynb
		wget -nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/llamaindex/L2_Tool_Calling.ipynb
		wget -nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/llamaindex/L3_Building_an_Agent_Reasoning_Loop.ipynb
		wget -nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/llamaindex/L4_Building_a_Multi-Document_Agent.ipynb
		echo "langchain_installed.txt" > /home/$USER/langchain_installed.txt
		sleep 3
		chmod +x /home/$USER/*.sh
		chmod +x /home/$USER/start/*.sh
		chmod +x /home/$USER/stop/*.sh
		reboot
	else
		echo "Langchain and llama index not installed"
	fi		
fi	


##########################
### Install FAISS library
##########################

echo " "
echo " "
echo "-----"
cd /home/$USER
if [ ! -f /home/$USER/faiss_installed.txt ]; then
    echo " "
    echo " "
	echo "------------"  
	echo "Shall I install FAISS vector store? [Y,n]"    
	read input
	input=${input:-Y}
	if [[ $input == "Y" || $input == "y" ]]; then
		echo " "
		echo "============"
		echo "While using flowise, the 'Base Path to Load' which needs to be spcified"
		echo "is of the folder where data files will be saved. Consider this as the "
		echo "location of FAISS database for that application."
		echo "=============="
		echo " "
		sleep 8
		# Create venv for FAISS
		python3 -m venv /home/$USER/faiss
		source /home/$USER/faiss/bin/activate
		pip3 install faiss-cpu
		deactivate
		## Script to activate FAISS library
		echo '#!/bin/bash'                                                      > /home/$USER/start/activate_faiss.sh
		echo " "                                                                >> /home/$USER/start/activate_faiss.sh
		echo "cd ~/"                                                            >> /home/$USER/start/activate_faiss.sh
		echo "echo 'Activate FAISS library, as:'"                                >> /home/$USER/start/activate_faiss.sh                           
		echo "echo 'source /home/$USER/start/activate_faiss.sh'"                 >> /home/$USER/start/activate_faiss.sh
		echo "echo 'To deactivate issue just the command: deactivate'"           >> /home/$USER/start/activate_faiss.sh
		echo "source /home/$USER/faiss/bin/activate"                             >> /home/$USER/start/activate_faiss.sh
		deactivate
		echo "FAISS library installed at /home/$USER/faiss/"
		echo "FAISS stores its data files 'docstore.json' and 'faiss.index' here."
		# FAISS download data-cleaning script
		cd /home/$USER/
		wget -nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/faiss/empty_faiss_database.sh
		chmod +x *.sh
		chmod +x /home/$USER/start/*.sh
		echo "faiss_installed.txt" > /home/$USER/faiss_installed.txt
		sleep 4
		reboot
	else
		echo "FAISS not installed"
	fi	
fi


##########################
### Install OpenNotebook
# Ref: https://github.com/lfnovo/open-notebook/blob/main/docs/1-INSTALLATION/docker-compose.md
##########################

echo " "
echo " "
cd /home/$USER
if [ ! -f /home/$USER/opennotebook_installed.txt ]; then
    echo " "
    echo " "
	echo "------------"   
	echo "Shall I install OpenNotebook docker? [Y,n]"    # 
	read input
	input=${input:-Y}
	if [[ $input == "Y" || $input == "y" ]]; then
	    echo " "
	    echo " "
		mkdir /home/$USER/opennotebook
		cd /home/$USER/opennotebook
		wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/opennotebook/docker-compose.yml
		docker compose up -d
		sleep 4
		echo "  "
		echo "  "
		# Check health of system
		echo " ==== "
		echo "Checking health of installed system"
		curl http://localhost:5055/health
		echo " ==== "
		echo  "  "
		echo  "  "
		echo "Open browser to: http://localhost:8502"
		sleep 4
		echo "opennotebook_installed.txt" > /home/$USER/opennotebook_installed.txt
		cd /home/$USER
		sleep 3
		reboot
	else
	    echo "OpenNotebook not installed"
	fi
fi


###########################
# Install Google Antigravity
#   Anaconda installation is a must
# https://askubuntu.com/a/841224
###########################

echo "  "
echo "  "
cd /home/$USER
# Install only if anaconda is installed:
if [  -f /home/$USER/anaconda_installed.txt ]; then
	if [ ! -f /home/$USER/antigravity_installed.txt ]; then
		echo "Shall I latest Google Antigravity? [Y,n]"    
		read input
		input=${input:-Y}
		if [[ $input == "Y" || $input == "y" ]]; then
			#  create a directory for keyrings
			sudo mkdir -p /etc/apt/keyrings
			# Download and add Google's signing key
			curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/antigravity-repo-key.gpg
			# Add the Antigravity repository to your sources list
			echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | sudo tee /etc/apt/sources.list.d/antigravity.list > /dev/null
			# Update your package cach
			sudo apt update -y
			# Install Google Antigravity
			sudo apt install antigravity
			sudo apt autoremove -y
			echo "antigravity_installed.txt" > /home/$USER/antigravity_installed.txt
			echo " "
			echo "  "
			echo "==========="
			echo "Google antigravity is installed"
			echo "It will now be available in Ubuntu Start/Application Menu"
			echo "You can also launch it by command: antigravity"
			echo "============"
			echo " "
			sleep 5
			reboot
		else	
			echo "Google antigravity not installed"
		fi	
	fi
fi


 
#####################3
# portrainer docker
######################

cd /home/$USER
echo " "
echo " "
cd /home/$USER
if [ ! -f /home/$USER/portainer_installed.txt ]; then
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
	   echo "portainer_installed.txt" > /home/$USER/portainer_installed.txt
	   reboot
	else
	   echo "Portainer not installed"
	fi 
fi
   


##########################
### Install ngrok 
#   ngrok helps in remotely accessing 
#     your local web-apps
#   Refer: What is ngrok:
#      https://ngrok.com/docs/what-is-ngrok
#      https://ngrok.com/docs/agent/cli
##########################

echo "ngrok is used to make local web-apps accessible remotely through tunneling"
cd /home/$USER
echo " "
echo " "
if [ ! -f /home/$USER/ngrok_installed.txt ]; then
	echo "------------"   
    echo "Shall I install ngrok to access web-app remotely ? [Y,n]"    
	read input
	input=${input:-Y}
	if [[ $input == "Y" || $input == "y" ]]; then
		# Install ngrok
		# https://dashboard.ngrok.com/get-started/setup/linux
		echo "Installing ngrok..."
		sleep 3
		curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
		  | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
		  && echo "deb https://ngrok-agent.s3.amazonaws.com bookworm main" \
		  | sudo tee /etc/apt/sources.list.d/ngrok.list \
		  && sudo apt update \
		  && sudo apt install ngrok
		echo " "
		echo "======"
		echo "ngrok is installed. Next use: ./ngrok_config.sh"
		echo "======"
		sleep 4
		# Run the following command to add your authtoken to the default ngrok.yml configuration file.
		echo "echo '========'"  >  /home/$USER/ngrok_config.sh
		echo "echo 'You will have to amend config file: ngrok.yml'"                 >> /home/$USER/ngrok_config.sh
		echo "echo 'and write your ngrok auth token there'"                         >> /home/$USER/ngrok_config.sh
		echo "echo 'Issue command: ngrok config add-authtoken <your ngrok token>'"  >> /home/$USER/ngrok_config.sh
		echo "echo 'Then, run the command: ngrok http 11434' "                      >> /home/$USER/ngrok_config.sh 
		echo "echo 'where, 11434, is your example web-app ip'"                      >> /home/$USER/ngrok_config.sh
		echo "echo 'This command, if successful, will also output'"                 >> /home/$USER/ngrok_config.sh
		echo "echo 'your public-ip from where remotely you can access youir local web-app'"  >> /home/$USER/ngrok_config.sh
		echo "echo 'ngrok ref: https://ngrok.com/docs/agent/cli'"                   >> /home/$USER/ngrok_config.sh
		echo "echo '========'"                                                      >> /home/$USER/ngrok_config.sh
		chmod +x *.sh
			# My remote url is:
		# https://connivently-unhusked-carri.ngrok-free.dev
		echo "ngrok_installed.txt" > /home/$USER/ngrok_installed.txt 
		sleep 2
		reboot
	else
	   echo "ngrok not installed"
	fi  
else
   echo "ngrok is installed"
fi


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
		reboot
    else
        echo "dify not installed"
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
   wget -Nc  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/datasets/catalog.books.json
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/datasets/credit_card_customers.json
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/datasets/howToImport.txt
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/datasets/primer-dataset.json
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/datasets/restaurant.json
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/datasets/students.json
   cd /home/$USER/Documents/mongodb
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/0.about%20json-0.txt
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/1.mongo_CRUD.txt
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/3.mongo_qyeryTextSearch.txt
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/4.fullTextSearch.txt
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/5.mongo_aggregationPipe.txt
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/7.mongo_backupRestore.txt
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/12.accessControl_class_mongo.txt
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
   wget -Nc  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/datasets/catalog.books.json
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/datasets/credit_card_customers.json
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/datasets/howToImport.txt
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/datasets/primer-dataset.json
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/datasets/restaurant.json
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/datasets/students.json
   cd /home/$USER/Documents/mongodb
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/0.about%20json-0.txt
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/1.mongo_CRUD.txt
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/3.mongo_qyeryTextSearch.txt
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/4.fullTextSearch.txt
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/5.mongo_aggregationPipe.txt
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/7.mongo_backupRestore.txt
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/mongodb/12.accessControl_class_mongo.txt
   sleep 2
   reboot
else
    echo "Mongodb for Ubuntu24.04 not installed"
fi   

# Prevent docker restarts on OS reboot
docker update --restart=no $(docker ps -a -q)


###################
# llama.cpp install--I
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
echo "NOTE: Recomended way to install is using homebrew. AVOID BUILDING"
echo "Shall I now BUILD AND install llama.cpp (if your CUDA version is correct)? [Y,n]"   
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
  echo 'export PATH="$PATH:/home/$USER/llama.cpp/build/bin"' >> /home/$USER/.bashrc
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
  wget -Nc https://huggingface.co/mradermacher/Llama-Thinker-3B-Preview-GGUF/resolve/main/Llama-Thinker-3B-Preview.Q8_0.gguf?download=true
  mv 'Llama-Thinker-3B-Preview.Q8_0.gguf?download=true'  llama-thinker-3b-preview.q8_0.gguf
  echo "Done...."
  cd /home/$USER
  echo "Will reboot system now"
  chmod +x /home/$USER/start/*.sh
  chmod +x /home/$USER/*.sh
  sleep 5
  reboot
else
  echo "Skipping install of llama.cpp"
fi
  

###################
# llama.cpp install--II
# python env remains activated
# source /home/$USER/venv/bin/activate
# https://github.com/ggml-org/llama.cpp/blob/master/docs/install.md
###################
echo "  "
echo " "
echo "Shall I now install llama.cpp using homebrew ? [Y,n]"   
	read input
	input=${input:-Y}
	if [[ $input == "Y" || $input == "y" ]]; then
	  # Installing llama.cpp
	  source /home/$USER/venv/bin/activate
	   # Huggingface and llama.cpp related
	  pip install huggingface_hub
	  pip install transformers
	  pip install accelerate
	  brew install llama.cpp
	  echo 'export PATH="/home/linuxbrew/.linuxbrew/Cellar/llama.cpp/8030/bin:$PATH"'  >> /home/$USER/.bashrc
	  echo "llama.cpp installed"
	  sleep 3
	  reboot
	else
	   echo "llama-cpp not installed"
	fi


##########################
### Build and Install xinference docker
# Ref: https://inference.readthedocs.io/en/latest/getting_started/using_docker_image.html
##########################

cd /home/$USER
if [ ! -f /home/$USER/xinference_installed.txt ]; then
	cd /home/$USER
	echo " "
	echo " "
	echo "------------"        
	echo "Shall I build and install xinference docker. Building takes time..? [Y,n]"    
	read input
	input=${input:-Y}
	if [[ $input == "Y" || $input == "y" ]]; then
		# clone git repo
		git clone https://github.com/xorbitsai/inference.git
		cd inference
		echo " "
		# Build docker image
		docker build --progress=plain -t test -f xinference/deploy/docker/Dockerfile .
		# Our models would be downloaded and cached here	
		mkdir /home/$USER/xmodels
		cd /home/$USER/inference/xinference/deploy/docker/
		# Run docker
		echo "  "
		echo "xinference installed" > /home/$USER/xinference_installed.txt
		echo "Starting docker at port 9997....."
		sleep 3
		docker run --name xinference -d \
		            -p 9997:9997 \
					-e XINFERENCE_HOME=/data -v /home/$USER/xmodels:/data \
		           --gpus all xprobe/xinference:latest xinference-local -H 0.0.0.0
	    #
	    # Start script
	    #--------------
	    echo '#!/bin/bash'                                         >  /home/$USER/start_xinference.sh
	    echo " "                                                   >> /home/$USER/start_xinference.sh
	    echo "echo '======'"                                       >> /home/$USER/start_xinference.sh
	    echo "echo 'Access xinference, as: http://<hostIP>:9997'"  >> /home/$USER/start_xinference.sh
	    echo "echo 'Models are stored in folder ~/xmodels'"        >> /home/$USER/start_xinference.sh
	    echo "echo 'Even cached models must first be LAUNCHED to become available'"   >> /home/$USER/start_xinference.sh
	    echo "echo 'To download and LAUNCH a model use: '"         >> /home/$USER/start_xinference.sh
		echo "echo '  ./launch_xinference_model.sh ' "             >> /home/$USER/start_xinference.sh
		echo "echo 'See file LLMs/xinference.ipynb'"               >> /home/$USER/start_xinference.sh
	    echo "echo '======'"                                       >> /home/$USER/start_xinference.sh
	    echo "sleep 5"                                             >> /home/$USER/start_xinference.sh
	    echo "cd /home/$USER/inference/xinference/deploy/docker/"  >> /home/$USER/start_xinference.sh
	    echo "docker start xinference"        						>> /home/$USER/start_xinference.sh
	    #
        #
	    # Model launch script
	    #--------------
	    echo '#!/bin/bash'                                         >  /home/$USER/launch_xinference_model.sh
	    echo " "                                                   >> /home/$USER/launch_xinference_model.sh
	    echo "echo '======'"                                       >> /home/$USER/launch_xinference_model.sh
	    echo "echo 'Will download and launch bge-reranker-v2-m3'"  >> /home/$USER/launch_xinference_model.sh
	    echo "echo 'Models are cached in folder ~/xmodels'"        >> /home/$USER/launch_xinference_model.sh
	    echo "echo 'Even cached models must first be LAUNCHED to become available'"   >> /home/$USER/launch_xinference_model.sh
		echo "echo '=**=>Edit model name and type in this script to launch another model<=**='"  >> /home/$USER/launch_xinference_model.sh
	    echo "echo '======'"                                       >> /home/$USER/launch_xinference_model.sh
	    echo "sleep 5"                                             >> /home/$USER/launch_xinference_model.sh
	    echo "docker exec -it   xinference  xinference launch --model-name bge-reranker-v2-m3 --model-type rerank --model-engine vllm --model-format pytorch --quantization none --replica 1 --gpu_memory_utilization 0.7 "  	>> /home/$USER/launch_xinference_model.sh
		echo "echo '  '"                                       >> /home/$USER/launch_xinference_model.sh
		echo "echo '  '"                                       >> /home/$USER/launch_xinference_model.sh
		echo "echo '#Run following command to download qwen3'" >> /home/$USER/launch_xinference_model.sh
		echo "echo '#Following requires large CUDA memory.'"   >> /home/$USER/launch_xinference_model.sh
		echo "#docker exec -it   xinference  xinference launch --model-name qwen3 --model-type LLM --model-engine vllm --model-format ggufv2 --size-in-billions 8 --quantization Q4_K_M --replica 1 --gpu_memory_utilization 0.7 "  	>> /home/$USER/launch_xinference_model.sh
		echo "#docker exec -it   xinference  xinference launch --model-name qwen3 --model-type LLM --model-engine transformers --model-format pytorch --size-in-billions 8 --replica 1 --gpu_memory_utilization 0.7 "  	>> /home/$USER/launch_xinference_model.sh
		echo "echo 'List of launched models'"                  >> /home/$USER/launch_xinference_model.sh
		echo "docker exec -it   xinference  xinference list"   >> /home/$USER/launch_xinference_model.sh
	    chmod +x *.sh
		echo "xinference installed" > /home/$USER/xinference_installed.txt
		echo "Will reboot system now"
	    sleep 5
		reboot
	else
	     echo "xinference will not be installed"
	fi   

	
	##########################
	### Install xinference on machine
	# Ref: https://github.com/harnalashok/LLMs/blob/main/xinference.ipynb
	##########################
	
	cd /home/$USER
	echo " "
	echo " "
	echo "------------"        
	echo "Shall I install xinference on machine? [Y,n]"    
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
	   echo "xinference installed" > /home/$USER/xinference_installed.txt
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
	    echo "Launching xinference bge-reranker-v2-m3"              >> /home/$USER/launch_xinference.sh
	    echo "cd /home/$USER"                                     >> /home/$USER/launch_xinference.sh
	    echo "source /home/$USER/venv/bin/activate"          >> /home/$USER/launch_xinference.sh
	    echo "xinference launch --model-name bge-reranker-v2-m3 --model-type rerank --model-engine vllm --model-format pytorch --quantization none --replica 1 --gpu_memory_utilization 0.7 "     >> /home/$USER/launch_xinference.sh
	    #    
	    chmod +x *.sh
		echo "Will reboot system now"
	    sleep 5
		reboot
	else
	     echo "xinference will not be installed"
	fi   
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
	echo "Will reboot system now"
	sleep 5
	reboot
else
     echo "AutoGen Studio will not be installed!"
fi 


##########################
### Install flatpak and JASP
# Ref: https://jasp-stats.org/linux-installation-guide/
# JASP is biostatistics software    
##########################

cd /home/$USER
if [ ! -f /home/$USER/flatpak_installed.txt ]; then
    echo " "
    echo " "
	echo "------------"  
    echo "JASP is a biostatistics software? [Y,n]"
	echo "Shall I install flatpak for JASP and also JASP? [Y,n]"    
	read input
	input=${input:-Y}
	if [[ $input == "Y" || $input == "y" ]]; then
	    # Install flatpak
		sudo apt install flatpak -y
		# The GNOME Software plugin makes it possible to install apps without needing the command line. 
		sudo apt install gnome-software-plugin-flatpak -y
		# Add repo
		flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
		echo "Download and install JASP. Takes time..." 
	    flatpak install flathub org.jaspstats.JASP
	    echo "flatpak installed" > /home/$USER/flatpak_installed.txt
		echo "Run as: flatpak run org.jaspstats.JASP "  >> /home/$USER/flatpak_installed.txt
		echo '#!/bin/bash'                                          > /home/$USER/start_JSAP.sh
	    echo "echo 'Start JSAP as:'"                                >> /home/$USER/start_JSAP.sh
	    echo "echo 'flatpak run org.jaspstats.JASP'"                >> /home/$USER/start_JSAP.sh
		chmod +x *.sh
		echo "After rebooting, look for 'JASP App' in Show Applications to put it in Favourites ribbon" 
		sleep 5
		reboot
	else
	  echo "flatpak not installed"
	fi
fi

##########################
### Install torchstudio
# Ref: https://github.com/Emad2018/torchstudio/tree/main
#      https://www.torchstudio.ai/download/
##########################

cd /home/$USER
if [ ! -f /home/$USER/torchstudio_installed.txt ]; then
    echo " "
    echo " "
	echo "------------"  
    echo "TorchStudio is a software for deeplearning?"
	echo "Anaconda must have been installed earlier"
	echo "Shall I install torchstudio? [Y,n]"    
	read input
	input=${input:-Y}
	if [[ $input == "Y" || $input == "y" ]]; then
	    # Install necessary packages
		git clone https://github.com/Emad2018/torchstudio.git
		cd torchstudio
	    conda env create -f environment.yml
		#
		sudo apt-get install graphviz
	    wget -Nc https://github.com/TorchStudio/torchstudio/releases/download/0.9.19/TorchStudio_0.9.19-Linux_Installer.deb
		sudo dpkg -i  TorchStudio_0.9.19-Linux_Installer.deb
		rm TorchStudio_0.9.19-Linux_Installer.deb
		echo " "
		echo "======"
		echo "TorchStudio installed. You can now put its icon in favourites ribbon"
		echo "======"
		echo "  "
		sleep 5
		cd /home/$USER/Documents
		wget -Nc https://gist.githubusercontent.com/netj/8836201/raw/6f9306ad21398ea43cba4f7d537619d0e07d5ae3/iris.csv
		cd /home/$USER
		echo "To run torchstudio:"
		echo "    Select python interpretur at directory: /anaconda3/envs/TorchStudio/bin/python"
		echo "To run torchstudio:"    >                            /home/$USER/torchstudio_installed.txt 
		echo "    Select python interpretur at directory: /anaconda3/envs/TorchStudio/bin/python"   >> /home/$USER/torchstudio_installed.txt 
        echo '#!/bin/bash'                                          > /home/$USER/start_torchstudio.sh
	    echo "echo 'To run torchstudio:'"                           >> /home/$USER/start_torchstudio.sh
		echo "echo ' First, start TorchStudio and then,'"                           >> /home/$USER/start_torchstudio.sh
	    echo "echo '   In the dialogbox, select python interpretur at directory: /anaconda3/envs/TorchStudio/bin/python'"    >> /home/$USER/start_torchstudio.sh
		chmod +x *.sh
		sleep 5
		reboot
	else
		   echo "TorchStudio not installed"
	fi   
fi

##########################
### Upgrade ragflow
# Ref: https://ragflow.io/docs/dev/upgrade_ragflow
##########################

echo " "
echo " "
cd /home/$USER
echo " "
echo " "
# Upgrade only if earlier ragflow was installed
cd /home/$USER
if [  -f /home/$USER/ragflow_installed.txt ]; then
	echo "======="
	echo "Shall I upgrade RAGFlow docker? [Y,n]"   
	echo "The upgarde does not touch your data files"
	echo "After upgrade, RESET your broswer cookies"
	echo "========"
	read input
	input=${input:-Y}
	if [[ $input == "Y" || $input == "y" ]]; then
		echo " "
		echo " "
		# Stop ragflow
		bash /home/$USER/stop_ragflow.sh
		sleep 2
		echo "1.0 Moving earlier ragflow folder"
		sudo rm -rf /home/$USER/ragflow.old
		mv /home/$USER/ragflow  /home/$USER/ragflow.old
		echo "2.0 Cloning git repo"
		git clone https://github.com/infiniflow/ragflow.git
		cd /home/$USER/ragflow
		# https://ragflow.io/docs/dev/upgrade_ragflow#upgrade-ragflow-to-the-most-recent-officially-published-release
		# Switch to the latest, officially published release, e.g., v0.23.1:
		echo "3.0 Will upgrade to ver 0.23.1"
		sleep 5
		# Switch working directory of git
		git checkout v0.23.1
		#
		# Update ragflow/docker/.env:
		cd /home/$USER/ragflow/docker
	    RAGFLOW_IMAGE=infiniflow/ragflow:v0.23.1
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
		# Update the RAGFlow image and restart RAGFlow:
		docker compose -f docker-compose.yml pull
	    docker compose -f docker-compose.yml up -d
		docker logs -f docker-ragflow-gpu-1
	else
	    echo "RagFlow Not upgraded"
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

 

