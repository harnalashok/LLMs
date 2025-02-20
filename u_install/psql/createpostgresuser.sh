#!/bin/bash
 
echo " "
echo 'Ref: https://stackoverflow.com/a/2172588'
echo " "
echo "============"
echo 'Will open psql shell to create user, password and his database'
echo "============"
echo " "
echo 'Enter SQL command as in example below to create  a user LOGIN id'
echo ' and his password, mypass (password be within single inverted commas)'
echo "  "
echo "Example:  CREATE ROLE myuser LOGIN PASSWORD 'mypass' ; "
echo " "
echo "Create database as:"
echo '          CREATE DATABASE mydatabase WITH OWNER = myuser;'
echo " "
echo "Within a database, you can create a schema, as:"
echo '          CREATE schema myschema ; '
echo " "

echo 'To quit psql shell enter \q'
echo " "
sleep 10
echo " "
pg_config --version
echo " "
sudo -u postgres psql postgres
