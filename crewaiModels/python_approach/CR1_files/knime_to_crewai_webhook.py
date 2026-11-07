# Last Updated: 7th November 2026
# FastAPI server: It receives webhook data
#                 and passes it to a CrewAI crew
#                 for processing.

# Objective: This script demonstrates how to set up a FastAPI server 
#            that listens for incoming webhook requests and passes the 
#            received data to a CrewAI crew for processing. It uses an 
#            Ollama LLM model for generating insights based on the webhook 
#            payload.
#
# CrewAI Ref: https://docs-platform.crewai.com/platform/en/guides/webhook-automation



"""
AA. How?
=======

To receive data from a webhook and pass it directly into your
CrewAI crew, the standard and most reliable method is to wrap 
your CrewAI execution inside a lightweight API framework like
FastAPI.
Because CrewAI runs locally in Python, it cannot directly 
"listen" to HTTP requests on its own. FastAPI acts as the web 
server that intercepts the webhook payload from an external 
service (like Stripe, GitHub, or Typeform) and forwards 
that data to crew.kickoff().

"""
# To kill a process running on port 8000 
#   sudo fuser -k 8000/tcp

"""
BB. How to test?
========

1. Start the FastAPI server by running this script:
    
     . activate_crewai_env.sh
    cd python_approach/CR1_files
    python knime_to_crewai_webhook.py
    
2. In a separate terminal, execute:
    curl -X POST http://localhost:8000/webhook -H "Content-Type: application/json" -d '{"topic": "Quantum Computing", "user": "Alice"}'

3. Open KNIME file: knime_to_crewai_webhook and run the workflow.
     On running the workflow, it will send a POST request to the FastAPI 
       server with a JSON payload.
       
   Complete address of KNIME file is: 
     knime://LOCAL/final_for_class/anomaly_detection/fast_fourier_transform/knime_to_crewai
   
"""

# 0.0 Import necessary libraries
from fastapi import FastAPI, Request, HTTPException
from crewai import Crew, Agent, Task, LLM
import uvicorn

# 1.0 Initialize FastAPI app
app = FastAPI()

# 2.0 Define local Ollama LLM configuration
local_llm = LLM(
    model="ollama/qwen2.5:latest",     
    base_url="http://localhost:11434"   
)


# 3.0 Changed to 'async def' to run smoothly inside FastAPI's loop
async def run_my_crew(webhook_data: dict):
    search_topic = webhook_data.get("topic", "General AI")
    
    # 3.1 Define the Agent and Task for the Crew
    researcher = Agent(
        role="Senior Research Analyst",
        goal="Uncover cutting-edge developments in specific topics",
        backstory="You are an expert researcher hungry for new trends.",
        verbose=True,
        llm=local_llm
    )
    
    # 3.2 Define the Task for the Agent
    research_task = Task(
        description="Analyze the following topic thoroughly: {topic}", 
        expected_output="A bullet-point summary of the top 3 insights.",
        agent=researcher
    )
    
    # 3.3 Create the Crew with the Agent and Task
    crew = Crew(
        agents=[researcher],
        tasks=[research_task],
        verbose=True
    )
    
    # 3.4 Changed from .kickoff() to 'await .kickoff_async()'
    #     So that while it waits for the crew to finish, 
    #     it doesn't block the FastAPI event loop.    
    
    result = await crew.kickoff_async(inputs={"topic": search_topic})
    return result

# 4.0 FastAPI endpoint to receive webhook data
@app.post("/webhook")
async def receive_webhook(request: Request):
    try:
        # 4.1 Receive the JSON payload from the webhook request
        payload = await request.json()
        print(f"Received webhook data: {payload}")
        
        # 4.2 Added 'await' before the asynchronous function call
        crew_output = await run_my_crew(payload)
        
        # 4.3 Return the crew output as a JSON response
        return {
            "status": "success",
            "message": "Crew successfully processed webhook data",
            "crew_output": str(crew_output)
        }
        
    # 4.4 Handle any exceptions that occur during processing    
    except Exception as e:
        print(f"Error during execution: {e}")
        raise HTTPException(status_code=400, detail=str(e))

# 5.0 Run the FastAPI server using Uvicorn web server
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)

