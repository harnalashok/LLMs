


# Test n8n

#######3
abc=
abc=`sudo ss -tulpn | grep ':5678'`

if [[ -n $abc ]]; then
  echo "n8n is started."
else
   echo "n8n NOT installed"
fi

#######3
# Test ollama
abc=
abc=`sudo ss -tulpn | grep ':11434'`

if [[ -n $abc ]]; then
  echo "ollama is started."
else
   echo "ollama NOT installed"
fi

#######3
# Test postgres

abc=
abc=`sudo ss -tulpn | grep ':5432'`

if [[ -n $abc ]]; then
  echo "n8n is started."
else
   echo "n8n NOT installed"
fi

#######3
abc=
abc=`sudo ss -tulpn | grep ':19530'`

if [[ -n $abc ]]; then
  echo "milvus is started."
else
   echo "milvus NOT installed"
fi

#######3
abc=
abc=`sudo ss -tulpn | grep ':19530'`

if [[ -n $abc ]]; then
  echo "milvus is started."
else
   echo "milvus NOT installed"
fi

#######3
abc=
abc=`sudo ss -tulpn | grep ':7700'`

if [[ -n $abc ]]; then
  echo "meilisearch is started."
else
   echo "meilisearch NOT installed"
fi

###########

abc=
abc=`sudo ss -tulpn | grep ':3000'`

if [[ -n $abc ]]; then
  echo "flowise is started."
else
   echo "flowise NOT installed"
fi

###########

abc=
abc=`sudo ss -tulpn | grep ':3000'`

if [[ -n $abc ]]; then
  echo "flowise is started."
else
   echo "flowise NOT installed"
fi

##########

abc=
abc=`sudo ss -tulpn | grep ':3000'`

if [[ -n $abc ]]; then
  echo "flowise is started."
else
   echo "flowise NOT installed"
fi

##########

abc=
abc=`nvidia-smi | grep 'Memory-Usage'`
if [[ -n $abc ]]; then
  echo "cuda is started."
else
   echo "cuda NOT installed"
fi

###############3







     
