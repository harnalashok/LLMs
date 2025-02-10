#!/bin/bash

# Last amended: 06th Feb, 2025
# Copyright:: 

 # These scripts run in sequence.
      #     script0.sh
      #     script1.sh
      #     script2.sh
      #     ubuntu_docker.sh
      #     script3.sh
      #     script4.sh
      #     script5.sh
      #     script6.sh
      #     script7.sh
      #     script8.sh


echo "========script1=============="
echo "Will update Ubuntu"
echo "Will install necessary packages"
echo "Will install postgresql & sqlite3"
echo "Will install Ollama quietly"
echo "Will install Fast Node Manager (fnm)"
echo "Will install uv for langflow install"
echo "Will install chromadb"
echo "Reboot machine and call script2.sh"
echo "==========================="
sleep 10


cd ~/

echo " "                                       | tee -a /home/ashok/error.log
echo "*********"                               | tee -a /home/ashok/error.log
echo "Script: script1.sh"                      | tee -a /home/ashok/error.log
echo "**********"                              | tee -a /home/ashok/error.log
echo " "                                       | tee -a /home/ashok/error.log

################
# Update Ubuntu
# Also install postgresql
################

echo "  "
echo "------------"                            | tee -a /home/ashok/error.log
echo " Will update Ubuntu"                     | tee -a /home/ashok/error.log
echo " You will be asked for password...supply it..."
echo "----------"                              | tee -a /home/ashok/error.log
echo " "
sleep 2
sudo apt update
sudo apt upgrade -y
sudo apt install zip unzip net-tools cmake  build-essential python3-pip tilde curl git  python3-dev python3-venv gcc g++ make jq  openssh-server libfuse2 -y  
sudo apt -y install python3-pip python3-dev python3-venv gcc g++ make jq 
echo " "
echo "Ubuntu upgraded ......"                | tee -a /home/ashok/error.log
echo "1. Ubuntu upgraded ......"             | tee -a /home/ashok/info.log

# Folders for start/stop scripts
mkdir /home/ashok/start
mkdir /home/ashok/stop


################
# Install Ollama
################

# Installing ollama
echo " "
echo " "
echo "------"
echo "Installing ollama quietly. Takes time...."  | tee -a /home/ashok/error.log
echo "When asked, supply password"
echo "No messages will appear on screen"
echo "------"
echo " "
echo " "
curl -fsSL https://ollama.com/install.sh | sh       2>> /home/ashok/error.log  
echo "---------"                                    | tee -a /home/ashok/error.log
echo "Ollama installed"                             | tee -a /home/ashok/error.log
echo "9. Ollama installed"                          | tee -a /home/ashok/info.log
echo "   ollama listens at port: 11434"             | tee -a /home/ashok/info.log
echo "-----------"                                  | tee -a /home/ashok/error.log
echo " "                                            | tee -a /home/ashok/error.log
echo "You may start ollama in the background, as:"  | tee -a /home/ashok/info.log
echo "    ollama serve &  > /dev/null & "           | tee -a /home/ashok/info.log
echo "Or, as:"                                      | tee -a /home/ashok/info.log
echo "sudo systemctl start|stop|restart ollama"     | tee -a /home/ashok/info.log  


# Ollama start script:
echo '#!/bin/bash'                                         | tee -a /home/ashok/start/start_ollama.sh  
echo " "                                                   | tee -a /home/ashok/start/start_ollama.sh  
echo "cd ~/"                                               | tee -a /home/ashok/start/start_ollama.sh  
echo "echo 'Ollama will be available at port 11434'"       | tee -a /home/ashok/start/start_ollama.sh  
echo "sudo systemctl start ollama"                         | tee -a /home/ashok/start/start_ollama.sh  
echo "netstat -aunt | grep 11434"                          | tee -a /home/ashok/start/start_ollama.sh  

# Ollama stop script
echo '#!/bin/bash'                                         | tee -a /home/ashok/stop/stop_ollama.sh  
echo " "                                                   | tee -a /home/ashok/stop/stop_ollama.sh  
echo "cd ~/"                                               | tee -a /home/ashok/stop/stop_ollama.sh  
echo "echo 'Ollama will be stopped'"                       | tee -a /home/ashok/stop/stop_ollama.sh  
echo "sudo systemctl stop ollama"                          | tee -a /home/ashok/stop/stop_ollama.sh  
echo "netstat -aunt | grep 11434"                          | tee -a /home/ashok/stop/stop_ollama.sh  

