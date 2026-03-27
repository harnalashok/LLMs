#!/bin/bash

# Last amended: 24th March, 2026

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
echo "Install crawl4ai"
echo "Will install dify docker"
echo "Will install mongodb and mongosh:"
echo "Installs postgres db and pgvector"
echo "Installs xinference"
echo "Installs AutoGen Studio"
echo "Install latest anaconda"
echo "Install Visual Studio Coder"
echo "Install FAISS vector store"
echo "Install langchain+llamaIndex"
echo "Install llamaindex example files"
echo "Install agno"
echo "Install Google antigravity"
echo "Install rag and rag performance eval system"
echo "Install flatpak and JASP"
echo "TorchStudio installation for deeplearning"
echo "Install OpenNotebook"
echo "Install  to tunnel access of local website"
echo "Will install ragflow docker"
echo "Will upgrade ragflow"
echo "==========================="
sleep 2

FILE="/home/$USER/install_progerss.txt"
LINE="Record of installation progress"
if ! grep -qF "$LINE" "$FILE"; then
    echo "   "       >> "$FILE"
	echo "=========" >> "$FILE"
    echo "$LINE" >> "$FILE"
	echo "=========" >> "$FILE"
	echo "   "       >> "$FILE"
fi
cat /home/$USER/install_progerss.txt

################
# Update Ubuntu
# Also install postgresql
################

cd /home/$USER
if [ ! -f /home/$USER/ubuntu_updated.txt ]; then
    echo "  "
    echo "------------"   
	echo "Updating Ubuntu.."
    sleep 3
	# Download test file
	wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/quick_flowise_ollama/test.sh
	
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
	# Record date/time in history
	echo 'export HISTTIMEFORMAT="%F %T "'  >> /home/$USER/.bashrc
	# For reading markdown documents
	# Instead use marktext (see antigravity installation below)
	#sudo apt install retext  -y
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
    #curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
	# Install nvm
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

    # Now install Node.js and npm
    #sudo apt install nodejs -y
	nvm install 22
	echo "NodeJS installed"
	echo " "
	sleep 3
	sudo apt install npm
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
	#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
	echo "  "
	echo "------"
	echo "Install httpd server"
	sudo apt-get install apache2 -y
	cd /home/$USER
	wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/misc/index.html
	sudo mv /home/$USER/index.html  /var/www/html/index.html
	echo '#!/bin/bash'                                         | tee    /home/$USER/start_apache2.sh
	echo " "                                                   | tee -a /home/$USER/start_apache2.sh
	echo "cd ~/"                                               | tee -a /home/$USER/start_apache2.sh
	echo "echo 'Port is 80.'"                                  | tee -a /home/$USER/start_apache2.sh
	echo "echo 'Web server is at /var/www/html/'"              | tee -a /home/$USER/start_apache2.sh
	echo "sudo systemctl restart apache2"                      | tee -a /home/$USER/start_apache2.sh
	echo "cd /home/$USER"                                      | tee -a /home/$USER/start_apache2.sh 
	echo "netstat -aunt | grep 80"                             | tee -a /home/$USER/start_apache2.sh
    echo '#!/bin/bash'                                         | tee    /home/$USER/stop_apache2.sh
	echo " "                                                   | tee -a /home/$USER/stop_apache2.sh
	echo "cd ~/"                                               | tee -a /home/$USER/stop_apache2.sh
	echo "echo 'Port is 80.'"                                  | tee -a /home/$USER/stop_apache2.sh
	echo "echo 'Web server is at /var/www/html/'"              | tee -a /home/$USER/stop_apache2.sh
	echo "sudo systemctl stop apache2"                         | tee -a /home/$USER/stop_apache2.sh
	echo "cd /home/$USER"                                      | tee -a /home/$USER/stop_apache2.sh 
	echo "netstat -aunt | grep 80"                             | tee -a /home/$USER/stop_apache2.sh
	sleep 3
	echo "====NOTE====="
	echo " NVIDIA driver ver was: $nvidia_driver_version"        
    echo " NVIDIA driver ver  is: $now_nvidia_driver_version"
	echo "==>> You may like to search for cuda-toolkit compatible with this driver ==<<"
    echo "Machine will be rebooted several times. After each reboot, execute the following script:"
	# Print IP of machine while opening terminal
	echo "hostname -I | awk '{print \$1}'  " >> /home/$USER/.bashrc
    echo " "
    echo "=>   ./install_ubuntu.sh"
    echo "=========="
    sleep 15
	LINE="  1. Ubuntu updated"
	if ! grep -qF "$LINE" "$FILE"; then
	    echo "$LINE" >> "$FILE"
	fi
    sudo systemctl reboot -i
else 
    LINE="  1. Ubuntu updated"
	if ! grep -qF "$LINE" "$FILE"; then
	    echo "$LINE" >> "$FILE"
	fi
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
	echo "==>CUDA install for Ubuntu 22.04 ONLY<=="
	echo "  "
	#nvidia-settings
	#echo "https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=22.04&target_type=deb_local"
	#echo "Archive: https://developer.nvidia.com/cuda-toolkit-archive"
	echo "cuda-toolkit does not change GPU drivers."
	echo "But higher versions of cuda-toolkit may have installation problems"
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
	#nvidia-settings
	sleep 8
	echo "cuda is installed" > /home/$USER/cuda_installed.txt   # To avoid repeat cuda installation
	LINE="  2. CUDA installed"
	if ! grep -qF "$LINE" "$FILE"; then
	    echo "$LINE" >> "$FILE"
	fi
	sudo systemctl reboot -i
else
   	LINE="  2. CUDA installed"
	if ! grep -qF "$LINE" "$FILE"; then
	    echo "$LINE" >> "$FILE"
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
	echo "  "
	echo "   "
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
	mkdir /home/$USER/docker
	cd /home/$USER/docker
	echo "Download script to print names of docker containers"
	wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/docker/names_dockers.sh
	chmod +x *.sh
	cd /home/$USER
	LINE="  3. Docker installed"
	if ! grep -qF "$LINE" "$FILE"; then
	    echo "$LINE" >> "$FILE"
	fi
    sudo systemctl reboot -i
else
   LINE="  3. Docker installed"
	if ! grep -qF "$LINE" "$FILE"; then
	    echo "$LINE" >> "$FILE"
	fi
fi  



##################
# Docker installation-II
#################

cd /home/$USER
if [ ! -f /home/$USER/docker_installed_1.txt ]; then
    # Ref: https://docs.docker.com/engine/install/ubuntu/
    #      https://docs.docker.com/engine/install/linux-postinstall/
	echo "  "
	echo "  "
    echo "Testing if docker is properly installed"
    echo "AND running docker without root privilegs.."
    sleep 3
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
	LINE="  4. Docker configured to use normal user"
	if ! grep -qF "$LINE" "$FILE"; then
	    echo "$LINE" >> "$FILE"
	fi
    echo "Machine will be rebooted "
    sudo systemctl reboot -i
else
    LINE="  4. Docker configured to use normal user"
	if ! grep -qF "$LINE" "$FILE"; then
	    echo "$LINE" >> "$FILE"
	fi
fi    

 

#########3
# VectorDB install
##########

