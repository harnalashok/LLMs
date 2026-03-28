# Last amended: 24th June, 2025
# My folder:
# Flowise file: smartFlow Chatflow.json
# Open the file in Visual Studio Code

import requests

# 
# API_URL = "http://localhost:3000/api/v1/prediction/d18e4d84-3a36-4fd5-80c5-570b9a0339a3"
API_URL = "http://localhost:3000/api/v1/prediction/d18e4d84-3a36-4fd5-80c5-570b9a0339a3"

def query(payload):
    response = requests.post(API_URL, json=payload)
    return response.json()


myquestion = "My name is ashok kumar harnal. I stay in House No 456, sector 15a, Faridabad. My mobile number is: 97596963. I work in garment factory as a clerk"

output = query({
    "question": myquestion,
})


print(output)

#from IPython.display import display_markdown
#display_markdown(output['text'])