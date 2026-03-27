#!/bin/bash

# Last amended: 15th Feb, 2026

clear
# Are we having wsl systems
WSL=$(cat /proc/version)
WSLSYSTEM="false"
if echo "$WSL" | grep -qi wsl ; then
    WSLSYSTEM="true"
fi

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


if [ "$WSLSYSTEM" = "true" ]; then
	echo "  "
	echo "=====***======"
	echo "WSL ubuntu WINDOW will close many times during installation"
	echo "Each time, double click to open it, and each time "
	echo "issue the command:"
	echo "            ./ollama_wsl_nogpu.sh"
	echo "   Answer Y to most questions"
	echo "      till, all software is installed."
	echo "   You may have to supply your ubuntu pasword"
	echo "================"
	echo "   "
	echo "   "
	echo "    "
	echo -en "\007"
else
	echo "  "
	echo "=====***======"
	echo "Ubuntu will reboot many times during installation"
	echo "Each time, double click to open it, and each time "
	echo "issue the command:"
	echo "            ./ollama_wsl_nogpu.sh"
	echo "   Answer Y to most questions"
	echo "      till, all software is installed."
	echo "   You may have to supply your ubuntu pasword"
	echo "================"
	echo "   "
	echo "   "
	echo "    "
	echo -en "\007"
fi



cd /home/$USER
if [ ! -f /home/$USER/first_time.txt ]; then
    sleep 15
    echo "  "
    echo "------------"                            
	echo "========script=============="
	echo "Will update Ubuntu and install nodejs and uv"
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
	echo 'export HISTTIMEFORMAT="%F %T "'  >> /home/$USER/.bashrc
	sudo apt install npm
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
	echo "  "
	echo "  "
	echo "===="
	# Install uv
	echo "===="
	echo "  "
	curl -LsSf https://astral.sh/uv/install.sh | sh
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
	# Print IP of machine while opening terminal
	echo "hostname -I | awk '{print \$1}'  " >> /home/$USER/.bashrc
	sleep 3
    if [ "$WSLSYSTEM" = "true" ] ; then
        # WSL installed
        echo "====NOTE====="
        echo "Ubuntu shell will be closed several times. After each closure, double-click to reopen it."
		echo  "  And reexcute the following script: "
		echo  "  No need to reboot Windows machine"
        echo " "
        echo "=>   ./ollama_wsl_nogpu.sh"
        echo "=========="
        sleep 15
        wsl.exe --shutdown
    else
        echo "====NOTE====="
        echo "Machine will be rebooted several times. After each reboot, execute the following script:"
        echo " "
        echo "=>   ./ollama_wsl_nogpu.sh"
        echo "=========="
        sleep 15
        reboot
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
    if [ "$WSLSYSTEM" = "true" ] ; then
        wsl.exe --shutdown
    else
        reboot
    fi  
fi


##################
# Docker installation-II
#################

cd /home/$USER
if [ ! -f /home/$USER/docker_installed_1.txt ]; then
    # Ref: https://docs.docker.com/engine/install/ubuntu/
    #      https://docs.docker.com/engine/install/linux-postinstall/
	mkdir /home/$USER/docker
	cd /home/$USER/docker
	echo "Download script to print names of docker containers"
	wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/docker/names_dockers.sh
	chmod +x *.sh
	cd /home/$USER
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
   if [ "$WSLSYSTEM" = "true" ] ; then
        wsl.exe --shutdown
    else
       reboot
    fi  
else
    echo "Docker installation process completed"
	# Prevent any docker restarts on OS reboot
    docker update --restart=no $(docker ps -a -q)
fi    


##############
# Create python virtual env
# source /home/$USER/venv/bin/activate
##############

