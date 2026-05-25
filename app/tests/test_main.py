from fastapi.testclient import TestClient
from app.main import app
client = TestClient(app)
def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"
def test_create_and_get_task():
    response = client.post("/tasks", json={"title": "Learn DevOps", "description": "Seriously"})
    assert response.status_code == 201
    task_id = response.json()["id"]
    response = client.get(f"/tasks/{task_id}")
    assert response.status_code == 200
    assert response.json()["title"] == "Learn DevOps"
def test_delete_task():
    response = client.post("/tasks", json={"title": "Delete me"})
    task_id = response.json()["id"]
    response = client.delete(f"/tasks/{task_id}")
    assert response.status_code == 204
def test_get_nonexistent_task():
    response = client.get("/tasks/does-not-exist")
    assert response.status_code == 404
