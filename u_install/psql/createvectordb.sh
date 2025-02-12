#!/bin/bash

echo " "
echo 'Ref: https://github.com/pgvector/pgvector'
echo " "
echo "============"
echo 'Add vector storage capability to an existing pg database'
echo 'Will open psql shell to execute two commands.'
echo "============"
echo " "
echo 'To create a user and a database first execute script:'
echo '         cd ~/ ;  ./createpostgresuser.sh '
echo "Next, connect to your database, as: "
echo "(This is akin to 'use db' command in mysql)"
echo "           \c <databaseName>  "
echo "Once connected, issue the following SQL command:"  
echo "           CREATE EXTENSION vector; "
echo " "
echo "Done....Create database as:"
echo " "
echo 'To quit psql shell enter \q'
echo " "
sleep 10
sudo -u postgres psql postgres
