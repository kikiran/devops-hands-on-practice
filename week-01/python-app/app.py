import os
import socket

from flask import Flask, jsonify, send_from_directory

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
STATIC_DIR = os.path.join(BASE_DIR, "static")

app = Flask(__name__, static_folder=os.path.join(STATIC_DIR, "assets"), static_url_path="/assets")

APP_NAME = os.getenv("APP_NAME", "python-app")
VERSION = os.getenv("APP_VERSION", "5.0.0")


@app.get("/")
def index():
    return send_from_directory(STATIC_DIR, "index.html")


@app.get("/health")
def health():
    return jsonify(status="ok")


@app.get("/ready")
def ready():
    return jsonify(status="ready")


@app.get("/info")
def info():
    return jsonify(
        app=APP_NAME,
        stack="Python 3.12 + Flask",
        version=VERSION,
        hostname=socket.gethostname(),
        message="Real estate landing template",
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", "5000")), threaded=True)