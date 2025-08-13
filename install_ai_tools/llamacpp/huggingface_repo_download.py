# Last amended: 13th August, 2025
# This file downloads safetensors files from repo of huggingface
#

"""
# 1.0 Activate python venv 
cd ~/
./activate_langchain_venv.sh

"""

# 2.0 Install libraries
# cu124==>Cuda version 12.4 Check your installed cuda version using nvidia-smi
# pip install transformers torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124
# pip install mistral_common


# 3.0 Downloading medgamma repo files from huggingface

from huggingface_hub import snapshot_download
from huggingface_hub import login

# 3.1 Loginto huggingface
your_huggingface_token = "abcdefgh"  # Replace with your actual token
login(token=your_huggingface_token)

# 4.2 Replace 'your_organization/your_model_id' with the actual repository ID
#     This is medgemma repo
#     See: https://huggingface.co/google/medgemma-4b-it/tree/main
repo_id = "google/medgemma-4b-it"
local_dir = "./downloaded_safetensors" # Specify your desired local directory

# 4.3 Download .safetensors, .json and other files
snapshot_download(repo_id=repo_id, local_dir=local_dir, allow_patterns=["*.safetensors", "*.json", "*.model", "*.jinja" ])

######### DONE ##########

"""
Converting safetensors to gguf format

Ref:
1. https://medium.com/@kevin.lopez.91/simple-tutorial-to-quantize-models-using-llama-cpp-from-safetesnsors-to-gguf-c42acf2c537d

2. https://qwen.readthedocs.io/en/latest/quantization/llama.cpp.html

cd ~/
./activate_langchain_venv.sh
cd llama.cpp/
python convert_hf_to_gguf.py /home/$USER/downloaded_safetensors/ --outfile medgemma-2_fp16.gguf

"""

