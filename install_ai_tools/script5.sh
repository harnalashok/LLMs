#!/bin/bash


echo "========script5=============="
echo "Download psql scripts"  
echo "Adds vector storage capability to postgres"
echo "You may call download_models.sh to download gguf models or from ollama library"
echo "==========================="
sleep 10

# Download scripts that will inturn, help create user and password
# in postgresql

cd /home/$USER/
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/psql/createpostgresuser.sh
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/psql/show_postgres_databases.sh
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/psql/createvectordb.sh
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/psql/delete_postgres_db.sh
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/psql/psql.sh
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/psql/postgres_notes.txt
chmod +x /home/$USER/*.sh



# Create links
cd /home/$USER/psql
ln -sT /home/$USER/createpostgresuser.sh         createpostgresuser.sh
ln -sT /home/$USER/show_postgres_databases.sh    show_postgres_databases.sh
ln -sT /home/$USER/createvectordb.sh             createvectordb.sh
ln -sT /home/$USER/delete_postgres_db.sh         delete_postgres_db.sh
ln -sT /home/$USER/psql.sh                       psql.sh
cd ~/

###########
## Add vector storage capability
############

# Add vector storage capability to postgres
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



mv /home/$USER/script5.sh        /home/$USER/done/
mv /home/$USER/next/script6.sh   /home/$USER/



echo "You may like to execute:"
echo "       ./script6.sh"
sleep 10
kill $PPID
