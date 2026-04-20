#!/bin/bash

# Last amended: 20th April, 2026

echo "================"
echo "Will create an ubuntu & postgresql user and database of the same name"
echo "And also make it vectorized database"
echo "================"
sleep 4
echo "   "
echo "   "
read -p "What user/database name would you like to have: " name
echo $name
sudo useradd -m -s /bin/bash $name
sudo -u postgres psql -c 'create user "'"$name"'" ;'
sudo -u postgres psql -c 'CREATE DATABASE "'"$name"'" WITH OWNER = "'"$name"'";  '
sudo -u postgres psql -c 'grant all privileges on database "'"$name"'" to "'"$name"'";'
sudo -u postgres psql -c "alter user $name with encrypted password '$name';"
sudo -u postgres psql -c "CREATE EXTENSION vector;" -d $name


