#!/bin/bash
 
echo " "
echo " "
echo "============"
echo 'Will open psql shell to delete database'
echo "============"
echo " "
echo 'Enter SQL command as in example below to drop database'
echo "  "
echo "Example command to drop database:"
echo '          drop database gdatabase ;'
echo " "
echo "============= "
echo "You can then, create database as:"
echo '          CREATE DATABASE mydatabase WITH OWNER = myuser;'
echo "============= "
echo "Next, connect to your database, as: "
echo "(This is akin to 'use db' command in mysql)"
echo "           \c <databaseName>  "
echo "Once connected, issue the following SQL command to make it vector store:"  
echo "           CREATE EXTENSION vector; "
echo "============="
echo 'To quit psql shell enter \q'
echo " "
sleep 10
echo " "
pg_config --version
echo " "
sudo -u postgres psql postgres