if [ ! -f /home/$USER/venv_installed.txt ]; then
    cd /home/$USER
    echo " "
    echo " "
    echo "------------"        
        # Clear earlier directory, if it exists
        python3 -m venv --clear /home/$USER/venv
        source /home/$USER/venv/bin/activate
        # 1.6 Essentials software
        pip install spyder numpy scipy pandas matplotlib sympy cython
        pip install jupyterlab
        pip install ipython
        pip install notebook
        pip install streamlit
		# To connect to postgresql
		pip install psycopg2
        echo "venv_installed.txt" > /home/$USER/venv_installed.txt
        # Required for spyder:
		echo " "
		echo " "
		echo -en "\007"
        sudo apt install pyqt5-dev-tools -y
		echo "####"
		echo "Install pdfminer to extract text from pdf"
		# Ref: https://github.com/pdfminer/pdfminer.six
		pip install pdfminer.six
		echo "####"
		sudo apt install pyqt5-dev-tools -y
		echo "Install pymupdf4llm to extract text/json"
		# Ref: https://github.com/pymupdf/pymupdf4llm
		pip install pymupdf4llm pymupdf4llm[layout]
		mkdir -p /home/$USER/Documents/samples/in
		mkdir -p /home/$USER/Documents/samples/out
		cd /home/$USER/Documents/samples
        wget -nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/misc/convert_pdf_to_text.py
		cd /home/$USER
		echo "####"
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
        ln -sT /home/$USER/start/start_milvus.sh        /home/$USER/start_milvus.sh  
		ln -sT /home/$USER/stop/stop_milvus.sh          /home/$USER/stop_milvus.sh  
		ln -sT /home/$USER/start/delete_milvus_db.sh    /home/$USER/delete_milvus_db.sh  
		#
		echo "milvus_installed.txt" > /home/$USER/milvus_installed.txt
		sleep 3
		chmod +x /home/$USER/*.sh
		chmod +x /home/$USER/start/*.sh
		chmod +x /home/$USER/stop/*.sh
		wsl.exe --shutdown
	
	echo "Milvus db is installed"
fi	


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
		wsl.exe --shutdown
   
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
		chmod +x /home/$USER/*.sh
		wsl.exe --shutdown
	  
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
	echo "------------"   
	    cd ~/
	    mkdir /home/$USER/n8n  # Redundant step
	    #cd /home/$USER/n8n
	    # Volumes are automatically created below: /var/lib/docker/volumes/
		#                                          /var/lib/docker/volumes/n8n_data/_data
	    docker volume create n8n_data
	    #   https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
	    #   https://docs.n8n.io/hosting/scaling/memory-errors/#increase-old-memory
	    # Access at localhost:5678
	    # --rm implies remove docker when stopped. So docker will not show up in 'docker ps -a' call
	    # docker run -it -d --rm  --network host   --name n8n -p 5678:5678 -e NODE_OPTIONS="--max-old-space-size=4096" --network host  -v n8n_data:/home/n8n/node/.n8n docker.n8n.io/n8nio/n8n
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
		echo "echo 'n8n community nodes available at:'"                                                                           >> /home/$USER/start_n8n.sh
	    echo "echo '==>    https://ncnodes.com/packages'"                                                                          >> /home/$USER/start_n8n.sh
	    echo "echo 'Use \"top -u $USER\" OR \"free -g \" command to see memory usage'"                                             >>  /home/$USER/start_n8n.sh
	    echo "sleep 9"                                                                                                             >> /home/$USER/start_n8n.sh
	    #echo "cd /home/$USER/n8n"                                                                                                  >> /home/$USER/start_n8n.sh
	    echo "docker run -it -d --rm --name n8n -p 5678:5678 -e NODE_OPTIONS=\"--max-old-space-size=4096\" --network host -v n8n_data:/home/node/.n8n docker.n8n.io/n8nio/n8n"   >> /home/$USER/start_n8n.sh
		# n8n community nodes
		echo '#!/bin/bash'                                                                                                        > /home/$USER/comm_node_n8n.sh
		echo " "                                                                                                                  >> /home/$USER/comm_node_n8n.sh
		echo "echo 'List of community nodes to install:'"                                                                         >> /home/$USER/comm_node_n8n.sh
		echo "echo 'n8n community nodes available at:'"                                                                           >> /home/$USER/comm_node_n8n.sh
		echo "echo '==>    https://ncnodes.com/packages'"                                                                          >> /home/$USER/comm_node_n8n.sh
		echo "echo '  1. n8n-nodes-crawl4ai-enhanced'"                                                                             >> /home/$USER/comm_node_n8n.sh
		echo "sleep 9"                                                                                                             >> /home/$USER/comm_node_n8n.sh
		cd ~/
	    mkdir -p /home/$USER/Documents/n8n
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
		echo "n8n_installed.txt "  > /home/$USER/n8n_installed.txt
		sleep 3
		chmod +x /home/$USER/*.sh
		wsl.exe --shutdown
	
fi	


##########################
### ollama docker for CPU
##########################

echo " "
echo " "
cd /home/$USER
if [ ! -f /home/$USER/ollama_installed.txt ]; then
  echo "------------"   
  echo "------------"   
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
  echo "Will install ollama for CPU..."
  sleep 4
  # Creating alias for command: docker exec -it ollama
  echo "alias ollama='docker exec -it ollama ollama'" >> /home/$USER/.bashrc
  echo "docker start ollama"                          >> /home/$USER/.bashrc
  echo "echo 'Ollama docker started'"                  >> /home/$USER/.bashrc
  #docker run -d --gpus=all -v /home/$USER/ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
  # network host would be local mashine
  echo -en "\007"
  docker run -d  -v ollama:/root/.ollama -p 11434:11434 --network host --name ollama ollama/ollama
  echo "ollama_installed.txt " > /home/$USER/ollama_installed.txt
  sleep 2
  chmod +x /home/$USER/*.sh
  wsl.exe --shutdown
fi	


##########################
### Download some minimum ollama models
##########################

echo " "
echo " "
if [ ! -f /home/$USER/models_installed.txt ]; then
	 echo "------------"   
	  cd /home/$USER/
	  # Start ollama docker in future
	  docker start ollama 
	  sleep 4
	  ollama list
	  sleep 2
	  echo "Pulling bge-m3"
	  docker exec -it ollama ollama pull bge-m3
	  docker exec -it ollama ollama pull nomic-embed-text
	  echo "Pulling llama3.2 and small models"
	  docker exec -it ollama ollama pull llama3.2:latest
	  docker exec -it ollama ollama pull llama3.2:1b
	  docker exec -it ollama ollama pull deepseek-r1:1.5b
	  docker exec -it ollama ollama pull qllama/bge-small-en-v1.5
	  echo " "
	  echo " "
	  #ollama list
	  echo "models installed" > /home/$USER/models_installed.txt
	  sleep 2
	  chmod +x /home/$USER/*.sh
	  wsl.exe --shutdown
fi


#####################3
# flowise docker
# https://docs.flowiseai.com/getting-started#docker-compose
######################

echo " "
echo " "
cd /home/$USER
if [ ! -f /home/$USER/flowise_installed.txt ]; then
   echo "------------"   
   cd /home/$USER/
   #####################3
	# flowise docker
	# Ref: https://docs.flowiseai.com/getting-started#docker-compose
	######################
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
   cd /home/$USER/
   echo "In future to start/stop containers, proceed, as:"
   echo "            cd /home/$USER/Flowise"                  
   echo "            docker start docker-flowise-1"                    
   echo "            docker stop docker-flowise-1"                     
   echo " Also, check all containers available, as:"
   echo "             docker ps -a "     
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
   wsl.exe --shutdown
fi



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
			# Accept all conda channels
			conda tos accept
			# Install postgresql client
	 		conda install -c conda-forge psycopg2  -y
			# Download script to create conda venv
			wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/quick_flowise_ollama/venv/create_conda_venv.sh -P /home/$USER
			echo "anaconda_installed.txt" > /home/$USER/anaconda_installed.txt
			chmod +x /home/$USER/*.sh
			chmod +x /home/$USER/start/*.sh
			chmod +x /home/$USER/stop/*.sh
			wsl.exe --shutdown
	     else
	        echo "Anaconda is already installed in /home/$USER/anaconda3"
	     fi   
	fi	 
 
################
# Install postgresql and sqlite3
################

echo " "
echo " "
cd /home/$USER
if [ ! -f /home/$USER/postgresql_installed.txt ]; then
	echo "------------"   
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
		sleep 3
		sudo -u postgres psql -c 'create user ravi ;'
		sudo -u postgres psql -c 'CREATE DATABASE ravi WITH OWNER = ravi;  '
		sudo -u postgres psql -c "alter user ravi with encrypted password 'ravi';"
		#sudo -u postgres psql -c "CREATE EXTENSION vector;" -d ravi
		cd /home/$USER/psql
		wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/psql/simpleTable.sql
		cd /home/$USER
		PGPASSWORD="ravi"  psql -U ravi -d ravi -h localhost -f /home/$USER/psql/simpleTable.sql
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
		sleep 3
		wsl.exe --shutdown
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
		sleep 4
		cd /homne/$USER/
		echo "faiss_installed.txt" > /home/$USER/faiss_installed.txt
		wsl.exe --shutdown
	
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
	pip install streamlit
	# Required for spyder:
	sudo apt install pyqt5-dev-tools -y
	# Huggingface and llama.cpp related
	pip install huggingface_hub
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
	pip install langchain
	pip install langchain-openai
	 pip install langchain-ollama
	pip install langchain-community
	pip install langchain-experimental
	pip install langgraph
	pip install "langserve[all]"
	pip install langchain-cli
	pip install unstructured
	pip install unstructured[md]
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
	LINE="  16. langchain and langgraph virtual env, 'langchain', created."
	if ! grep -qF "$LINE" "$FILE"; then
		echo "$LINE" >> "$FILE"
	fi
	wsl.exe --shutdown
else
    echo "  "
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
	mkdir llamaindex
	cd llamaindex
	mv /home/$USER/Documents/llamaindexExamples/llamaindex/* .
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
	mkdir n8nModels
	cd n8nModels
	mv /home/$USER/Documents/n8nExamples/n8nModels/* .
	rm -rf /home/$USER/Documents/n8nExamples
	cd /home/$USER
	echo "n8nExamples_installed.txt" > /home/$USER/n8nExamples_installed.txt
else
	echo "  "
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
		# Check health of system
		curl http://localhost:5055/health
		touch "opennotebook_installed.txt" > /home/$USER/opennotebook_installed.txt
		cd /home/$USER
		echo "Open browser to: http://localhost:8502"
	else
	    echo "OpenNotebook not installed"
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

 

