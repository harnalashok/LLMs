#!/bin/bash

# Last amended: 23rd July, 2025



echo "========script=============="
echo "Will update Ubuntu"
echo "Will install flowise docker"
echo "Will install ollama docker for gpu"
echo "Will install chromadb docker"
echo "Will install n8n docker"
echo "Will install dify docker"
echo "Will install mongodb and mongosh:
echo "Installs postgres db and pgvector"
echo "Will install Ragflow docker"
echo "==========================="
sleep 2


################
# Update Ubuntu
# Also install postgresql
################

cd /home/$USER
if [ ! -f /home/$USER/foo.txt ]; then
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
    echo "Ubuntu being updated" > /home/$USER/foo.txt   # To avoid repeat updation
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
    if [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
        echo "====NOTE====="
        echo "Ubuntu shell will be closed. Then reopen it and execute following three scripts in sequence:"
        echo "And, after executing EACH script, close ubuntu shell again."
        echo " "
        echo "1=>   ./ubuntu_docker1.sh "
        echo "2=>   ./ubuntu_docker2.sh "
        echo "3=>   ./ollama_flowise_chroma_n8n.sh"
        echo "=========="
        sleep 15
        wsl.exe --shutdown
    else
        echo "====NOTE====="
        echo "Machine will be rebooted. After reboot, execute following three scripts in sequence:"
        echo "And, after executing EACH script, reboot the machine"
        echo " "
        echo "1=>   ./ubuntu_docker1.sh "
        echo "2=>   ./ubuntu_docker2.sh "
        echo "3=>   ./ollama_flowise_chroma_n8n.sh"
        echo "=========="
        sleep 15
        reboot
    fi
fi
# Check if docker is installed
if command -v docker &> /dev/null; then
    echo "Docker is installed."
else
    echo "Docker is not installed."
    echo "====NOTE====="
    echo "Execute following scripts in sequence"
    echo " "
    echo "1=>   ./ubuntu_docker1.sh "
    echo "2=>   ./ubuntu_docker2.sh "
    echo "3=>   ./ollama_flowise_chroma_n8n.sh"
    echo "=========="
    sleep 15
 fi

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



##########################
### Install RAGflow
# Ref: https://github.com/infiniflow/ragflow
   
##########################

echo " "
echo " "
echo "------------"   
echo "Shall I install RAGFlow docker? [Y,n]"    # 
read input
input=${input:-Y}
if [[ $input == "Y" || $input == "y" ]]; then
    cd /home/$USER/
    echo "Installing RagFlow docker"
    echo "After installation, access ragflow, as: http://<hostIP>:800"
    sleep 5
    # Start script
    echo '#!/bin/bash'                                         >  /home/$USER/start_ragflow.sh
    echo " "                                                   >> /home/$USER/start_ragflow.sh
    echo "echo '======'"                                       >> /home/$USER/start_ragflow.sh
    echo "echo 'RagFlow port is 800'"                          >> /home/$USER/start_ragflow.sh
    echo "echo 'Access ragflow, as: http://<hostIP>:800'"      >> /home/$USER/start_ragflow.sh
    echo "echo '======'"                                       >> /home/$USER/start_ragflow.sh
    echo "sleep 4"                                             >> /home/$USER/start_ragflow.sh
    echo "cd /home/$USER/ragflow/docker"                        >> /home/$USER/start_ragflow.sh
    echo "docker compose -f docker-compose-gpu.yml up -d"       >> /home/$USER/start_ragflow.sh
    echo "netstat -aunt | grep 800"                             >> /home/$USER/start_ragflow.sh
    # Stop script
    echo '#!/bin/bash'                                        >  /home/$USER/stop_ragflow.sh
    echo " "                                                  >> /home/$USER/stop_ragflow.sh
    echo "cd ~/"                                              >> /home/$USER/stop_ragflow.sh
    echo "echo 'ragflow Stopping'"                            >> /home/$USER/stop_ragflow.sh
    echo "cd /home/$USER/ragflow/docker"                      >> /home/$USER/stop_ragflow.sh
    echo "docker compose -f docker-compose-gpu.yml stop "     >> /home/$USER/stop_ragflow.sh
    chmod +x /home/$USER/*.sh
    chmod +x /home/$USER/*.sh
    sudo sysctl -w vm.max_map_count=262144
    git clone https://github.com/infiniflow/ragflow.git
    cd ragflow/docker
    sed -i 's/80:80/800:80/' docker-compose-gpu.yml
    sed -i 's/443:443/1443:443/' docker-compose-gpu.yml
    docker compose -f docker-compose-gpu.yml up -d
    # docker update --restart=no [container_name_or_id]
    echo " "
    echo " "
    echo "==========="
    echo "Will Initialise ragflow. Use ctrl+c to break AFTER process has started."
    echo "==========="
    echo " "
    echo " "
    sleep 5
    docker logs -f ragflow-server
else
     echo "Ragflow will not be installed"
fi    
# Prevent docker restarts on OS reboot
docker update --restart=no $(docker ps -a -q)

docker update --restart=no $(docker ps -a -q)

