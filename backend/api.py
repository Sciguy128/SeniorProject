import time
from flask import Flask, jsonify, request
from flask_cors import CORS
import psycopg2

database_url = "postgres://teammate:crowdsearch@172.20.82.116:5433/crowd_search"
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

@app.route('/api/users/add', methods=['POST'])
def add_user():
    try:
        data = request.get_json()
        id = data["id"]
        name = data["name"]
        email = data["email"]
        
        cur.execute("SELECT add_user(%s, %s, %s)", (id, name, email))
        conn.commit()
        
        return jsonify({"message": f"{name}'s profile created successfully"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400
    
@app.route('/api/users/delete', methods=['POST'])
def delete_user():
    try:
        data = request.get_json()
        id = data["id"]
        
        cur.execute("SELECT delete_user(%s)", (id))
        conn.commit()
        
        return jsonify({"message": f"Profile {id} deleted successfully"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400

'''
Curl methods to test the backend integration:

curl -X POST http://localhost:5000/api/users/add \
     -H "Content-Type: application/json" \
     -d '{"id": "1", "name": "Test", "email": "Test@test.com"}'
     
curl -X POST http://localhost:5000/api/users/delete \
     -H "Content-Type: application/json" \
     -d '{"id": "1"}'
'''