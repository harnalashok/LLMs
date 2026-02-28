#!/bin/bash
# echo "https://www.postgresql.org/docs/current/ddl-schemas.html"
echo "  "
echo "   "
echo "====**====="
echo "Users 'ashok' and  'harnal' and databases 'ashok' and 'harnal' may already exist"
echo "User 'ashok' has full authority over database 'ashok'"
echo "User 'harnal' has full authority over database 'harnal'"
echo "User 'ashok' has password: ashok "
echo "User 'harnal' has password: harnal "
echo "Check with \du  and  \l"
echo "OR, check as:         "
echo "python -c \"import psycopg2; conn = psycopg2.connect('dbname=ashok user=ashok password=ashok host=localhost'); print('DB is OK'); conn.close()\" "  
echo "python -c \"import psycopg2; conn = psycopg2.connect('dbname=harnal user=harnal password=harnal host=localhost'); print('DB is OK'); conn.close()\" "  
echo "===**======"
echo " "
sleep 7
clear
echo "  "
echo "=====Create new users======="
echo "Follow 3-steps sequentially:"
echo '       In psql shell: '
echo '            First, execute AAA'
echo '            Then, BBB'
echo '            Lstly CCC'
echo "===================="
echo " "
sleep 4
echo 'AAA. Change myuser and mypass (password be within single inverted commas):'
echo " "
echo "Example:  CREATE ROLE myuser LOGIN PASSWORD 'mypass' ; "
echo " "
echo "BBB. Create database as:"
echo '          CREATE DATABASE mydatabase WITH OWNER = myuser;'
echo "  "
echo "CCC. Enable pgvector on your database directly from command line as:"
echo '          sudo -u postgres psql -c "CREATE EXTENSION vector;" -d mydatabase;'
echo '     Else, execute, in psql shell '
echo "          \c mydatabase"
echo "             CREATE EXTENSION vector;"
echo "  "
echo "++++++++++++++++++++"
echo "DDD. Within a database, you can create a schema, as:"
echo '          a. First, connect to database:  \c mydatabase  '
echo "          b. Then,  "
echo "                    CREATE schema myschema ; "
echo "(Every database has a default schema created by name of: public)"
echo "++++++++++++++++++++"
echo "EEE."
echo "Finally, if required, create a table, as:"
echo "     CREATE TABLE mydatabase.myschema.distributors ( "
echo "                                                   did  integer PRIMARY KEY,"
echo "                                                   name    varchar(40), "
echo "                                                   designation char(5)   "                          
echo "                                                   ); "
echo "+++++++++++++++++++++++++++"
echo " "
echo 'To quit psql shell enter \q'
echo " "
sleep 10
echo " "
pg_config --version
echo " "
sudo -u postgres psql postgres
