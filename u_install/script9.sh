#!/bin/bash

 # These scripts run in sequence.
      #     script0.sh
      #     script1.sh
      #     script2.sh
      #     docker_install.sh
      #     script3.sh
      #     script4.sh
      #     script5.sh
      #     script6.sh
      #     script7.sh
      #     script8.sh
      #     script9.sh



echo "========script9=============="
echo "Will create script to create postgresql user/database"  
echo "Needed for RecordManager"
echo "Add vector storage capability to postgres"
echo "You may call download_models.sh to download gguf models or from ollama library"
echo "==========================="
sleep 10

# Download scripts that will inturn, help create user and password
# in postgresql

cd /home/ashok/
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/psql/createpostgresuser.sh
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/psql/show_postgres_databases.sh
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/psql/createvectordb.sh

chmod +x /home/ashok/*.sh


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



mv /home/ashok/script9.sh  /home/ashok/done/



echo "You may like to execute:"
echo "       ./download_models.sh"
sleep 10
kill $PPID
