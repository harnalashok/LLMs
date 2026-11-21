# 0.0 Import necessary libraries
from fastapi import FastAPI, Request
from crewai import Crew, Agent, Task, LLM
import uvicorn

# 1.0 Initialize FastAPI app
app = FastAPI()

# 2.0 Define local Ollama LLM configuration
local_llm = LLM(
    model="ollama/qwen2.5:latest",
    base_url="http://localhost:11434"
)

# 3.0 Run the crew (async so it doesn't block FastAPI's event loop)
async def run_my_crew(webhook_data: dict):
    researcher = Agent(
        role="Senior Research Analyst",
        goal="Uncover cutting-edge developments in specific topics",
        backstory="You are an expert researcher hungry for new trends.",
        verbose=True,
        llm=local_llm
    )

    research_task = Task(
        description="Analyze the following topic thoroughly: {topic}",
        expected_output="A bullet-point summary of the top 3 insights.",
        agent=researcher
    )

    crew = Crew(agents=[researcher], tasks=[research_task], verbose=True)

    return await crew.kickoff_async(
        inputs={"topic": webhook_data.get("topic", "General AI")}
    )

# 4.0 FastAPI endpoint to receive webhook data
@app.post("/webhook")
async def receive_webhook(request: Request):
    # 4.1 Receive the JSON payload from the webhook request
    payload = await request.json()
    print(f"Received webhook data: {payload}")

    # 4.2 Pass the payload to the crew (await must be inside the async function)
    crew_output = await run_my_crew(payload)

    # 4.3 Return the crew output as a JSON response
    return {"crew_output": str(crew_output)}

# 5.0 Run the FastAPI server using Uvicorn web server
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)