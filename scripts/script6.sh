#!/bin/sh

# LAst amended: 17th Jan, 2025
# Ref: https://www.server-world.info/en/note?os=Ubuntu_22.04&p=llama&f=1
# ============

# Connected scripts are:
# These sscripts run in sequence.
#     script0.sh
#     script1.sh
#     script2.sh
#     script3.sh
#     docker_install.sh
#     script4.sh
#     script5.sh
#     script6.sh
#     script7.sh


echo " " | tee -a ~/error.log
echo "*********"  | tee -a ~/error.log
echo "Script: script6.sh"  | tee -a ~/error.log
echo "**********" | tee -a ~/error.log
echo " " | tee -a ~/error.log


# Install required packages:
echo "Installing dependencies " | tee -a ~/error.log
echo "*********"  | tee -a ~/error.log
sudo apt -y install python3-pip python3-dev python3-venv gcc g++ make jq 
echo "Dependencies installed"  | tee -a ~/error.log
echo " " | tee -a ~/error.log
sleep 9

# Login as a common user and prepare Python virtual environment 
#   to install [llama-cpp-agent].
echo " "  | tee -a ~/error.log
echo "Installing llama-cpp-agent " | tee -a ~/error.log
echo "*********"  | tee -a ~/error.log

# Creating virtual environment
#python3 -m venv --system-site-packages ~/llama 
sudo pip install llama-cpp-agent
 # Activating virtual envitronment
 #source ~/llama/bin/activate 
 # Install [llama-cpp-python]. 
 #pip3 install llama-cpp-python[server] 
 echo " "  | tee -a ~/error.log
 echo "Installation of  llama-cpp-agent done" | tee -a ~/error.log
 echo "*********"  | tee -a ~/error.log
 sleep 9
# Downloading the llama-2-13b-chat.Q4_K_M.gguf format model.
# It's possible to download models from the following sitew.
# In this example, we will use [llama-2-13b-chat.Q4_K_M.gguf]. 
#  ⇒ https://huggingface.co/TheBloke/Llama-2-7B-chat-GGUF/tree/main
#  ⇒ https://huggingface.co/TheBloke/Llama-2-13B-chat-GGUF/tree/main
#  ⇒ https://huggingface.co/TheBloke/Llama-2-70B-Chat-GGUF/tree/main 

 echo " "  | tee -a ~/error.log
 echo "Downloading Llama-2-13B-chat-GGUF" | tee -a ~/error.log
 echo "Downloading size: 7.8GB" | tee -a ~/error.log
 
 echo "to folder ~/llama.cpp/models/"  | tee -a ~/error.log
 echo  "*********"  | tee -a ~/error.log
 cd  ~/llama.cpp/models/
 wget https://huggingface.co/TheBloke/Llama-2-13B-chat-GGUF/resolve/main/llama-2-13b-chat.Q4_K_M.gguf 
 sleep 4
 echo " "  | tee -a ~/error.log
 echo "Downloaded Llama-2-13B-chat-GGUF" | tee -a ~/error.log
 #echo "Will test llama-cpp-agent now"  | tee -a ~/error.log
 echo  "*********"  | tee -a ~/error.log
 
 #echo " "  | tee -a ~/error.log
 #echo "Testing llama-cpp-agent with Llama-2-13B-chat-GGUF" | tee -a ~/error.log
 #echo "Access it at localhost:8000/docs"  | tee -a ~/error.log
 #echo  "*********"  | tee -a ~/error.log
 #python3 -m llama_cpp.server --model ~/llama.cpp/models//llama-2-13b-chat.Q4_K_M.gguf --host 0.0.0.0 --port 8000 --chat functionary & 
 #echo " "  | tee -a ~/error.log
 # sleep 9
 
 
<< ////

: __main__.py [-h] [--model MODEL] [--model_alias MODEL_ALIAS] [--n_gpu_layers N_GPU_LAYERS] [--split_mode SPLIT_MODE] [--main_gpu MAIN_GPU]
                   [--tensor_split [TENSOR_SPLIT ...]] [--vocab_only VOCAB_ONLY] [--use_mmap USE_MMAP] [--use_mlock USE_MLOCK] [--kv_overrides [KV_OVERRIDES ...]]
                   [--rpc_servers RPC_SERVERS] [--seed SEED] [--n_ctx N_CTX] [--n_batch N_BATCH] [--n_ubatch N_UBATCH] [--n_threads N_THREADS]
                   [--n_threads_batch N_THREADS_BATCH] [--rope_scaling_type ROPE_SCALING_TYPE] [--rope_freq_base ROPE_FREQ_BASE] [--rope_freq_scale ROPE_FREQ_SCALE]
                   [--yarn_ext_factor YARN_EXT_FACTOR] [--yarn_attn_factor YARN_ATTN_FACTOR] [--yarn_beta_fast YARN_BETA_FAST] [--yarn_beta_slow YARN_BETA_SLOW]
                   [--yarn_orig_ctx YARN_ORIG_CTX] [--mul_mat_q MUL_MAT_Q] [--logits_all LOGITS_ALL] [--embedding EMBEDDING] [--offload_kqv OFFLOAD_KQV]
                   [--flash_attn FLASH_ATTN] [--last_n_tokens_size LAST_N_TOKENS_SIZE] [--lora_base LORA_BASE] [--lora_path LORA_PATH] [--numa NUMA]
                   [--chat_format CHAT_FORMAT] [--clip_model_path CLIP_MODEL_PATH] [--cache CACHE] [--cache_type CACHE_TYPE] [--cache_size CACHE_SIZE]
                   [--hf_tokenizer_config_path HF_TOKENIZER_CONFIG_PATH] [--hf_pretrained_model_name_or_path HF_PRETRAINED_MODEL_NAME_OR_PATH]
                   [--hf_model_repo_id HF_MODEL_REPO_ID] [--draft_model DRAFT_MODEL] [--draft_model_num_pred_tokens DRAFT_MODEL_NUM_PRED_TOKENS] [--type_k TYPE_K]
                   [--type_v TYPE_V] [--verbose VERBOSE] [--host HOST] [--port PORT] [--ssl_keyfile SSL_KEYFILE] [--ssl_certfile SSL_CERTFILE] [--api_key API_KEY]
                   [--interrupt_requests INTERRUPT_REQUESTS] [--disable_ping_events DISABLE_PING_EVENTS] [--root_path ROOT_PATH] [--config_file CONFIG_FILE]

////

# Move script file to done folder
mv ~/script6.sh ~/done
mv ~/next/script7.sh  ~/

echo "  "
echo "Will shut down Ubuntu console"
echo "----------"
echo " "
sleep 9
wsl.exe  --shutdown
