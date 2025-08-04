#!/bin/bash

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
    chmod +x /home/$USER/*.sh
    # Create links
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
else
   echo "Postgres not installed"
 fi  




#########################################
