# Test scripts

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
echo "Script: script7.sh"  | tee -a ~/error.log
echo "**********" | tee -a ~/error.log
echo " " | tee -a ~/error.log

conda deactivate

# Download ollama nomic-embed-text
if netstat -aunt   |  grep '11434'; then  
   echo " "      | tee -a ~/error.log
   echo "Ollama is already started"     | tee -a ~/error.log
   echo " "      | tee -a ~/error.log
 else  
    # Download ollama nomic-embed-text
    # Start ollama in background
    echo " "    | tee -a ~/error.log
    echo "-----------"    | tee -a ~/error.log
    echo "Starting ollama in background"    | tee -a ~/error.log
    echo "---------"    | tee -a ~/error.log
    echo " "    | tee -a ~/error.log
    ollama serve &  > /dev/null &
	echo "You may also start ollama, as: "     | tee -a ~/info.log
	echo "    ollama serve &  > /dev/null & "     | tee -a ~/info.log
	
fi

echo " "    | tee -a ~/error.log
echo " Pulling text-embedding model for ollama"    | tee -a ~/error.log
echo " "    | tee -a ~/error.log
echo "--------- "    | tee -a ~/error.log

ollama pull nomic-embed-text  2>> ~/error.log
sleep 2
echo "nomic-embed-text pulled"   | tee -a ~/error.log
echo "------- "    | tee -a ~/error.log
echo "nomic-embed-text pulled"   | tee -a ~/info.log
echo "------- "    | tee -a ~/info.log
echo " "    | tee -a ~/info.log

echo " "    | tee -a ~/error.log
echo "Will pull olom2 model, next. File size: 4.5gb"  | tee -a ~/error.log
read -p "Shall I go ahead and pull olom2 model (yY/nN? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo " "    | tee -a ~/error.log
    echo "OK. Pulling olomo2 model"    | tee -a ~/error.log
    ollama pull olmo2  2>> ~/error.log
	sleep 2
	echo "olmo2  pulled"   | tee -a ~/info.log
    echo "------- "    | tee -a ~/info.log
    echo " "    | tee -a ~/info.log
	sleep 5
fi

# Move script file to done folder
mv ~/script7.sh  ~/done

echo "Will test llama-cpp-python now"  | tee -a ~/error.log
echo  "*********"  | tee -a ~/error.log
echo " "  | tee -a ~/error.log
echo "Testing llama-cpp-python with Llama-2-13B-chat-GGUF" | tee -a ~/error.log
echo "Test llama-cpp-python, as: "  | tee -a ~/info.log
echo "     llama-cpp-python with Llama-2-13B-chat-GGUF" | tee -a ~/info.log
echo "Access it at localhost:8000/docs"  | tee -a ~/info.log
echo  "*********"  | tee -a ~/error.log

sleep 9

python3 -m llama_cpp.server --model ~/llama.cpp/models//llama-2-13b-chat.Q4_K_M.gguf --host 0.0.0.0 --port 8000 --chat functionary & 
echo "python3 -m llama_cpp.server --model ~/llama.cpp/models//llama-2-13b-chat.Q4_K_M.gguf --host 0.0.0.0 --port 8000 --chat functionary & "   | tee -a ~/info.log
echo " "  | tee -a ~/error.log
echo " "  | tee -a ~/info.log
exec sleep 9

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


exit

