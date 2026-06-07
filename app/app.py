from flask import Flask, jsonify, request
import os
import json
import datetime

app = Flask(__name__)

# Simulated message queue (represents Service Bus in real world)
message_log = []

def calculate_tax(salary):
    """Simple UK tax calculation simulation"""
    personal_allowance = 12570
    basic_rate_limit = 50270
    
    if salary <= personal_allowance:
        tax = 0
    elif salary <= basic_rate_limit:
        tax = (salary - personal_allowance) * 0.20
    else:
        tax = (basic_rate_limit - personal_allowance) * 0.20
        tax += (salary - basic_rate_limit) * 0.40
    
    return round(tax, 2)

@app.route("/")
def index():
    return jsonify({
        "status": "ok",
        "message": "Hello from AKS!",
        "version": os.getenv("APP_VERSION", "1.0.0"),
        "endpoints": [
            "GET  /",
            "GET  /health",
            "GET  /ready",
            "POST /calculate-tax",
            "GET  /messages"
        ]
    })

@app.route("/health")
def health():
    return jsonify({"status": "healthy"}), 200

@app.route("/ready")
def ready():
    return jsonify({"status": "ready"}), 200

@app.route("/calculate-tax", methods=["POST"])
def calculate_tax_endpoint():
    data = request.get_json()

    if not data or "salary" not in data:
        return jsonify({"error": "please provide a salary"}), 400

    salary = data["salary"]
    tax = calculate_tax(salary)
    take_home = salary - tax

    # Simulate publishing to Service Bus
    message = {
        "event": "tax-calculation-completed",
        "timestamp": datetime.datetime.utcnow().isoformat(),
        "payload": {
            "salary": salary,
            "tax": tax,
            "take_home": take_home,
            "tax_rate": round((tax / salary * 100), 2) if salary > 0 else 0
        }
    }
    message_log.append(message)

    return jsonify({
        "salary": salary,
        "tax": tax,
        "take_home": take_home,
        "message": "calculation complete — event published to Service Bus"
    }), 200

@app.route("/messages")
def get_messages():
    """Shows simulated Service Bus message log"""
    return jsonify({
        "total_messages": len(message_log),
        "messages": message_log
    }), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)