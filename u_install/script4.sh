#!/bin/bash

# Last amended: 27th Jan, 2024
# These sscripts run in sequence.
      #     script0.sh
      #     script1.sh
      #     script2.sh
      #     docker_install.sh
      #     script3.sh
      #     script4.sh
      #     script5.sh
      #     script6.sh


mkdir /home/ashok/localai
docker run -ti --name local-ai -p 8080:8080 localai/localai:latest-cpu
