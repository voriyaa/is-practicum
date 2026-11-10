import os

import psycopg
from flask import Flask, jsonify

app = Flask(__name__)


def connect():
    return psycopg.connect(
        host=os.environ.get("DB_HOST", "localhost"),
        port=os.environ.get("DB_PORT", "5432"),
        dbname=os.environ.get("DB_NAME", "app"),
        user=os.environ.get("DB_USER", "app"),
        password=os.environ.get("DB_PASSWORD", ""),
    )


@app.get("/health")
def health():
    return jsonify(status="ok")


@app.get("/")
def index():
    with connect() as conn:
        conn.execute("CREATE TABLE IF NOT EXISTS visits (id SERIAL PRIMARY KEY, visited_at TIMESTAMP DEFAULT now())")
        conn.execute("INSERT INTO visits DEFAULT VALUES")
        count = conn.execute("SELECT count(*) FROM visits").fetchone()[0]
    return jsonify(visits=count)
