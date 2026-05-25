from fastapi import FastAPI, HTTPException
from prometheus_fastapi_instrumentator import Instrumentator
from pydantic import BaseModel
from typing import Optional
import uuid
app = FastAPI(title="TaskAPI", version="1.0.0")
Instrumentator().instrument(app).expose(app)
tasks = {}
class Task(BaseModel):
    title: str
    description: Optional[str] = None
    done: bool = False
class TaskResponse(Task):
    id: str
@app.get("/health")
def health_check():
    return {"status": "healthy", "version": "1.0.0"}
@app.get("/tasks", response_model=list[TaskResponse])
def list_tasks():
    return [TaskResponse(id=k, **v) for k, v in tasks.items()]
@app.post("/tasks", response_model=TaskResponse, status_code=201)
def create_task(task: Task):
    task_id = str(uuid.uuid4())
    tasks[task_id] = task.model_dump()
    return TaskResponse(id=task_id, **tasks[task_id])
@app.get("/tasks/{task_id}", response_model=TaskResponse)
def get_task(task_id: str):
    if task_id not in tasks:
        raise HTTPException(status_code=404, detail="Task not found")
    return TaskResponse(id=task_id, **tasks[task_id])
@app.delete("/tasks/{task_id}", status_code=204)
def delete_task(task_id: str):
    if task_id not in tasks:
        raise HTTPException(status_code=404, detail="Task not found")
    del tasks[task_id]
