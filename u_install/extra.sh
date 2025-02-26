#!/bin/bash

# In some machines, incomplete installation has been made
# This script is to fill that gap.
# It is not to be executed along with script0...series

# REf: https://github.com/mudler/LocalAI

 
echo "========EXTRA=============="
echo "Install n8n with npx"
echo "Will create script to create postgresql user/database"  
echo "==========================="
sleep 10

cd ~/

#####################
## n8n install
####################


# 2.1 Install n8n as NORMAL user
echo " "
echo "Installing n8n...Takes time..."                       | tee -a /home/ashok/error.log
echo "------"                                               | tee -a /home/ashok/error.log
echo " "                                                    | tee -a /home/ashok/error.log
sleep 2


npm install -g n8n                                          2>> /home/ashok/error.log
echo " "
echo " "                                                    | tee -a /home/ashok/error.log
echo "n8n installed"                                        | tee -a /home/ashok/error.log
echo " "                                                    | tee -a /home/ashok/error.log
echo "n8n installed"                                        | tee -a /home/ashok/info.log
echo "n8n port is: 5678"                                    | tee -a /home/ashok/info.log
echo " "                                                    | tee -a /home/ashok/info.log


echo '#!/bin/bash'                                         | tee    /home/ashok/start/start_npx_n8n.sh  
echo " "                                                   | tee -a /home/ashok/start/start_npx_n8n.sh
echo "cd ~/"                                               | tee -a /home/ashok/start/start_npx_n8n.sh
echo "echo 'n8n will be available at port 5678'"           | tee -a /home/ashok/start/start_npx_n8n.sh
echo "n8n start"                                           | tee -a /home/ashok/start/start_npx_n8n.sh
echo "netstat -aunt | grep 5678"                           | tee -a /home/ashok/start/start_npx_n8n.sh

chmod +x /home/ashok/start/*.sh

echo "========script5=============="
echo "Will create download psql scripts"  
echo "Add vector storage capability to postgres"
echo "==========================="
sleep 10

# Download scripts that will in turn, help create user and password
# in postgresql

mkdir /home/ashok/psql
cd /home/ashok/
rm         createpostgresuser.sh
rm    show_postgres_databases.sh
rm             createvectordb.sh
rm         delete_postgres_db.sh
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/psql/createpostgresuser.sh
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/psql/show_postgres_databases.sh
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/psql/createvectordb.sh
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/psql/delete_postgres_db.sh
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/psql/postgres_notes.txt
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/psql/delete_postgres_db.sh


chmod +x /home/ashok/*.sh

# Create links
cd /home/ashok/psql
ln -sT /home/ashok/createpostgresuser.sh         createpostgresuser.sh
ln -sT /home/ashok/show_postgres_databases.sh    show_postgres_databases.sh
ln -sT /home/ashok/createvectordb.sh             createvectordb.sh
ln -sT /home/ashok/delete_postgres_db.sh         delete_postgres_db.sh
cd ~/

# Add vector storage capability
# My version of postgres db is 14.
# (Check as: pg_config --version)
# Install a needed package (depending upon your version of postgres)
# Check version as: pg_config --version
# Assuming version 14
sudo apt install postgresql-server-dev-14  -y

# Ref: https://github.com/pgvector/pgvector
cd /tmp
git clone --branch v0.8.0 https://github.com/pgvector/pgvector.git
cd pgvector
make
sudo make install 
cd ~/

##########################
### redis-stack-server docker install
##########################
# Ref: https://redis.io/docs/latest/operate/oss_and_stack/install/install-stack/docker/

mkdir /home/ashok/redis
docker run -d --name redis-stack-server -p 6379:6379 redis/redis-stack-server:latest

# redis start script
echo '#!/bin/bash'                                                                                             > /home/ashok/start/start_redis.sh
echo " "                                                                                                       >> /home/ashok/start/start_redis.sh
echo "echo 'Access redis server port 6379. Wait...starting...'"                                                >> /home/ashok/start/start_redis.sh
echo "echo 'To stop it, issue command: cd /home/ashok/redis/ ; docker stop redis-stack-server'"                 >> /home/ashok/start/start_redis.sh
echo "echo 'To connect to redis cli, after start, issue command: docker exec -it  redis-stack-server redis-cli'"   >> /home/ashok/start/start_redis.sh
echo "sleep 9"                                                                                                  >> /home/ashok/start/start_redis.sh
echo "cd /home/ashok/redis"                                                                                      >> /home/ashok/start/start_redis.sh
echo " docker start redis-stack-server"                                                                          >> /home/ashok/start/start_redis.sh
echo "netstat -aunt | grep 6379"                                                                                 >> /home/ashok/start/start_redis.sh


# redis stop script
echo '#!/bin/bash'                                                                                              > /home/ashok/stop/stop_redis.sh
echo "echo 'Stopping redis server'"                                                                             >> /home/ashok/stop/stop_redis.sh
echo "cd /home/ashok/redis"                                                                                      >> /home/ashok/stop/stop_redis.sh
echo " docker stop redis-stack-server"                                                                           >> /home/ashok/stop/stop_redis.sh
echo "netstat -aunt | grep 6379"                                                                                 >> /home/ashok/stop/stop_redis.sh
chmod +x /home/ashok/start/*.sh
chmod +x /home/ashok/stop/*.sh


# Start flowise in debug mode
echo '#!/bin/bash'                                                      | tee    /home/ashok/start/start_debug_flowise.sh  
echo " "                                                                | tee -a /home/ashok/start/start_debug_flowise.sh  
echo "cd ~/"                                                            | tee -a /home/ashok/start/start_debug_flowise.sh  
echo "echo 'Flowise will be available at port 3000 in debug mode'"      | tee -a /home/ashok/start/start_debug_flowise.sh  
echo "npx flowise start --DEBUG=true"                                   | tee -a /home/ashok/start/start_debug_flowise.sh  
echo "netstat -aunt | grep 3000"                                        | tee -a /home/ashok/start/start_debug_flowise.sh  

chmod +x /home/ashok/start/*.sh


# Download sh files to download models
wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/localai/download_localaiModel1.sh    -P /home/ashok/localai
wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/localai/download_localaiModel2.sh    -P /home/ashok/localai
wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/localai/download_localaiModel3.sh    -P /home/ashok/localai
wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/localai/download_localaiModel4.sh    -P /home/ashok/localai
wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/localai/download_stablediffusion.sh   -P /home/ashok/localai
wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/localai/get_download_status.sh        -P /home/ashok/localai
wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/localai/find_file.sh                  -P /home/ashok/localai
wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/localai/find_file.sh                  -P /home/ashok/
chmod +x /home/ashok/localai/*.sh


rm /home/ashok/start_n8n.sh
ln -sT /home/ashok/start/start_npx_n8n.sh start_n8n.sh
ln -sT /home/ashok/start/start_npx_flowise.sh start_flowise.sh


# Amend /etc/hosts
sudo sed -i '/127.0.1.1	master/c\127.0.1.1	ashok.fsm.ac.in ashok' /etc/hosts
 hostnamectl set-hostname ashok
# Restart network services
sudo systemctl restart systemd-networkd




