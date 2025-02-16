import time
from flask import Flask, jsonify
from flask_cors import CORS
import psycopg2

# This will have to change for outside my local machine
database_url = "postgres://postgres:crowdsearch@localhost:5433/crowd_search"
app = Flask(__name__)

CORS(app)

conn = psycopg2.connect(database_url)
cur = conn.cursor()

@app.route('/api/time')
def get_current_time():
    return {'time': time.time()}

@app.route('/api/users')
def get_users():
    cur.execute("SELECT * FROM USERS")
    users = cur.fetchall()
    return jsonify(users)