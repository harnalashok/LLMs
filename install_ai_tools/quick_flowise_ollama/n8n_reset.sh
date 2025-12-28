docker exec -u root -it n8n  /bin/sh
/home/node # n8n user-management:reset

docker n8n stop

 docker run -it -d --rm 	--name n8n 	                -p 5678:5678 	                 -e NODE_OPTIONS="--max-old-space-size=4096" 	                --network host   	                 -v n8n_data:/home/node/.n8n 	                    docker.n8n.io/n8nio/n8n

