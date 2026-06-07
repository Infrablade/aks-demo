import pytest
from app import app as flask_app

@pytest.fixture
def client():
    flask_app.config["TESTING"] = True
    with flask_app.test_client() as client:
        yield client

def test_index_returns_200(client):
    response = client.get("/")
    assert response.status_code == 200

def test_index_returns_ok_status(client):
    response = client.get("/")
    data = response.get_json()
    assert data["status"] == "ok"

def test_health_returns_200(client):
    response = client.get("/health")
    assert response.status_code == 200

def test_health_returns_healthy(client):
    response = client.get("/health")
    data = response.get_json()
    assert data["status"] == "healthy"

def test_ready_returns_200(client):
    response = client.get("/ready")
    assert response.status_code == 200

def test_calculate_tax_valid(client):
    response = client.post("/calculate-tax",
        json={"salary": 50000},
        content_type="application/json"
    )
    assert response.status_code == 200
    data = response.get_json()
    assert "tax" in data
    assert "take_home" in data

def test_calculate_tax_missing_salary(client):
    response = client.post("/calculate-tax",
        json={},
        content_type="application/json"
    )
    assert response.status_code == 400

def test_messages_endpoint(client):
    response = client.get("/messages")
    assert response.status_code == 200
    data = response.get_json()
    assert "total_messages" in data

def test_calculate_tax_includes_ni(client):
    response = client.post("/calculate-tax",
        json={"salary": 50000},
        content_type="application/json"
    )
    assert response.status_code == 200
    data = response.get_json()
    assert "national_insurance" in data
    assert "total_deductions" in data
    assert "effective_tax_rate" in data
    assert data["national_insurance"] > 0