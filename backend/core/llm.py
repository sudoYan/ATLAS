import httpx
from pydantic import BaseModel, Field
from typing import List, Literal, Optional

class Task(BaseModel):
    title: str
    description: str
    cognitive_load: Literal["Deep Creative", "Administrative", "Low Effort"]
    deadline: Optional[str] = Field(None, description="YYYY-MM-DD")
    project: Optional[str] = "General"
    completion: float = 0.0

class StructuredResponse(BaseModel):
    tasks: List[Task]
    summary: str

async def generate_structured(prompt: str, schema: type[BaseModel], model: str = "qwen2.5:7b") -> dict:
    async with httpx.AsyncClient(timeout=60.0) as client:
        response = await client.post(
            "http://localhost:11434/api/chat",
            json={
                "model": model,
                "messages": [{"role": "user", "content": prompt}],
                "format": schema.model_json_schema(),
                "stream": False
            }
        )
        response.raise_for_status()
        return response.json()["message"]["content"]