#!/bin/bash


echo "========script5=============="
echo "Download psql scripts"  
echo "Adds vector storage capability to postgres"
echo "You may call download_models.sh to download gguf models or from ollama library"
echo "==========================="
sleep 10




#############
# Postgres related
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
# Assuming version 14
psql -V | awk '{print $3}' |  cut -d '.' -f 1 | tr -d '\n'
version=$(psql -V | awk '{print $3}' |  cut -d '.' -f 1 | tr -d '\n')
echo $version
sudo apt install postgresql-server-dev-$version  -y

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
########


mv /home/$USER/script5.sh        /home/$USER/done/
mv /home/$USER/next/script6.sh   /home/$USER/



echo "You may like to execute:"
echo "       ./script6.sh"
sleep 10
kill $PPID
