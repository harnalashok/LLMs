#!/bin/bash

echo "Will change 'postgresql.conf' and 'pg_hba.conf' and make postgresql highly permissive"
sleep 4
version=$(psql -V | awk '{print $3}' |  cut -d '.' -f 1 | tr -d '\n')'
cd /etc/postgresql/$version/main
echo "listen_addresses = '*'" |  sudo tee -a /etc/postgresql/$version/main/postgresql.conf
echo "host    all             all             0.0.0.0/0               scram-sha-256" |  sudo tee -a /etc/postgresql/$version/main/pg_hba.conf
sudo systemctl restart postgresql
        
