#!/bin/bash

# Last amended: 8th July, 2025
# Copyright:: 


echo "========script1=============="
echo "Will update Ubuntu"
echo "Will install necessary packages"
echo "Will install postgresql & sqlite3"
echo "Will install Ollama quietly"
echo "Will install Fast Node Manager (fnm)"
echo "Will install uv for langflow install"
echo "Will install chromadb"
echo "Install apache2 webserver"
echo "Reboot machine and call script2.sh"
echo "==========================="
sleep 10


cd ~/

echo " "                                       | tee -a /home/$USER/error.log
echo "*********"                               | tee -a /home/$USER/error.log
echo "Script: script1.sh"                      | tee -a /home/$USER/error.log
echo "**********"                              | tee -a /home/$USER/error.log
echo " "                                       | tee -a /home/$USER/error.log

################
# Update Ubuntu
# Also install postgresql
################


echo "  "
echo "------------"                            | tee -a /home/$USER/error.log
echo " Will update Ubuntu"                     | tee -a /home/$USER/error.log
echo " You will be asked for password...supply it..."
echo "----------"                              | tee -a /home/$USER/error.log
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
echo "Ubuntu upgraded ......"                | tee -a /home/$USER/error.log
echo "1. Ubuntu upgraded ......"             | tee -a /home/$USER/info.log

# Folders for start/stop scripts
mkdir /home/$USER/start
mkdir /home/$USER/stop
mkdir /home/$USER/psql


################
# Install Ollama
################


