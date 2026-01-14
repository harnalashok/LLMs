#!/bin/bash
 
echo " "
echo 'Ref: https://stackoverflow.com/a/2172588'
echo "https://www.postgresql.org/docs/current/ddl-schemas.html"
echo " "
echo "  "
echo "========="
echo "User 'ashok' and database 'askok' already exist"
echo "User 'ashok' has full authority over database 'ashok'"
echo "User 'ashok' has password: ashok"
echo "========="
echo "  "
echo " "
sleep 5
echo "============"
echo 'Will open psql shell for operations'
echo "============"
echo " "
echo 'Enter SQL command as in example below to create  a user LOGIN id'
echo ' and his password, mypass (password be within single inverted commas)'
echo " "
echo "AAA."
echo "Example:  CREATE ROLE myuser LOGIN PASSWORD 'mypass' ; "
echo " "
echo "BBB."
echo "Create database as:"
echo '          CREATE DATABASE mydatabase WITH OWNER = myuser;'
echo "  "
echo "CCC."
echo "Enable pgvector on your database directly from command line as:"
echo '          sudo -u postgres psql -c "CREATE EXTENSION vector;" -d mydatabase;'
echo " "
echo "  "
echo "++++++++++++++++++++"
echo "DDD."
echo "Within a database, you can create a schema, as:"
echo '          a. First, connect to database:  \c mydatabase  '
echo "          b. Then,  "
echo "                    CREATE schema myschema ; "
echo "(Every database has a default schema created by name of: public)"
echo " "
echo "DDD."
echo "Finally create table, as:"
echo "     CREATE TABLE mydatabase.myschema.distributors ( "
echo "                                                   did  integer PRIMARY KEY,"
echo "                                                   name    varchar(40), "
echo "                                                   designation char(5)   "                          
echo "                                                   ); "
echo " "
echo "+++++++++++++++++++++++++++"
echo " "
echo 'To quit psql shell enter \q'
echo " "
sleep 10
echo " "
pg_config --version
echo " "
sudo -u postgres psql postgres
