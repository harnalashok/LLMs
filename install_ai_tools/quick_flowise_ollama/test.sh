#!/bin/bash

# Last amended: 13th March, 2026

# Start software
bash start_ollama.sh
bash start_postgresql.sh
bash start_n8n.sh
bash start_flowise.sh
bash start_milvus.sh
bash start_meilisearch.sh 

# Test n8n

#######3
abc=
abc=`sudo ss -tulpn | grep ':5678'`

if [[ -n $abc ]]; then
  echo "1. n8n is started."
else
   echo "1. n8n NOT installed"
fi

#######3
# Test ollama
abc=
abc=`sudo ss -tulpn | grep ':11434'`

if [[ -n $abc ]]; then
  echo "2. ollama is started."
else
   echo "2. ollama NOT installed"
fi

#######3
# Test postgres

abc=
abc=`sudo ss -tulpn | grep ':5432'`

if [[ -n $abc ]]; then
  echo "3. postgres is started."
else
   echo "3. postgres NOT installed"
fi

#######3
abc=
abc=`sudo ss -tulpn | grep ':19530'`

if [[ -n $abc ]]; then
  echo "4. milvus is started."
else
   echo "4. milvus NOT installed"
fi

#######3

abc=
abc=`sudo ss -tulpn | grep ':7700'`

if [[ -n $abc ]]; then
  echo "5. meilisearch is started."
else
   echo "5. meilisearch NOT installed"
fi

###########

abc=
abc=`sudo ss -tulpn | grep ':3000'`

if [[ -n $abc ]]; then
  echo "6. flowise is started."
else
   echo "6. flowise NOT installed"
fi

###########


abc=
abc=`nvidia-smi | grep 'Memory-Usage'`
if [[ -n $abc ]]; then
  echo "7. cuda is started."
else
   echo "7. cuda NOT installed"
fi

###############3







     
