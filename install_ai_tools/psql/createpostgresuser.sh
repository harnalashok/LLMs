#!/bin/bash
# echo "https://www.postgresql.org/docs/current/ddl-schemas.html"
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
echo 'Open psql shell for operations'
echo '  And enter commands AAA, BBB'
echo '    Then, on command line, execute CCC'
echo "============"
echo " "
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