# PRemission changes
chmod +x /home/ashok/start/*.sh
chmod +x /home/ashok/stop/*.sh


# Copy earlier created scripts
cp /home/ashok/find_venv.sh  /home/ashok/start/
cp /home/ashok/find_venv.sh  /home/ashok/stop/
sleep 2

################
# Install postgresql and sqlite3
################

sudo apt install postgresql postgresql-contrib sqlite3   -y

# Postgresql start/stop script
echo '#!/bin/bash'                                                      > /home/ashok/start/start_postgresql.sh  
echo " "                                                               >> /home/ashok/start/start_postgresql.sh  
echo "cd ~/"                                                           >> /home/ashok/start/start_postgresql.sh  
echo "echo 'postgresql will be available on port 5432'"                >> /home/ashok/start/start_postgresql.sh  
echo "sudo systemctl start postgresql.service"                         >> /home/ashok/start/start_postgresql.sh  
echo "sleep 2"                                                         >> /home/ashok/start/start_postgresql.sh  
echo "netstat -aunt | grep 5432"                                       >> /home/ashok/start/start_postgresql.sh  

echo '#!/bin/bash'                                                      > /home/ashok/stop/stop_postgresql.sh  
echo " "                                                               >> /home/ashok/stop/stop_postgresql.sh  
echo "cd ~/"                                                           >> /home/ashok/stop/stop_postgresql.sh  
echo "sudo systemctl stop postgresql.service"                          >> /home/ashok/stop/stop_postgresql.sh  
echo "sleep 2"                                                         >> /home/ashok/stop/stop_postgresql.sh  
echo "netstat -aunt | grep 5432"                                       >> /home/ashok/stop/stop_postgresql.sh  


# A small help script
echo '#!/bin/bash'                                                     > /home/ashok/create_sqlite_db.sh 
echo " "                                                               >> /home/ashok/create_sqlite_db.sh 
echo "# Create sqlite3 database"                                       >> /home/ashok/create_sqlite_db.sh 
echo " "                                                               >> /home/ashok/create_sqlite_db.sh  
echo " "                                                               >> /home/ashok/create_sqlite_db.sh 
echo "echo 'How to create sqlite3 database?'"                          >> /home/ashok/create_sqlite_db.sh 
echo "echo 'To create database: mydatabase.db'"                        >> /home/ashok/create_sqlite_db.sh 
echo "echo 'issue command:'"                                           >> /home/ashok/create_sqlite_db.sh 
echo "echo '         sqlite3 mydatabase.db'"                           >> /home/ashok/create_sqlite_db.sh 
echo " "                                                               >> /home/ashok/create_sqlite_db.sh 
chmod +x *.sh


###########
# Fast Node Manager install
############

# Install 'fnm' (Fast Node Manager)
echo " "                                       | tee -a /home/ashok/error.log
echo "Will install fnm: Fast Node Manager..."  | tee -a /home/ashok/error.log
echo "------------------"                      | tee -a /home/ashok/error.log
sleep 9
sudo curl -fsSL https://fnm.vercel.app/install | bash   2>> /home/ashok/error.log
echo "Fast Node Manager (fnm) installed"       | tee -a /home/ashok/error.log
echo "2. Fast Node Manager (fnm) installed"    | tee -a /home/ashok/info.log



###########
# uv install
############

# Install uv for langflow install
echo " "                                       | tee -a /home/ashok/info.log
echo "Installing uv"                           | tee -a /home/ashok/info.log
echo "--------------"                          | tee -a /home/ashok/info.log
echo " "                                       | tee -a /home/ashok/info.log
sleep 2
curl -LsSf https://astral.sh/uv/install.sh     | sh   2>> /home/ashok/error.log
echo " "                                       | tee -a /home/ashok/error.log
echo " "                                       | tee -a /home/ashok/info.log
echo "uv installed"                            | tee -a /home/ashok/error.log
echo "8. uv installed"                         | tee -a /home/ashok/info.log
uv --version                                   | tee -a /home/ashok/info.log
sleep 2



###########
# chromadb install
############

# Install chromadb
echo " "                                       | tee -a /home/ashok/error.log
echo " Will Install chromadb"                  | tee -a /home/ashok/error.log
echo "------------"                            | tee -a /home/ashok/error.log
echo " "                                       | tee -a /home/ashok/error.log
sleep 3
pip install chromadb   2>> /home/ashok/error.log
sleep 2

echo " "                                       | tee -a /home/ashok/error.log
echo "ChromaDB installed"                      | tee -a /home/ashok/error.log
echo "3. ChromaDB installed"                   | tee -a /home/ashok/info.log
echo "4. Database is at: /home/ashok/.local/bin/chroma"  | tee -a /home/ashok/info.log
echo "      chromadb port is: 8000"            | tee -a /home/ashok/info.log
echo "------ "                                | tee -a /home/ashok/error.log

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
echo "WorkingDirectory = /home/ashok/Documents"  >> chroma.service
echo "ExecStart=/home/ashok/.local/bin/chroma run --host 127.0.0.1 --port 8000 --path /home/ashok/Documents/data --log-path /var/log/chroma.log"  >> chroma.service
echo " "                             >> chroma.service
echo "[Install]"                     >> chroma.service
echo "WantedBy = multi-user.target"  >> chroma.service
sudo mv chroma.service /etc/systemd/system/chroma.service
#---------------------

# This is outdated. Needs rechecking.
# You can now start chroma, as:
echo " "                                       | tee -a /home/ashok/error.log
echo "5. ---Start/Stop Chroma as-------"       | tee -a /home/ashok/info.log
echo "     sudo systemctl daemon-reload"       | tee -a /home/ashok/info.log
echo "     sudo systemctl enable chroma"       | tee -a /home/ashok/info.log
echo "     sudo systemctl start chroma"        | tee -a /home/ashok/info.log
echo "6. Chroma is available at port 8000"     | tee -a /home/ashok/info.log
echo "7. Check as: "                           | tee -a /home/ashok/info.log
echo "      netstat -aunt | grep 8000"         | tee -a /home/ashok/info.log
echo "----------"                              | tee -a /home/ashok/info.log
echo " "                                       | tee -a /home/ashok/info.log

sleep 2


# Chroma start script
echo '#!/bin/bash'                                         | tee    /home/ashok/start/start_chroma.sh  
echo " "                                                   | tee -a /home/ashok/start/start_chroma.sh  
echo "cd ~/"                                               | tee -a /home/ashok/start/start_chroma.sh  
echo "echo 'Chromadb will be available at port 8000'"      | tee -a /home/ashok/start/start_chroma.sh 
echo "echo 'Data dir is ~/Documents/data'"                 | tee -a /home/ashok/start/start_chroma.sh 
echo "echo 'Logs are at /var/log/chroma.log'"              | tee -a /home/ashok/start/start_chroma.sh 
echo "echo 'sudo kill -9 2197 2203'"                       | tee -a /home/ashok/start/start_chroma.sh  
sudo echo"`lsof -i :8000`"                                 | tee -a /home/ashok/start/start_chroma.sh  
#echo "netstat -aunt | grep 8000"                           | tee -a /home/ashok/start/start_chroma.sh  
echo "sleep 5"                                             | tee -a /home/ashok/start/start_chroma.sh  
echo "/home/ashok/.local/bin/chroma run --host 127.0.0.1 --port 8000 --path /home/ashok/Documents/data --log-path /var/log/chroma.log &"   | tee -a /home/ashok/start/start_chroma.sh  

# Chroma stop script
# This is outdated
echo '#!/bin/bash'                                         | tee -a /home/ashok/stop/stop_chroma.sh  
echo " "                                                   | tee -a /home/ashok/stop/stop_chroma.sh  
echo "cd ~/"                                               | tee -a /home/ashok/stop/stop_chroma.sh  
echo "echo 'chromadb will be stopped'"                     | tee -a /home/ashok/stop/stop_chroma.sh  
echo "sudo systemctl stop chroma"                          | tee -a /home/ashok/stop/stop_chroma.sh  
echo "netstat -aunt | grep 8000"                           | tee -a /home/ashok/stop/stop_chroma.sh  

chmod +x /home/ashok/start/*.sh



# Download python scripts to manage chroma db
echo "Downloading python scripts to manage chromadb"
cd ~/
rm  empty_chromadb.py
rm get_chroma_collectionsName.py
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/empty_chromadb.py
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/get_chroma_collectionsName.py

perl -pi -e 's/\r\n/\n/g' /home/ashok/empty_chromadb.py
perl -pi -e 's/\r\n/\n/g' /home/ashok/get_chroma_collectionsName.py
echo "Use them as:"
echo "cd ~/"
echo "python3 empty_chromadb.py"
echo "python3 get_chroma_collectionsName.py"
sleep 5



# Move script file to done folder
mv /home/ashok/script1.sh /home/ashok/done
mv /home/ashok/next/script2.sh /home/ashok/
# Make a copy of this script also
cp /home/ashok/find_venv.sh /home/ashok/start/

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

