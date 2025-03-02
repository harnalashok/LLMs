#!/bin/bash


echo "========script5=============="
echo "Download psql scripts"  
echo "Adds vector storage capability to postgres"
echo "You may call download_models.sh to download gguf models or from ollama library"
echo "==========================="
sleep 10

# Download scripts that will inturn, help create user and password
# in postgresql

cd /home/ashok/
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/psql/createpostgresuser.sh
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/psql/show_postgres_databases.sh
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/psql/createvectordb.sh
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/psql/delete_postgres_db.sh
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/psql/psql.sh
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/psql/postgres_notes.txt
chmod +x /home/ashok/*.sh



# Create links
cd /home/ashok/psql
ln -sT /home/ashok/createpostgresuser.sh         createpostgresuser.sh
ln -sT /home/ashok/show_postgres_databases.sh    show_postgres_databases.sh
ln -sT /home/ashok/createvectordb.sh             createvectordb.sh
ln -sT /home/ashok/delete_postgres_db.sh         delete_postgres_db.sh
ln -sT /home/ashok/psql.sh                       psql.sh
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



mv /home/ashok/script5.sh        /home/ashok/done/
mv /home/ashok/next/script6.sh   /home/ashok/



echo "You may like to execute:"
echo "       ./script6.sh"
sleep 10
kill $PPID
