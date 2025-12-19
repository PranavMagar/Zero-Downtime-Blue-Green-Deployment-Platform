from flask import Flask, request, jsonify
import os
from datetime import datetime

app = Flask(__name__)

APP_VERSION = os.getenv("APP_VERSION", "v1")
events = []

@app.route("/")
def home():
    return f"User Activity Service running - version {APP_VERSION}"

@app.route("/health")
def health():
    return jsonify(status="UP", version=APP_VERSION)

@app.route("/version")
def version():
    return jsonify(version=APP_VERSION)

@app.route("/event", methods=["POST"])
def add_event():
    data = request.get_json(silent=True)
    if not data:
        return jsonify(error="Invalid or missing JSON body"), 400

    event = {
        "user": data.get("user"),
        "action": data.get("action"),
        "timestamp": datetime.utcnow().isoformat() + "Z"
    }
    events.append(event)
    return jsonify(message="Event recorded", event=event), 201

@app.route("/events")
def get_events():
    return jsonify(events)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
