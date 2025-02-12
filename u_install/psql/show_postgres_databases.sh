#!/bin/bash

echo " " 
echo " "
echo "============="
echo 'Will open psql shell for you to enter commands.'
echo "============="
echo 'To see databases and owner, issue command:'
echo '         \l '
echo ' or write,'
echo '        SELECT datname FROM pg_database; '
echo 'To see all roles, issue command:'
echo '        SELECT * FROM pg_roles; '
echo 'To quit psql shell enter:  \q'
echo " "
echo " "
sleep 10
echo " "
pg_config --version
echo " "
sudo -u postgres psql postgres
