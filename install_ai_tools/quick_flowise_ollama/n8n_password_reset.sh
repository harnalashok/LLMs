# Last amended: 29th Dec, 2025
# How to reset n8n password

# 0.0 Start n8n
./start_n8n.sh

# 1. Execute the following:
docker exec -u root -it n8n  /bin/sh

# 1.1 The above opens up a shell, where
#     execute the command:
/home/node # n8n user-management:reset

# 2.0 Open another terminal and stop n8n docker 
docker n8n stop

# 3.0 n8n container disappears. 
#     Recreate the container, as:

docker run -it -d --rm 	--name n8n \
                         -p 5678:5678 \
                         -e NODE_OPTIONS="--max-old-space-size=4096" \
                         --network host \
                         -v n8n_data:/home/node/.n8n \
                            docker.n8n.io/n8nio/n8n

#########