echo "Shall I install Ollama directly OR you want to install ollama docker latter? [Y,n]"    # Else docker ollama may be installed
read input
# Provide a default value of yes to 'input' 'https://stackoverflow.com/a/2642592
input=${input:-Y}
if [[ $input == "Y" || $input == "y" ]]; then
    # Installing ollama
    echo " "
    echo " "
    echo "------"
    echo "Installing ollama quietly. Takes time...."  | tee -a /home/$USER/error.log
    echo "When asked, supply password"
    echo "No messages will appear on screen"
    echo "------"
    echo " "
    echo " "
    curl -fsSL https://ollama.com/install.sh | sh      
    # Disable ollama on start
    sudo systemctl disable ollama
    # Stop ollama, if running
    sudo systemctl stop ollama
    
    echo "---------"                                    | tee -a /home/$USER/error.log
    echo "Ollama installed"                             | tee -a /home/$USER/error.log
    echo "9. Ollama installed"                          | tee -a /home/$USER/info.log
    echo "   ollama listens at port: 11434"             | tee -a /home/$USER/info.log
    echo "-----------"                                  | tee -a /home/$USER/error.log
    echo " "                                            | tee -a /home/$USER/error.log
    echo "You may start ollama in the background, as:"  | tee -a /home/$USER/info.log
    echo "    ollama serve &  > /dev/null & "           | tee -a /home/$USER/info.log
    echo "Or, as:"                                      | tee -a /home/$USER/info.log
    echo "sudo systemctl start|stop|restart ollama"     | tee -a /home/$USER/info.log  
    
    
    # Ollama start script:
    echo '#!/bin/bash'                                         | tee  /home/$USER/start/start_ollama.sh  
    echo "echo ' ' "                                           | tee -a /home/$USER/start/start_ollama.sh  
    echo "cd /home/$USER"                                               | tee -a /home/$USER/start/start_ollama.sh  
    echo "echo 'Ollama will be available at port 11434'"       | tee -a /home/$USER/start/start_ollama.sh  
    echo "echo 'You can also start ollama, as: ollama serve'"  | tee -a /home/$USER/start/start_ollama.sh  
    echo "echo ' ' "                                           | tee -a /home/$USER/start/start_ollama.sh  
    echo "echo '========'"                                     | tee -a /home/$USER/start/start_ollama.sh  
    echo "echo 'Look for ollama models in folder:'"           | tee -a /home/$USER/start/start_ollama.sh  
    echo "echo '       sudo ls -la /usr/share/ollama/.ollama/models/manifests/registry.ollama.ai/library/'"  | tee -a /home/$USER/start/start_ollama.sh  
    echo "echo '========'"                                     | tee -a /home/$USER/start/start_ollama.sh  
    echo "echo ' ' "                                           | tee -a /home/$USER/start/start_ollama.sh  
    echo "sleep 4"                                             | tee -a /home/$USER/start/start_ollama.sh  
    echo "sudo systemctl start ollama"                         | tee -a /home/$USER/start/start_ollama.sh  
    echo "netstat -aunt | grep 11434"                          | tee -a /home/$USER/start/start_ollama.sh  
    
    # Ollama stop script
    echo '#!/bin/bash'                                         | tee -a /home/$USER/stop/stop_ollama.sh  
    echo " "                                                   | tee -a /home/$USER/stop/stop_ollama.sh  
    echo "cd ~/"                                               | tee -a /home/$USER/stop/stop_ollama.sh  
    echo "echo 'Ollama will be stopped'"                       | tee -a /home/$USER/stop/stop_ollama.sh  
    echo "sudo systemctl stop ollama"                          | tee -a /home/$USER/stop/stop_ollama.sh  
    echo "netstat -aunt | grep 11434"                          | tee -a /home/$USER/stop/stop_ollama.sh  
    
    # PRemission changes
    chmod +x /home/$USER/start/*.sh   
    chmod +x /home/$USER/stop/*.sh
else
        echo "Skipping install of Ollama"
fi    

# Copy earlier created scripts
cp /home/$USER/find_venv.sh  /home/$USER/start/
cp /home/$USER/find_venv.sh  /home/$USER/stop/
sleep 2

################
## Download embedding models
################

echo "Downloading embedding models"
echo "Try them when your RAG answers are not that good"
sudo systemctl start ollama

echo "1. nomic-embed-text"
ollama pull nomic-embed-text
echo "2. mxbai-embed-large"
ollama pull mxbai-embed-large
echo "3. snowflake-arctic-embed:335m"
ollama pull snowflake-arctic-embed:335m
echo "4. snowflake-arctic-embed2"
ollama pull snowflake-arctic-embed2
echo "5. timyllama download"
ollama pull tinyllama
echo "6. whisper-tiny download"
ollama pull dimavz/whisper-tiny
echo "7. tinyagent download"
ollama pull andthattoo/tinyagent-1.1b

echo " "
echo " "
echo "============="
echo "Consider downloading the following ollama models"
echo "      1. llama3.2:latest"
echo "      2. codestral (size:12gb) for coding help; deepcoder (size:9gb) " 
echo "      3. gemma3:latest or better gemma3:12b"
echo "      4. mistral:latest"
echo "      5. qwen3:latest"
echo "============="




################
# Install postgresql and sqlite3
################

echo "Installing postgresql and sqlite3"
sudo apt install postgresql postgresql-contrib sqlite3   -y

# Postgresql start/stop script
echo '#!/bin/bash'                                                      > /home/$USER/start/start_postgresql.sh  
echo " "                                                               >> /home/$USER/start/start_postgresql.sh  
echo "cd ~/"                                                           >> /home/$USER/start/start_postgresql.sh  
echo "echo 'postgresql will be available on port 5432'"                >> /home/$USER/start/start_postgresql.sh  
echo "sudo systemctl start postgresql.service"                         >> /home/$USER/start/start_postgresql.sh  
echo "sleep 2"                                                         >> /home/$USER/start/start_postgresql.sh  
echo "netstat -aunt | grep 5432"                                       >> /home/$USER/start/start_postgresql.sh  

echo '#!/bin/bash'                                                      > /home/$USER/stop/stop_postgresql.sh  
echo " "                                                               >> /home/$USER/stop/stop_postgresql.sh  
echo "cd ~/"                                                           >> /home/$USER/stop/stop_postgresql.sh  
echo "sudo systemctl stop postgresql.service"                          >> /home/$USER/stop/stop_postgresql.sh  
echo "sleep 2"                                                         >> /home/$USER/stop/stop_postgresql.sh  
echo "netstat -aunt | grep 5432"                                       >> /home/$USER/stop/stop_postgresql.sh  

cd /home/$USER/psql
ln -sT /home/$USER/stop/stop_postgresql.sh stop_postgresql.sh
ln -sT /home/$USER/start/start_postgresql.sh start_postgresql.sh
cd ~/

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

# Creating user 'ashok', and database 'ashok'. 
# User 'ashok' has full authority over database 'ashok'
echo " "
echo " "
echo "========="
echo "Creating user 'ashok' and database 'askok'"
echo "User 'ashok' has full authority over database 'ashok'"
echo "User 'ashok' has password: ashok"
echo "========="
echo " "
echo " "
sleep 5
sudo -u postgres psql -c 'create database ashok;'
sudo -u postgres psql -c 'create user ashok;'
sudo -u postgres psql -c 'grant all privileges on database ashok to ashok;'
sudo -u postgres psql -c "alter user ashok with encrypted password 'ashok';"
# Test the above, as:
#   PGPASSWORD=qwerty psql -h localhost -p 5432 -U ashok -d ashok  
#   CREATE TABLE acars (  brand VARCHAR(255),  model VARCHAR(255),  year INT);
#   select * from acars ;

INSERT INTO cars (brand, model, year)
VALUES ('Ford', 'Mustang', 1964); 

###########
# Fast Node Manager install
############

# Install 'fnm' (Fast Node Manager)
echo " "                                       | tee -a /home/$USER/error.log
echo "Will install fnm: Fast Node Manager..."  | tee -a /home/$USER/error.log
echo "------------------"                      | tee -a /home/$USER/error.log
sleep 9
sudo curl -fsSL https://fnm.vercel.app/install | bash   2>> /home/$USER/error.log
echo "Fast Node Manager (fnm) installed"       | tee -a /home/$USER/error.log
echo "2. Fast Node Manager (fnm) installed"    | tee -a /home/$USER/info.log



###########
# uv install
# An extremely fast Python package and project manager,
############

# Install uv, Needed to install langflow and other packages
echo " "                                       | tee -a /home/$USER/info.log
echo "Installing uv"                           | tee -a /home/$USER/info.log
echo "An extremely fast Python package and project manager"
echo "--------------"                          | tee -a /home/$USER/info.log
echo " "                                       | tee -a /home/$USER/info.log
sleep 2
curl -LsSf https://astral.sh/uv/install.sh     | sh   2>> /home/$USER/error.log
echo " "                                       | tee -a /home/$USER/error.log
echo " "                                       | tee -a /home/$USER/info.log
echo "uv installed"                            | tee -a /home/$USER/error.log
echo "8. uv installed"                         | tee -a /home/$USER/info.log
uv --version                                   | tee -a /home/$USER/info.log
sleep 2



###########
# chromadb install
############


echo "Shall I install chromadb directly OR you want to install chromadb docker latter? [Y,n]"    # Else docker chromadb may be installed
read input
input=${input:-n}
if [[ $input == "Y" || $input == "y" ]]; then
    # Installing chromadb. 
    # Install chromadb
    echo " "                                       | tee -a /home/$USER/error.log
    echo " Will Install chromadb"                  | tee -a /home/$USER/error.log
    echo "------------"                            | tee -a /home/$USER/error.log
    echo " "                                       | tee -a /home/$USER/error.log
    sleep 3
    pip install chromadb   2>> /home/$USER/error.log
    sleep 2
    
    echo " "                                       | tee -a /home/$USER/error.log
    echo "ChromaDB installed"                      | tee -a /home/$USER/error.log
    echo "3. ChromaDB installed"                   | tee -a /home/$USER/info.log
    echo "4. Database is at: /home/$USER/.local/bin/chroma"  | tee -a /home/$USER/info.log
    echo "      chromadb port is: 8000"            | tee -a /home/$USER/info.log
    echo "------ "                                | tee -a /home/$USER/error.log
    
    #  TO START CHROMA AS a SERVICE
    #*********************************
    cd ~/
    sudo touch     /var/log/chroma.log
    sudo chmod 777 /var/log/chroma.log
    
    echo '[Unit]'                       > chroma.service
    echo "Description = Chroma Service" >> chroma.service
    echo "After = network.target"       >> chroma.service
    echo " "                            >> chroma.service
    echo "[Service]"                    >> chroma.service
    echo "Type = simple"                >> chroma.service
    echo "User = root"                  >> chroma.service
    echo "Group = root"                 >> chroma.service
    echo "WorkingDirectory = /home/$USER/Documents"  >> chroma.service
    echo "ExecStart=/home/$USER/.local/bin/chroma run --host 127.0.0.1 --port 8000 --path /home/$USER/Documents/data --log-path /var/log/chroma.log"  >> chroma.service
    echo " "                             >> chroma.service
    echo "[Install]"                     >> chroma.service
    echo "WantedBy = multi-user.target"  >> chroma.service
    sudo mv chroma.service /etc/systemd/system/chroma.service
    #---------------------
    
    # This is outdated. Needs rechecking.
    # You can now start chroma, as:
    echo " "                                       | tee -a /home/$USER/error.log
    echo "5. ---Start/Stop Chroma as-------"       | tee -a /home/$USER/info.log
    echo "     sudo systemctl daemon-reload"       | tee -a /home/$USER/info.log
    echo "     sudo systemctl enable chroma"       | tee -a /home/$USER/info.log
    echo "     sudo systemctl start chroma"        | tee -a /home/$USER/info.log
    echo "6. Chroma is available at port 8000"     | tee -a /home/$USER/info.log
    echo "7. Check as: "                           | tee -a /home/$USER/info.log
    echo "      netstat -aunt | grep 8000"         | tee -a /home/$USER/info.log
    echo "----------"                              | tee -a /home/$USER/info.log
    echo " "                                       | tee -a /home/$USER/info.log
    
    sleep 2
    
    
    # Chroma start script
    echo '#!/bin/bash'                                         | tee    /home/$USER/start/start_chroma.sh  
    echo " "                                                   | tee -a /home/$USER/start/start_chroma.sh  
    echo "cd ~/"                                               | tee -a /home/$USER/start/start_chroma.sh  
    echo "echo 'Chromadb will be available at port 8000'"      | tee -a /home/$USER/start/start_chroma.sh 
    echo "echo 'Data dir is ~/Documents/data'"                 | tee -a /home/$USER/start/start_chroma.sh 
    echo "echo 'Logs are at /var/log/chroma.log'"              | tee -a /home/$USER/start/start_chroma.sh 
    echo "echo 'sudo kill -9 2197 2203'"                       | tee -a /home/$USER/start/start_chroma.sh  
    sudo echo"`lsof -i :8000`"                                 | tee -a /home/$USER/start/start_chroma.sh  
    #echo "netstat -aunt | grep 8000"                           | tee -a /home/$USER/start/start_chroma.sh  
    echo "sleep 5"                                             | tee -a /home/$USER/start/start_chroma.sh  
    echo "/home/$USER/.local/bin/chroma run --host 127.0.0.1 --port 8000 --path /home/$USER/Documents/data --log-path /var/log/chroma.log &"   | tee -a /home/$USER/start/start_chroma.sh  
    
    # Chroma stop script
    # This is outdated
    echo '#!/bin/bash'                                         | tee -a /home/$USER/stop/stop_chroma.sh  
    echo " "                                                   | tee -a /home/$USER/stop/stop_chroma.sh  
    echo "cd ~/"                                               | tee -a /home/$USER/stop/stop_chroma.sh  
    echo "echo 'chromadb will be stopped'"                     | tee -a /home/$USER/stop/stop_chroma.sh  
    echo "sudo systemctl stop chroma"                          | tee -a /home/$USER/stop/stop_chroma.sh  
    echo "netstat -aunt | grep 8000"                           | tee -a /home/$USER/stop/stop_chroma.sh  
    # Download python scripts to manage chroma db
    echo "Downloading python scripts to manage chromadb"
    cd /home/$USER
    rm  empty_chromadb.py
    rm get_chroma_collectionsName.py
    wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/empty_chromadb.py
    wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/get_chroma_collectionsName.py
    
    perl -pi -e 's/\r\n/\n/g' /home/$USER/empty_chromadb.py
    perl -pi -e 's/\r\n/\n/g' /home/$USER/get_chroma_collectionsName.py
    echo "Use them as:"
    echo "cd ~/"
    echo "python3 empty_chromadb.py"
    echo "python3 get_chroma_collectionsName.py"
    sleep 5
else
        echo "Skipping install of chromadb"
fi   
 
chmod +x /home/$USER/start/*.sh
    
# Move script file to done folder
mv /home/$USER/script1.sh /home/$USER/done
mv /home/$USER/next/script2.sh /home/$USER/
# Make a copy of this script also
cp /home/$USER/find_venv.sh /home/$USER/start/

###########
# apache2 webserver install
# Ref: https://ubuntu.com/tutorials/install-and-configure-apache#2-installing-apache
############

echo "Will install apache2 web-server"
echo "Start as: sudo systemctl start apache2"
sleep 4
sudo apt install apache2  -y

# Creating Virtual Host. Needs more work
sudo mkdir /var/www/ai/
cd /var/www/ai/
echo "<html>"                                    | sudo tee /var/www/ai/index.html
echo "<head>"                                    | sudo tee -a  /var/www/ai/index.html 
echo "<title> Ubuntu rocks! </title>"            | sudo tee -a  /var/www/ai/index.html 
echo "</head>"                                   | sudo tee -a  /var/www/ai/index.html 
echo "<body>"                                    | sudo tee -a  /var/www/ai/index.html 
echo "<p> I'm running this website on an Ubuntu Server server!"   | sudo tee -a  /var/www/ai/index.html 
echo "</body>"                                                    | sudo tee -a  /var/www/ai/index.html 
echo "</html>"                                                    | sudo tee -a  /var/www/ai/index.html 

cd /etc/apache2/sites-available/
sudo cp 000-default.conf ai.conf
# Replace DocumentRoot from /var/www/html to /var/www/ai/
sudo sed -i '/DocumentRoot/d' ./ai.conf
sudo sed -i '/ServerAdmin/a DocumentRoot /var/www/ai/' ai.conf
sudo sed -i '/ServerAdmin/a ServerName ai.fore.com' ai.conf
sudo a2ensite ai.conf
sudo systemctl reload apache2

# If not wsl, then
reboot

# Shut down wsl ubuntu
echo " "
echo "*******"
echo "Shut down Ubuntu terminal."
echo "Reopen it after it closes, and then execute the command:"
echo "     ./script2.sh"
echo "*******"
echo " "
exec sleep 9
kill $PPID

