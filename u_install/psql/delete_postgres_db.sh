#!/bin/bash
 
echo " "
echo " "
echo "============"
echo 'Will open psql shell to delete database'
echo "============"
echo " "
echo 'Enter SQL command as in example below to drop database'
echo "  "
echo "Drop database as:"
echo '          drop database gdatabase ;'
echo " "
echo 'To quit psql shell enter \q'
echo " "
sleep 10
echo " "
pg_config --version
echo " "
sudo -u postgres psql postgres