cd /home/$USER/
if [ ! -f /home/$USER/vectordb_installed.txt ]; then
	echo " "
	echo " "
	echo "------------" 
    echo "Vector DBs would be installed"
	sleep 3
	echo "  "
	echo  "  "
	###############
	# Milvus install
	# Webui avaiable at: http://localhost:9091/webui
	# Ref: https://milvus.io/docs/install_standalone-docker.md
	################
	echo "  "
	echo "   "
	cd /home/$USER/
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
	echo "cd /home/$USER"                                       | tee -a /home/$USER/start/start_milvus.sh 
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
	
	LINE="  5. Milvus installed"
	if ! grep -qF "$LINE" "$FILE"; then
	    echo "$LINE" >> "$FILE"
	fi
				
	###############
	# Meilisearch install
	# Ref: https://www.meilisearch.com/docs/guides/docker
	################
		
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
	sleep 2
	LINE="  6. Meilisearch installed"
	if ! grep -qF "$LINE" "$FILE"; then
	    echo "$LINE" >> "$FILE"
	fi
				
	##########################
	### Install chromadb docker
	# Ref: https://docs.trychroma.com/production/containers/docker
	#      https://cookbook.chromadb.dev/strategies/cors/
	##########################
	
	cd /home/$USER
	echo "Installing chromadb.."
    sleep 2
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
	echo " "                                       
	echo " Pulling chromadb docker image"          
	# Refer: https://cookbook.chromadb.dev/strategies/cors/
	docker run -d --rm --network host -e CHROMA_SERVER_CORS_ALLOW_ORIGINS='["http://localhost:3000"]' -v /home/$USER/chroma_data:/chroma/chroma -p 8000:8000 --name chroma  chromadb/chroma:1.0.20 
	echo "------------"                            
	echo " "                                       
	echo "chromadb_installed" > /home/$USER/chromadb_installed.txt
	chmod +x /home/$USER/*.sh
	chmod +x /home/$USER/start/*.sh
	chmod +x /home/$USER/stop/*.sh
	sleep 2
	LINE="  7. chromadb installed"
	if ! grep -qF "$LINE" "$FILE"; then
	    echo "$LINE" >> "$FILE"
	fi
		
	##########################
	### Install FAISS library
	##########################
	
	echo "  "
	echo  "   "
	echo "Installing FAISS.."
    sleep 3
	echo " "
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
	sleep 2
	LINE="  8. FAISS installed"
	if ! grep -qF "$LINE" "$FILE"; then
	    echo "$LINE" >> "$FILE"
	fi
	
	################
	# Install postgresql and sqlite3
	# https://stackoverflow.com/questions/18223665/postgresql-query-from-bash-script-as-database-user-postgres
	################
	
	echo " "
	echo " "
	cd /home/$USER/
	echo "Installing postgresql and sqlite3"
	sleep 3
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
	# Creating user 'ashok', owning database 'ashok'. 
	# Creating user 'harnal', owning database 'harnal'. 
	echo " "
	echo " "
	echo "========="
	echo "Creating user 'ashok' owning database 'askok'"
	echo "Creating user 'harnal' and database 'harnal'"
	echo "User 'ashok' has password: ashok"
	echo "User 'harnal' has password: harnal"
	echo "Database 'ashok' can also be used as vector database"
	echo "Database 'harnal' can also be used as vector database"
	echo "Similarly we have users gautam and ganesh:"
	echo "========="
	echo " "
	echo " "
	sleep 5
	sudo -u postgres psql -c 'create user harnal ;'
	sudo -u postgres psql -c 'CREATE DATABASE harnal WITH OWNER = harnal;  '
	sudo -u postgres psql -c 'grant all privileges on database harnal to harnal;'
	sudo -u postgres psql -c "alter user harnal with encrypted password 'harnal';"
	sudo -u postgres psql -c "CREATE EXTENSION vector;" -d harnal
	echo "===="
	sudo -u postgres psql -c 'create user ashok ;'
	sudo -u postgres psql -c 'CREATE DATABASE ashok WITH OWNER = ashok;  '
	sudo -u postgres psql -c 'grant all privileges on database ashok to ashok;'
	sudo -u postgres psql -c "alter user ashok with encrypted password 'ashok';"
	sudo -u postgres psql -c "CREATE EXTENSION vector;" -d ashok
	echo "===="
	sudo -u postgres psql -c 'create user gautam ;'
	sudo -u postgres psql -c 'CREATE DATABASE gautam WITH OWNER = gautam;  '
	sudo -u postgres psql -c 'grant all privileges on database gautam to gautam;'
	sudo -u postgres psql -c "alter user gautam with encrypted password 'gautam';"
	sudo -u postgres psql -c "CREATE EXTENSION vector;" -d gautam
	echo "===="
	sudo -u postgres psql -c 'create user ganesh ;'
	sudo -u postgres psql -c 'CREATE DATABASE ganesh WITH OWNER = ganesh;  '
	sudo -u postgres psql -c 'grant all privileges on database ganesh to ganesh;'
	sudo -u postgres psql -c "alter user ganesh with encrypted password 'ganesh';"
	sudo -u postgres psql -c "CREATE EXTENSION vector;" -d ganesh
	echo "===="
	echo "===="
	echo "Create user ravi, password ravi, database ravi and a table, distributors, with few rows"
	echo "In the same database, creating linked tables: s,p,j,spj with data"
	echo "See as: ./psql.sh ; \c ravi ; select * from spj ; ' "
	sleep 3
	sudo -u postgres psql -c 'create user ravi ;'
	sudo -u postgres psql -c 'CREATE DATABASE ravi WITH OWNER = ravi;  '
	sudo -u postgres psql -c "alter user ravi with encrypted password 'ravi';"
	#
	cd /home/$USER/psql
	rm  /home/$USER/psql/simpleTable.sql
	wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/psql/simpleTable.sql
	cd /home/$USER
	PGPASSWORD="ravi"  psql -U ravi -d ravi -h localhost -f /home/$USER/psql/simpleTable.sql
	#
    # Create chinook database and data
	# Ref: https://github.com/neondatabase/postgres-sample-dbs/tree/main?tab=readme-ov-file#chinook-database
	echo "===="
	echo "Create user chinook, password chinook, database chinook with many rows"
	echo "In the same database, creating multiple linked tables. Use pgAdmin4 to view data"
	echo "All table names and column names are in double quotes"
	echo 'Check as: ./psql.sh ; \c chinook ; select * from "Album" ; OR select * from "Artist" ; '
	sleep 3
	sudo -u postgres psql -c 'create user chinook ;'
	sudo -u postgres psql -c 'CREATE DATABASE chinook WITH OWNER = chinook;  '
	sudo -u postgres psql -c "alter user chinook with encrypted password 'chinook';"
	#
	cd /home/$USER/psql
	rm  /home/$USER/psql/chinook.sql
	# Original is here: 
	# wget -Nc https://raw.githubusercontent.com/neondatabase/postgres-sample-dbs/main/chinook.sql
	# With double quotes removed
	wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/psql/chinook.sql
	cd /home/$USER
	PGPASSWORD="chinook"  psql -U chinook -d chinook -h localhost -f /home/$USER/psql/chinook.sql
			
	#sudo -u postgres psql -c "\du" 
	#sudo -u postgres psql -c "\l"

	# Finally change postgresql.conf and pg_hba.conf and make them highly permissive
	version=$(psql -V | awk '{print $3}' |  cut -d '.' -f 1 | tr -d '\n')
	cd /etc/postgresql/$version/main
	echo "listen_addresses = '*'" |  sudo tee -a /etc/postgresql/$version/main/postgresql.conf
	echo "host    all             all             0.0.0.0/0               scram-sha-256" |  sudo tee -a /etc/postgresql/$version/main/pg_hba.conf
	sudo systemctl restart postgresql
	#
	# Install pgadmin4 only in Ubuntu
	echo "Installing pgadmin4.."
	sleep 3
	curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg
	# Create the repository configuration file:
	sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
	# Install for both desktop and web modes:
	sudo apt install pgadmin4 -y
    #
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
	sleep 2
	chmod +x /home/$USER/*.sh
	chmod +x /home/$USER/start/*.sh
	chmod +x /home/$USER/stop/*.sh
	echo "vectordb_installed.txt" > /home/$USER/vectordb_installed.txt
	# Start all vector databases to check
	bash stop_milvus.sh
    bash start_postgresql.sh
	bash start_chroma.sh  
	bash start_meilisearch.sh
	bash start_milvus.sh
	echo "  "
    echo "  "
	echo "Postgresql started?"
	netstat -aunt | grep 5432
	echo "Chromadb started?"
	netstat -aunt | grep 8000
	echo "meilisearch started"
	netstat -aunt | grep 7700
	echo "milvus started"
	netstat -aunt | grep 19530
	sleep 8

	LINE="  9. PostgreSQL installed"
	if ! grep -qF "$LINE" "$FILE"; then
	    echo "$LINE" >> "$FILE"
	fi
	sudo systemctl reboot -i
else
    echo "  "
fi	

#############
# n8n and flowise would be installed
#############

cd /home/$USER/
if [ ! -f /home/$USER/n8mandflowise_installed.txt ]; then
	echo " "
	echo " "
	echo "------------" 
    echo "n8n and flowise would be installed"
	sleep 3
	echo "  "
	echo  "  "
	##########################
	### n8n docker
	##########################
	
	# Refer: https://github.com/n8n-io/n8n?tab=readme-ov-file#quick-start
	# Workflow automation with n8n:
	#                https://community.n8n.io/tags/c/tutorials/28/course-beginner
	
	cd /home/$USER
	cd ~/
	mkdir /home/$USER/n8n  # Redundant step
	# Volumes are automatically created below: /var/lib/docker/volumes/
	#                                          /var/lib/docker/volumes/n8n_data/_data
	docker volume create n8n_data
	#   https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
	#   https://docs.n8n.io/hosting/scaling/memory-errors/#increase-old-memory
	# Access at localhost:5678
	# --rm implies remove docker when stopped. So docker will not show up in 'docker ps -a' call
	# Access at localhost:5678
	sudo docker run -it -d --rm \
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
	echo "echo 'n8n community nodes available at:'"                                                                           >> /home/$USER/start_n8n.sh
	echo "echo '==>    https://ncnodes.com/packages'"                                                                          >> /home/$USER/start_n8n.sh
	echo "echo 'Use \"top -u $USER\" OR \"free -g \" command to see memory usage'"                                             >>  /home/$USER/start_n8n.sh
	echo "echo 'Next time start as: docker start n8n'"																		   >>  /home/$USER/start_n8n.sh
	echo "sleep 9"                                                                                                             >> /home/$USER/start_n8n.sh
	echo "docker run -it -d --rm --name n8n -p 5678:5678 -e NODE_OPTIONS=\"--max-old-space-size=4096\" --network host -v n8n_data:/home/node/.n8n docker.n8n.io/n8nio/n8n"   >> /home/$USER/start_n8n.sh
  	# n8n community nodes
	echo '#!/bin/bash'                                                                                                        > /home/$USER/comm_node_n8n.sh
	echo " "                                                                                                                  >> /home/$USER/comm_node_n8n.sh
	echo "echo 'List of community nodes to install:'"                                                                         >> /home/$USER/comm_node_n8n.sh
	echo "echo 'n8n community nodes available at:'"                                                                           >> /home/$USER/comm_node_n8n.sh
	echo "echo '==>    https://ncnodes.com/packages'"                                                                          >> /home/$USER/comm_node_n8n.sh
	echo "echo '  1. n8n-nodes-crawl4ai-enhanced'"                                                                             >> /home/$USER/comm_node_n8n.sh
	echo "sleep 9"                                                                                                             >> /home/$USER/comm_node_n8n.sh
	
	# REf: https://community.n8n.io/t/communication-issue-between-n8n-and-ollama-on-ubuntu-installed-on-windows/48285/6
	mkdir /home/$USER/Documents/n8n
	cd /home/$USER/Documents/n8n
	wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/n8n/1.simpleCalculator/Calculator_AI_Agent_with_smtp_III.json?raw=true
	wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/n8n/1.simpleCalculator/Calculator_AI_Agent_II.json?raw=true
	wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/n8n/2.twilio/quickstart-twilio.pdf?raw=true
	wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/n8n/2.twilio/checking%20website%20status%20using%20twilio.pdf?raw=true
	wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/n8n/2.twilio/check_website_status.json
	wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/n8n/4.forms_and_SMTP/form_to_smtp_node.json
	wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/n8n/6.looping/Simple%20RAG%20flow.json
	wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/n8n/6.looping/Rag%20Flow-I.json
	wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/n8n/7.postgresql_related/Postgres%20nodes.json
	wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/n8n/7.postgresql_related/Postgres%20with%20ai%20agent.json
	wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/n8n/Build%20Your%20Very%20First%20Workflow%20in%20n8n.pdf?raw=true
	wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/n8n/3.webScrapping/web_scrapping_and_summarization-I.json
	wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/n8n/3.webScrapping/web_scrapping.pdf?raw=true
	echo "n8n_installed" > /home/$USER/n8n_installed.txt
	cd /home/$USER
	
	LINE="  10. n8n installed"
	if ! grep -qF "$LINE" "$FILE"; then
	    echo "$LINE" >> "$FILE"
	fi
	
	#####################3
	# flowise docker
	# Ref: https://docs.flowiseai.com/getting-started#docker-compose
	######################
   cd /home/$USER/
   # Install Flowise through docker"
   # Ref: https://docs.flowiseai.com/getting-started
   echo  "   "
   echo  "   "
   echo "Installing flowise docker. Takes time.."   
   sleep 3
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
   echo "cd /home/$USER"                                      >> /home/$USER/start_flowise.sh
   echo "docker start flowise"                                >> /home/$USER/start_flowise.sh
   echo "sleep 3"                                             >> /home/$USER/start_flowise.sh
   echo "netstat -aunt | grep 3000"                           >> /home/$USER/start_flowise.sh
   # Reset flowise password
   echo '#!/bin/bash'                                         >  /home/$USER/reset_flowise.sh
   echo " "                                                   >> /home/$USER/reset_flowise.sh
   echo "echo '===Stopping flowise===='"                      >> /home/$USER/reset_flowise.sh
   echo "cd /home/$USER"                                      >> /home/$USER/reset_flowise.sh
   echo "docker stop flowise"                                 >> /home/$USER/reset_flowise.sh
   echo "cd /home/$USER"                                      >> /home/$USER/reset_flowise.sh
   echo "sudo rm -rf .flowise/"                               >> /home/$USER/reset_flowise.sh
   echo "echo '===Restarting flowise===='"                    >> /home/$USER/reset_flowise.sh
   echo " "                                                   >> /home/$USER/reset_flowise.sh
   echo "cd /home/$USER"                                      >> /home/$USER/reset_flowise.sh
   echo "docker start flowise"                                >> /home/$USER/reset_flowise.sh
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
   echo "cd /home/$USER"                                     >> /home/$USER/stop_docker_flowise.sh
   echo "docker stop flowise"                                >> /home/$USER/stop_docker_flowise.sh
   echo "netstat -aunt | grep 3000"                           >> /home/$USER/stop_docker_flowise.sh
   sleep 4
   cd ~/
   FDIR="/home/$USER/Flowise"
   if [ -d "$FDIR" ]; then
       rm -rf /home/$USER/Flowise
   fi	   
   git clone https://github.com/FlowiseAI/Flowise.git
   cd Flowise/
   sudo docker build --no-cache -t flowise .
   
   # The '--network host' option removes network isolation between the container and
   #   the Docker host machine, meaning the container directly shares the host's networking stack
   # The container operates as if it were a process running directly on the host machine,
   #   using the host's IP address and network interfaces.  
   sudo docker run -d --name flowise -p 3000:3000 --network host flowise
   #      docker run -d --name flowise -p 3000:3000 --network host flowise
   #cd /home/$USER/Flowise/docker
   #cp .env.example .env
   #docker compose up -d
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
   # For .pdf file, add '?raw=true' to URL
   wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/flowise/DesignChatflowsWithFlowise.pdf?raw=true
   wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/huggingface/huggingfaceAcessToken.pdf?raw=true
   wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/huggingface/huggingface_datasets.pdf?raw-true
   wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/flowise/ExportDocumentStoreVectorStoreAndChatflow.pdf?raw=true
   wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/flowise/RAGandToolAgent.pdf?raw=true
   wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/flowise/huggingfaceAcessToken.pdf?raw=true
   cd /home/$USER
   echo "flowise installed" > /home/$USER/flowise_installed.txt
   chmod +x /home/$USER/*.sh
   chmod +x /home/$USER/start/*.sh
   chmod +x /home/$USER/stop/*.sh
   echo "n8n and flowise installed" > /home/$USER/n8mandflowise_installed.txt
   bash reset_flowise.sh
   bash start_n8n.sh
   echo "  "
   echo "  "
   echo "n8n started?"
   netstat -aunt | grep 5678
   echo "flowise started?"
   netstat -aunt | grep 3000
   echo "===="
   sleep 8
   bash stop_n8n.sh
   bash stop_flowise.sh
   sleep 2
   LINE="  11. Flowise installed"
	if ! grep -qF "$LINE" "$FILE"; then
	    echo "$LINE" >> "$FILE"
	fi
   sudo systemctl reboot -i
else
   echo " "
fi	 
	

##########################
### ollama docker
##########################

cd /home/$USER
if [ ! -f /home/$USER/ollama_installed.txt ]; then
	  echo  "  "
	  echo  "    "
	  echo "------------"   
	  echo "Installing ollama docker.."
      sleep 3
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
	  echo "   "
	  echo  "    "
	  echo "Local folder ollama for models is: /var/lib/docker/volumes/ollama/"
	  echo "Will install ollama for GPU..."
	  sleep 4
	  # Creating alias for command: docker exec -it ollama
	  hostip=`hostname -I | awk '{print $1}'`
	  echo "alias ollama='docker exec -it ollama ollama'" >> /home/$USER/.bashrc
	  echo "docker start ollama"                          >> /home/$USER/.bashrc
	  echo "echo 'Ollama docker started at port 11434'"   >> /home/$USER/.bashrc
	  echo "echo 'Access as: http://$hostip:11434'"       >> /home/$USER/.bashrc
	  #docker run -d --gpus=all -v /home/$USER/ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
	  # network host would be local mashine
	  docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --network host --name ollama ollama/ollama
	  echo "ollama_installed" > /home/$USER/ollama_installed.txt
	  sleep 4
	  chmod +x /home/$USER/*.sh
	  chmod +x /home/$USER/start/*.sh
	  chmod +x /home/$USER/stop/*.sh
	  sleep 3
	  LINE="  12. Ollama installed"
	  if ! grep -qF "$LINE" "$FILE"; then
	     echo "$LINE" >> "$FILE"
	  fi
	  sudo systemctl reboot -i
else
      echo " "
fi


##########################
### Download some minimum ollama models
##########################

if [ ! -f /home/$USER/models_installed.txt ]; then
    echo  "    "
	echo  "    "
	echo "------------"   
	echo "Downloading ollama models.."
    sleep 3
	cd /home/$USER/
	# Start ollama docker in future
	docker start ollama 
	echo "Pulling bge-m3"
	docker exec -it ollama ollama pull bge-m3
	docker exec -it ollama ollama pull nomic-embed-text
	docker exec -it ollama ollama pull qwen3-embedding
	echo "Pulling llama3.2"
	docker exec -it ollama ollama pull llama3.2:latest
	docker exec -it ollama ollama pull llama3.2:1b
	docker exec -it ollama ollama pull deepseek-r1:1.5b
	docker exec -it ollama ollama pull qllama/bge-small-en-v1.5
	docker exec -it ollama ollama pull gemma3:270m
	docker exec -it ollama ollama pull qwen3.5:latest
	docker exec -it ollama ollama pull qwen3:latest
	docker exec -it ollama ollama pull mistral-nemo:latest
	echo " "
	echo " "
	#ollama list
	mkdir -p /home/$USER/Documents/huggingface
	cd /home/$USER/Documents/huggingface
	wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/huggingface/huggingfaceAcessToken.pdf
	wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/huggingface/huggingface_datasets.pdf
	mv 'Huggingface access token.pdf' Huggingface_access_token.pdf
	cd /home/$USER/
	echo "models installed" > /home/$USER/models_installed.txt
	LINE="  13. Ollama models downloaded"
	if ! grep -qF "$LINE" "$FILE"; then
	    echo "$LINE" >> "$FILE"
	fi
else
    echo "  "
fi

##################3
# crawl4AI
# https://github.com/unclecode/crawl4ai
###################


if [ ! -f /home/$USER/webscrapper_installed.txt ]; then
   # Clear earlier directory, if it exists
   # -m venv: Run the built-in venv module to create isolated environments.
   # --clear: Delete the contents of the target directory if it already exists
   # /home/$USER/crawl4ai: The destination path so the environment will be located in
   #                     a folder named venv inside your home directory.
	python3 -m venv --clear /home/$USER/crawl4ai
	source /home/$USER/crawl4ai/bin/activate
	# 1.6 Essentials software
	pip install --upgrade pip
	pip install spyder numpy scipy pandas matplotlib sympy cython
	pip install jupyterlab
	pip install -U wheel
	pip install ipython
	pip install notebook
	pip install -U streamlit
	pip install --upgrade setuptools
	echo "webscrapper_installed.txt" > /home/$USER/webscrapper_installed.txt
	# Required for spyder:
	sudo apt install pyqt5-dev-tools -y
	sudo apt install tesseract-ocr-all -y
	echo "Install pdfminer to extract text from pdf"
	# Ref: https://github.com/pdfminer/pdfminer.six
	pip install pdfminer.six
	# To connect to postgresql
	pip install psycopg2
	echo "####"
	echo "Install pymupdf4llm to extract text/json"
	# Ref: https://github.com/pymupdf/pymupdf4llm
	pip install pymupdf4llm pymupdf4llm[layout]
	sleep 2
	# Install the crew4AI
    pip install -U crawl4ai
	sleep 2
	playwright install
	sleep 2
	python -m playwright install --with-deps chromium
	sleep 3
	crawl4ai-setup
	crawl4ai-doctor
	# Create script to activate 'crawl4ai' env
	echo '#!/bin/bash'                                                            | tee   /home/$USER/activate_crawl4ai.sh
	echo "echo 'Execute this file as: source activate_crawl4ai.sh' "              | tee -a  /home/$USER/activate_crawl4ai.sh
	echo "echo 'To use or install any python package, first activate python crawl4ai as:' "        | tee -a  /home/$USER/activate_crawl4ai.sh
	echo "echo 'source /home/$USER/crawl4ai/bin/activate' "                       | tee -a  /home/$USER/activate_crawl4ai.sh
	echo "echo '(Note the change in prompt after activating)' "                   | tee -a  /home/$USER/activate_crawl4ai.sh
	echo "echo '(To deactivate, just enter the command: deactivate)' "            | tee -a  /home/$USER/activate_crawl4ai.sh
	echo "source /home/$USER/crawl4ai/bin/activate"                               | tee -a  /home/$USER/activate_crawl4ai.sh
	#
	# Pull and run the latest release
    docker pull unclecode/crawl4ai:latest
    docker run -d -p 11235:11235 --name crawl4ai --shm-size=1g unclecode/crawl4ai:latest
	docker update --restart=no $(docker ps -a -q)
	echo '#!/bin/bash'                                         >  /home/$USER/start_crawl4ai.sh
    echo " "                                                   >> /home/$USER/start_crawl4ai.sh
    echo "cd ~/"                                               >> /home/$USER/start_crawl4ai.sh
    echo "echo 'crawl4ai port 11235 onstarting'"                 >> /home/$USER/start_crawl4ai.sh
    echo "echo 'Access crawl4ai as: http://localhost:11235'"     >> /home/$USER/start_crawl4ai.sh
    echo " "                                                   >> /home/$USER/start_crawl4ai.sh
    echo " "                                                   >> /home/$USER/start_crawl4ai.sh
    echo "cd /home/$USER"                                      >> /home/$USER/start_crawl4ai.sh
    echo "docker start crawl4ai"                               >> /home/$USER/start_crawl4ai.sh
    echo "sleep 3"                                             >> /home/$USER/start_crawl4ai.sh
    echo "netstat -aunt | grep 11235"                           >> /home/$USER/start_crawl4ai.sh
    chmod +x *.sh
	sleep 2
	LINE="  14. crawl4ai installed"
	if ! grep -qF "$LINE" "$FILE"; then
	    echo "$LINE" >> "$FILE"
	fi
	sudo systemctl reboot -i
else
    echo "   "
fi


##############
# Create python virtual env
# source /home/$USER/venv/bin/activate
##############

if [ ! -f /home/$USER/venv_installed.txt ]; then
    cd /home/$USER
	echo  "    "
	echo  "    "
	echo "Creating python virtual env.."
    sleep 3
    echo " "
    echo " "
    echo "------------"        
   # Clear earlier directory, if it exists
   # -m venv: Run the built-in venv module to create isolated environments.
   # --clear: Delete the contents of the target directory if it already exists
   # /home/$USER/venv: The destination path so the environment will be located in
   #                   a folder named venv inside your home directory.
	python3 -m venv --clear /home/$USER/venv
	source /home/$USER/venv/bin/activate
	# 1.6 Essentials software
	pip install spyder numpy scipy pandas matplotlib sympy cython
	pip install jupyterlab
	pip install -U wheel
	pip install ipython
	pip install notebook
	pip install -U streamlit
	pip install --upgrade setuptools
	echo "venv_installed.txt" > /home/$USER/venv_installed.txt
	# Required for spyder:
	# Huggingface and  related
	#pip install huggingface_hub
	# cu124: is as per cuda version. Get cuda version from nvidia-smi
	#pip install transformers torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124
	#pip install huggingface_hub
	echo "####"
	sudo apt install pyqt5-dev-tools -y
	sudo apt install tesseract-ocr-all -y
	echo "Install pdfminer to extract text from pdf"
	# Ref: https://github.com/pdfminer/pdfminer.six
	pip install pdfminer.six
	# To connect to postgresql
	pip install psycopg2
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
	LINE="  15. python virtual env created at '~/venv'"
	if ! grep -qF "$LINE" "$FILE"; then
	    echo "$LINE" >> "$FILE"
	fi
	sudo systemctl reboot -i
else
   echo "  "
fi   


###########################
# Install latest anaconda
# https://askubuntu.com/a/841224
###########################

cd /home/$USER
DIRECTORY=/home/$USER/anaconda3
if [ ! -d "$DIRECTORY" ]; then
	if [ ! -f /home/$USER/anaconda_installed.txt ]; then
		echo "   "
		echo "   "
		echo "Installing Anaconda.."
        sleep 3
		echo "   "
		echo "   "
		echo "------------"        
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
		# Accept all conda channels
		conda tos accept
		# Install postgresql client
 		conda install -c conda-forge psycopg2  -y
		# Download script to create conda venv
		wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/quick_flowise_ollama/venv/create_conda_venv.sh -P /home/$USER
		chmod +x *.sh  
		echo "anaconda_installed.txt" > /home/$USER/anaconda_installed.txt
		chmod +x /home/$USER/*.sh
		chmod +x /home/$USER/start/*.sh
		chmod +x /home/$USER/stop/*.sh
		LINE="  16. anaconda installed"
		if ! grep -qF "$LINE" "$FILE"; then
	    	echo "$LINE" >> "$FILE"
		fi
		sudo systemctl reboot -i
	fi
else
   echo "  "
fi	


#################
# langchain & langraph
#################

cd /home/$USER
if [ ! -f /home/$USER/langchain_installed.txt ]; then
    echo " "
    echo " "
	echo "Installing langchain and langraph.."
    sleep 3
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
	pip install -U streamlit
	# Required for spyder:
	sudo apt install pyqt5-dev-tools -y
	# Huggingface and llama.cpp related
	pip install -U huggingface_hub
	# To connect to postgresql
	pip install psycopg2
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
	pip install -U langchain
	pip install -U langchain-openai
	 pip install -U langchain-ollama
	pip install -U langchain-community
	pip install -U langchain-classic
	pip install -U langchain-experimental
	pip install -U langgraph
	pip install -U "langserve[all]"
	pip install -U langchain-cli
	pip install -U unstructured
	pip install -U unstructured[md]
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
	pip install -U llama-index-core llama-index-readers-file llama-index-llms-ollama llama-index-embeddings-ollama llama-index-embeddings-huggingface llama-index-llms-openai-like llama-index-vector-stores-faiss 
	pip install -U llama-index-readers-file llama-index-embeddings-fastembed
	# Needed inspite of code repeated above
	pip install --upgrade transformers
	# 1.2 Vector stores
	pip install -U faiss-cpu
	pip install -U qdrant-client llama-index-vector-stores-chroma 
	pip install =U llama-index-vector-stores-qdrant fastembed
	 pip install -U llama-index-vector-stores-postgres
	# 1.3 Web access site
	pip install tavily-python
	# 1.4 Yahoo finance data
	pip install yfinance
	# 1.5 For groq, together, mistralAI access
	pip install llama-index-llms-groq
	pip install llama-index-llms-together
	pip install llama-index-llms-mistralai
	pip install llama-index-llms-openrouter
	# Install deepeval evaluation system
	pip install -U deepeval
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
	LINE="  17. langchain and langgraph virtual env, 'langchain', created."
	if ! grep -qF "$LINE" "$FILE"; then
		echo "$LINE" >> "$FILE"
	fi
	sudo systemctl reboot -i
else
    echo "  "
fi	

###########################
# Install Google Antigravity
#   Anaconda installation is a must
# https://antigravity.google/download/linux
###########################


cd /home/$USER
# Install only if anaconda is installed:
if [  -f /home/$USER/anaconda_installed.txt ]; then
	if [ ! -f /home/$USER/antigravity_installed.txt ]; then
	        echo  "    "
			echo  "    "
		    echo "Installing Google Antigravity.."
    		sleep 3
           conda init
		   #  create a directory for keyrings
			sudo mkdir -p /etc/apt/keyrings
			# Download and add Google's signing key
			sudo mkdir -p /etc/apt/keyrings
			curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | \
  			sudo gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg
			echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | \
  			sudo tee /etc/apt/sources.list.d/antigravity.list > /dev/null
			# Update your package cach
			sudo apt update -y
			# Install Markdown reader
			echo "Installing marktext markdown reader"
			sudo snap install marktext
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
			echo '#!/bin/bash'                                         | tee    /home/$USER/start_antigravity.sh
	 		echo " "                                                   | tee -a /home/$USER/start_antigravity.sh
			echo "cd ~/"                                               | tee -a /home/$USER/start_antigravity.sh
			echo "antigravity"                      				   | tee -a /home/$USER/start_antigravity.sh
			chmod +x *.sh
			sleep 5
			LINE="  18. Google antigravity installed."
			if ! grep -qF "$LINE" "$FILE"; then
				echo "$LINE" >> "$FILE"
			fi
			sudo systemctl reboot -i
	else
	       echo " "
	fi
fi

###################
# llama.cpp install--I
# python env remains activated
# source /home/$USER/venv/bin/activate
# https://github.com/ggml-org/llama.cpp/blob/master/docs/install.md
###################

cd /home/$USER
if [ ! -f /home/$USER/llamacpp_installed.txt ]; then
      echo "   "
	  echo "    "
	  echo "Installing llamacpp"
	  sleep 3
	  # Installing llama.cpp
	  source /home/$USER/venv/bin/activate
	   # Huggingface and llama.cpp related
	  pip install huggingface_hub
	  pip install transformers
	  pip install accelerate
	  brew install llama.cpp
	  echo 'export PATH="/home/linuxbrew/.linuxbrew/Cellar/llama.cpp/8030/bin:$PATH"'  >> /home/$USER/.bashrc
	  echo "llama.cpp installed"  
	  echo "llamacpp_installed.txt"  > /home/$USER/llamacpp_installed.txt
	  sleep 3
	  LINE="  19. llamacpp installed"
	  if ! grep -qF "$LINE" "$FILE"; then
		echo "$LINE" >> "$FILE"
	  fi
	  sudo systemctl reboot -i
else
      echo "   "
fi	



##########################
### Install Visual Studio Coder
### Only install it in Ubuntu and NOT in WSL 
##########################

cd /home/$USER
if [ ! -f /home/$USER/vscode_installed.txt ]; then
    echo " "
    echo " "
	echo "Installing VSCode..."
	sleep 3
	echo "------------"  
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
	wget -Nc https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/quick_flowise_ollama/venv/vscode_help.pdf?raw=true
	echo "vscode_installed" > /home/$USER/vscode_installed.txt
	#    
	sleep 5
	#
	# Deactivate the environment
	deactivate
	echo "Will reboot system now"
	chmod +x /home/$USER/*.sh
    chmod +x /home/$USER/start/*.sh
    chmod +x /home/$USER/stop/*.sh
	sleep 5
	LINE="  20. VSCode installed"
	if ! grep -qF "$LINE" "$FILE"; then
		echo "$LINE" >> "$FILE"
	fi
	sudo systemctl reboot -i
else
   echo "    "
fi



#############
# Install RAG and RAG performance eval system
# Created using Google Antigravity
############

#  Download github folder 'rag_eval_system-II' using command line
#  Can copy and paste all at once:

cd /home/$USER
if [ ! -f /home/$USER/rageval_installed.txt ]; then
		cd ~/   
		echo "  "
		echo "   "
		echo "Installing RAG and RAG performance eval system"
		sleep 3
		source /home/ashok/langchain/bin/activate
	    rm -rf /home/$USER/ragsystem
		mkdir /home/$USER/ragsystem
		cd /home/$USER/ragsystem
		git init
		git remote add origin https://github.com/harnalashok/LLMs.git
		git sparse-checkout init --cone
		git sparse-checkout set rag_eval_system-II
		git pull origin main
		find . -maxdepth 1 ! -name "rag_eval_system-II" ! -name "." ! -name ".." -delete
	    ls -la
        echo "echo 'Prepare as follows:'"                                            | tee    /home/$USER/start_ragEval.sh
		echo "echo '  Put your .md files in rag_eval_system-II/dataFolder, AND'"       | tee  -a  /home/$USER/start_ragEval.sh
		echo "echo '  place data.csv file in the rag_eval_system-II folder'"           | tee  -a  /home/$USER/start_ragEval.sh
		echo "echo '  data.csv has three columns: text,question,idealAnswer'"          | tee  -a  /home/$USER/start_ragEval.sh
		echo "echo '  A dummy data.csv and dummy .md files are placed'"              | tee  -a  /home/$USER/start_ragEval.sh
		echo "echo '==========='"                                                    | tee  -a  /home/$USER/start_ragEval.sh
		echo "echo '   '"                                                            | tee  -a  /home/$USER/start_ragEval.sh
		echo "echo 'Execute commands, as follows:   '"                               | tee  -a  /home/$USER/start_ragEval.sh
		echo "echo '  source /home/ashok/langchain/bin/activate'"                      | tee  -a  /home/$USER/start_ragEval.sh
	    echo "echo '  cd /home/$USER/ragsystem/rag_eval_system-II'"                    | tee  -a  /home/$USER/start_ragEval.sh
		# To ingest .md files in dataFolder
		echo "echo '  python main.py --ingest'"                                        | tee   -a /home/$USER/start_ragEval.sh     
	    echo "echo '  python main.py --query \"your question here\"'"                  | tee   -a /home/$USER/start_ragEval.sh
		# runs all 9 QA pairs through Judge LLM → evaluation_results.csv
	    echo "echo '  python main.py --evaluate'"                                      | tee   -a /home/$USER/start_ragEval.sh
		
		LINE="  21. RAG and RAG performance Eval system installed"
		if ! grep -qF "$LINE" "$FILE"; then
			echo "$LINE" >> "$FILE"
		fi
		#
	    echo "rageval_installed.txt"  > /home/$USER/rageval_installed.txt
else
	    echo "   "
fi


#############
# Install llamaindex folder of examples
# Installs the folder from github: LLM/llamaindex
############

#  Download github folder 'llamaindex' using command line
#  Can copy and paste all at once:
cd /home/$USER
if [ ! -f /home/$USER/llamaindexExamples_installed.txt ]; then
	cd ~/   
	echo "  "
	echo "   "
	echo "Installing llamaindexExamples"
	sleep 3
	rm -rf /home/$USER/Documents/llamaindexExamples
	mkdir -p /home/$USER/Documents/llamaindexExamples
	cd /home/$USER/Documents/llamaindexExamples
	git init
	git remote add origin https://github.com/harnalashok/LLMs.git
	git sparse-checkout init --cone
	git sparse-checkout set llamaindex
	git pull origin main
	find . -maxdepth 1 ! -name "llamaindex" ! -name "." ! -name ".." -delete
	cd /home/$USER/Documents
	mv llamaindexExamples/llamaindex/* .
	rm -rf /home/$USER/Documents/llamaindexExamples
	cd /home/$USER
	echo "llamaindexExamples_installed.txt" > /home/$USER/llamaindexExamples_installed.txt
else
	echo "  "
fi	

#############
# Install n8nModels folder of examples
# Installs the folder from github: LLM/n8nModels
############

#  Download github folder 'n8nModels' using command line
#  Can copy and paste all at once:
cd /home/$USER
if [ ! -f /home/$USER/n8nExamples_installed.txt ]; then
	cd ~/   
	echo "  "
	echo "   "
	echo "Installing n8n Models"
	sleep 3
	rm -rf /home/$USER/Documents/n8nExamples
	mkdir -p /home/$USER/Documents/n8nExamples
	cd /home/$USER/Documents/n8nExamples
	git init
	git remote add origin https://github.com/harnalashok/LLMs.git
	git sparse-checkout init --cone
	git sparse-checkout set n8nModels
	git pull origin main
	find . -maxdepth 1 ! -name "n8nModels" ! -name "." ! -name ".." -delete
	cd /home/$USER/Documents
	mv llamaindexExamples/n8nModels/* .
	rm -rf /home/$USER/Documents/llamaindexExamples
	cd /home/$USER
	echo "n8nExamples_installed.txt" > /home/$USER/n8nExamples_installed.txt
else
	echo "  "
fi	




##################
## Install agno
#  https://github.com/agno-agi/agno/tree/main/cookbook/00_quickstart
#  https://dineshr1493.medium.com/all-you-need-to-know-about-the-evolution-of-generative-ai-to-agentic-ai-part-9-agentic-ai-agno-74d74cd0d9f3
#  https://medium.com/@alexanddanik/building-multi-agent-trading-analysis-with-agno-framework-30a854cf1997
###############

cd /home/$USER
if [ ! -f /home/$USER/agno_installed.txt ]; then
	cd ~/  
	echo  "    "
	echo "    "
	echo "Installing agno"
	sleep 3
	deactivate
	rm -rf /home/$USER/agno
	git clone https://github.com/agno-agi/agno.git
	cd agno
	sleep 2
	uv venv .venvs/quickstart --python 3.12
	source .venvs/quickstart/bin/activate
	# Add more models for AGENTS
	echo "openai" >> /home/$USER/agno/cookbook/00_quickstart/requirements.in
	echo "anthropic" >> /home/$USER/agno/cookbook/00_quickstart/requirements.in
	echo "ollama" >> /home/$USER/agno/cookbook/00_quickstart/requirements.in
	cd /home/$USER/agno/cookbook/00_quickstart/
	./generate_requirements.sh
	cat /home/$USER/agno/cookbook/00_quickstart/requirements.txt
	uv pip install -r /home/$USER/agno/cookbook/00_quickstart/requirements.txt
	cd /home/$USER
	# Download an agent with tools
	mkdir -p /home/$USER/Documents/agno_tools
	cd /home/$USER/Documents/agno_tools
	wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/agno/agent_with_tools.py
	cd /home/$USER
	echo "agno_installed.txt" > /home/$USER/agno_installed.txt
	
	echo "echo 'What is agno?'"         							| 	tee    /home/$USER/start_agno.sh
	echo "echo '============'"         								| 	tee  -a  /home/$USER/start_agno.sh
	echo "echo '  Agno is the runtime for agentic software.'" 		|   tee  -a  /home/$USER/start_agno.sh
	echo "echo '  Build agents, teams, and workflows. '" 			|   tee  -a  /home/$USER/start_agno.sh
	echo "echo '  Run them as scalable services. '"					|   tee  -a  /home/$USER/start_agno.sh
	echo "echo '  Monitor and manage them in production.'"			|   tee  -a  /home/$USER/start_agno.sh
	echo "echo 'What it does'"										|   tee  -a  /home/$USER/start_agno.sh
	echo "echo '============'"         								| 	tee  -a  /home/$USER/start_agno.sh
	echo "echo 'Layer			What it does'"						|   tee  -a  /home/$USER/start_agno.sh
	echo "echo '-----			------------'"         								| 	tee  -a  /home/$USER/start_agno.sh
	echo "echo 'Framework 		Build agents, teams, and workflows with memory, knowledge, guardrails, and 100+ integrations.'"		|   tee  -a  /home/$USER/start_agno.sh
	echo "echo 'Runtime			Serve your system in production with a stateless, session-scoped FastAPI backend.'"					|   tee  -a  /home/$USER/start_agno.sh
	echo "echo 'Control Plane	Test, monitor, and manage your system using the AgentOS UI.'"										|   tee  -a  /home/$USER/start_agno.sh
	echo "echo '-----------      ---------------'"										|   tee  -a  /home/$USER/start_agno.sh
	echo "echo 'Installed at: /home/$USER/agno'"										|   tee  -a  /home/$USER/start_agno.sh
	echo "echo 'Invoking agent with ollama llama3.2...'"								|   tee  -a  /home/$USER/start_agno.sh
	echo "echo 'Make changes, if you like here: ~/Documents/agno/agent_with_tools.py'"  |   tee  -a  /home/$USER/start_agno.sh
	echo "sleep 3"																		|   tee  -a  /home/$USER/start_agno.sh
	echo "source /home/$USER/agno/.venvs/quickstart/bin/activate"										|   tee  -a  /home/$USER/start_agno.sh
	echo "python  /home/$USER/Documents/agno_tools/agent_with_tools.py"                 |   tee  -a  /home/$USER/start_agno.sh
	echo "sleep 5"																		|   tee  -a  /home/$USER/start_agno.sh
	echo "python /home/$USER/agno/cookbook/00_quickstart/run.py"						 |   tee  -a  /home/$USER/start_agno.sh
	chmod +x /home/$USER/*.sh
	LINE="  22. Agent Builder agno installed"
	if ! grep -qF "$LINE" "$FILE"; then
		echo "$LINE" >> "$FILE"
	fi
else
	echo "   "
fi

##################
## Install OpenBB
#  https://github.com/OpenBB-finance/OpenBB

###############

cd /home/$USER
if [ ! -f /home/$USER/openbb_installed.txt ]; then
    echo "   "
	echo "    "
	echo "Installing OpenBB.."
	sleep 3
	conda create --name openbb
	conda activate openbb
	pip install "openbb[all]"
	pip install openbb-cli
	# Start the server
	openbb-api
	echo "openbb_installed.txt"  >  /home/$USER/openbb_installed.txt
	conda deactivate
	LINE="  23. OpenBB installed"
	if ! grep -qF "$LINE" "$FILE"; then
		echo "$LINE" >> "$FILE"
	fi
fi	


##################
## Install TradingAgent
#  https://tradingagents-ai.github.io/
# https://github.com/TauricResearch/TradingAgents
# https://www.digitalocean.com/resources/articles/tradingagents-llm-framework
###############

cd /home/$USER
if [ ! -f /home/$USER/tradingAgent_installed.txt ]; then
    echo "   "
	echo "    "
	echo "Installing TradingAgents.."
	sleep 3
	git clone https://github.com/TauricResearch/TradingAgents.git
	cd TradingAgents
	conda create -n tradingagents python=3.13
	conda activate tradingagents
	conda activate tradingagents
	conda create -n tradingagents python=3.13
	conda activate tradingagents
	cd TradingAgents
	conda activate tradingagents
	pip install -r requirements.txt
	sed -i '/qwen3:latest/a\("Qwen3.5:latest", "qwen3.5:latest"),' /home/$USER/TradingAgents/cli/utils.py
	sed -i '/qwen3:latest/a\("llama3.2:latest", "llama3.2:latest"),' /home/$USER/TradingAgents/cli/utils.py
	cp .env.example .env
	mkdir -p /home/$USER/Documents/TradingAgents
	cd /home/$USER/Documents/TradingAgents
	wget -c https://arxiv.org/abs/2412.20138
	mv 2412.20138  TradingAgents.pdf
	cd /home/$USER
	#python -m cli.main
	echo "tradingAgent_installed.txt"  > /home/$USER/tradingAgent_installed.txt
	LINE="  24. Trading Agent installed"
	if ! grep -qF "$LINE" "$FILE"; then
		echo "$LINE" >> "$FILE"
	fi
	conda deactivate
	cd
else
    echo "   "
fi


##################
## Install Qlib
# Open-source AI quantitative investment platform
## https://github.com/microsoft/qlib?tab=readme-ov-file
###############



##########################
### Upgrade/Repair ragflow
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
	cd /home/$USER
	if [ ! -f /home/$USER/ragflowUpgraded_installed.txt ]; then
	    echo "   "
		echo "    "
		echo "======="
		echo "Shall I upgrade/Repair RAGFlow docker? [Y,n]"   
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
			echo "ragflowUpgraded_installed.txt" > /home/$USER/ragflowUpgraded_installed.txt
			LINE="  25. RagFlow"
			if ! grep -qF "$LINE" "$FILE"; then
				echo "$LINE" >> "$FILE"
			fi
		else
	    	echo "RagFlow Not upgraded"
		fi
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
	echo "Shall I install RAGFlow docker? [Y,n]" 
	echo "Press ENTER to skip"# 
	read input
	#input=${input:-Y}
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
	fi
fi	

docker update --restart=no $(docker ps -a -q)
clear
echo "   "
echo "   "
echo "==============="
echo "You can skip rest of the install."
echo "Press ctrl+c now to skip"
echo "Else, press ENTER to continue"
echo "=============="
echo "   "
echo "   "
read x
 
#####################
## langflow install
####################

cd /home/$USER
if [ ! -f /home/$USER/langflow_installed.txt ]; then
    echo " "
    echo " "
	echo "------------"  
	echo "Shall I install langflow. Takes a lot of time..? [Y,n]"    
	read input
	#input=${input:-Y}
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
		# We earlier created a virtual env: venv
		# Existing environment, if it exists, is first deleted
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
		ln -sT /home/$USER/start/start_uv_langflow.sh       /home/$USER/start_langflow.sh  
		chmod +x /home/$USER/*.sh
		chmod +x /home/$USER/start/*.sh
		chmod +x /home/$USER/stop/*.sh
		echo "langflow_installed.txt" > /home/$USER/langflow_installed.txt
		sleep 2
		LINE="  26. Langflow installed"
		  if ! grep -qF "$LINE" "$FILE"; then
			echo "$LINE" >> "$FILE"
		  fi
		sudo systemctl reboot -i
	else
		echo "langflow NOT installed"
	fi
else
    echo "    "
fi	


##########################
### Install OpenNotebook
# Ref: https://github.com/lfnovo/open-notebook/blob/main/docs/1-INSTALLATION/docker-compose.md
##########################

cd /home/$USER
if [ ! -f /home/$USER/opennotebook_installed.txt ]; then
    echo " "
    echo " "
	echo "------------"  
	echo "Shall I install OpenNotebook docker? [Y,n]"     
	echo "Press ENTER to skip"
	read input
	#input=${input:-Y}
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
		LINE="  27. OpenNotebook installed"
		  if ! grep -qF "$LINE" "$FILE"; then
			echo "$LINE" >> "$FILE"
		  fi
		sudo systemctl reboot -i
	else
	    echo "OpenNotebook not installed"
	fi
else
    echo "    "
fi



#####################3
# portrainer docker
######################

cd /home/$USER
if [ ! -f /home/$USER/portainer_installed.txt ]; then
	echo "------------"        
	echo "Shall I install portainer docker? [Y,n]"    # Else docker chromadb may be installed
	echo "Press ENTER to skip"
	read input
	#input=${input:-Y}
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
	   
	   LINE="  28. Portainer installed"
	   if ! grep -qF "$LINE" "$FILE"; then
		 echo "$LINE" >> "$FILE"
	   fi
	   sudo systemctl reboot -i
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
	echo "Press ENTER to skip"
	read input
	#input=${input:-Y}
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
		LINE="  29. ngrok installed"
	    if ! grep -qF "$LINE" "$FILE"; then
		 echo "$LINE" >> "$FILE"
	    fi
		sudo systemctl reboot -i
	else
	   echo "ngrok not installed"
	fi  
else
   echo "   "
fi


##########################
### Install dify
# Ref: https://github.com/langgenius/dify?tab=readme-ov-file#quick-start
##########################
  
    echo " "
    echo " "
    echo "------------"   
    echo "Shall I install dify docker? [Y,n]"    # 
	echo "Press ENTER to skip"
    read input
    #input=${input:-Y}
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
		sudo systemctl reboot -i
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
echo "Press ENTER to skip"
read input
#input=${input:-Y}
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
echo "Press ENTER to skip"
read input
#input=${input:-Y}
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
   sudo systemctl reboot -i
else
    echo "Mongodb for Ubuntu24.04 not installed"
fi   

# Prevent docker restarts on OS reboot
docker update --restart=no $(docker ps -a -q)


###################
# llama.cpp install--II
# python env remains activated
# source /home/$USER/venv/bin/activate
###################
echo "  "
echo " "
cd /home/$USER
echo " "
echo " "
if [ ! -f /home/$USER/llamacpp_installed.txt ]; then
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
	echo "Press ENTER to skip"
	read input
	#input=${input:-Y}
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
	  echo "llamacpp_installed.txt"  > /home/$USER/llamacpp_installed.txt
	  echo "Will reboot system now"
	  chmod +x /home/$USER/start/*.sh
	  chmod +x /home/$USER/*.sh
	  sleep 5
	  sudo systemctl reboot -i
	else
	  echo "Skipping install of llama.cpp"
	fi
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
	echo "(not recommended approach) Press ENTER to skip"
	read input
	#input=${input:-Y}
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
		sudo systemctl reboot -i
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
	echo "Recommended approach. Press ENTER to skip"
	read input
	#input=${input:-Y}
	if [[ $input == "Y" || $input == "y" ]]; then
	   # Create a new virtual env
	   rm -rf /home/$USER/xinference
	   python3 -m venv --clear /home/$USER/xinference
	   source /home/$USER/xinference/bin/activate
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
	    echo "source /home/$USER/xinference/bin/activate"          >> /home/$USER/start_xinference.sh
	    echo "xinference-local --host 0.0.0.0 --port 9997"        >> /home/$USER/start_xinference.sh
	    #
	    #--------------
	    echo '#!/bin/bash'                                         >  /home/$USER/launch_xinference.sh
	    echo " "                                                   >> /home/$USER/launch_xinference.sh
	    echo "Launching xinference bge-reranker-v2-m3"              >> /home/$USER/launch_xinference.sh
	    echo "cd /home/$USER"                                     >> /home/$USER/launch_xinference.sh
	    echo "source /home/$USER/xinference/bin/activate"          >> /home/$USER/launch_xinference.sh
	    echo "xinference launch --model-name bge-reranker-v2-m3 --model-type rerank --model-engine vllm --model-format pytorch --quantization none --replica 1 --gpu_memory_utilization 0.7 "     >> /home/$USER/launch_xinference.sh
	    #    
	    chmod +x *.sh
		echo "Will reboot system now"
	    sleep 5
		LINE="     Xinference installed in its virtual env"
	    if ! grep -qF "$LINE" "$FILE"; then
	       echo "$LINE" >> "$FILE"
	    fi
		sudo systemctl reboot -i
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
echo "Press ENTER to skip"
read input
#input=${input:-Y}
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
	sudo systemctl reboot -i
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
	echo "Press ENTER to skip"
	read input
	#input=${input:-Y}
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
		sudo systemctl reboot -i
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
	echo "Press ENTER to skip"
	read input
	#input=${input:-Y}
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
		sudo systemctl reboot -i
	else
		   echo "TorchStudio not installed"
	fi   
fi


