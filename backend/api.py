import time
from flask import Flask, jsonify, request
from flask_cors import CORS
import psycopg2


database_url = "postgres://postgres:crowdsearch@crowd-search.craysg28gzdu.us-east-2.rds.amazonaws.com:5432/crowd_search"
app = Flask(__name__)

CORS(app)

conn = psycopg2.connect(database_url)
cur = conn.cursor()

@app.route('/api/time')
def get_current_time():
    return {'time': time.time()}

@app.route('/api/crowds', methods=['GET'])
def get_crowds():
    cur.execute("SELECT name, crowd_level FROM LOCATIONS")
    crowds = cur.fetchall()
    crowds_list = [{"name": row[0], "crowd_level": row[1]} for row in crowds]
    return jsonify(crowds_list)

@app.route('/api/users', methods=['GET'])
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
        
        cur.execute("SELECT delete_user(%s)", (id,))
        conn.commit()
        
        return jsonify({"message": f"Profile {id} deleted successfully"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400
    
@app.route('/api/report', methods=['POST'])
def make_report():
    try:
        data = request.get_json()
        user_id = data["user_id"]
        location = data["location"]
        crowd_level = int(data["crowd_level"])
        
        cur.execute("SELECT create_report(%s, %s, %s)", (user_id, location, crowd_level))
        cur.execute("SELECT update_crowd(%s)", (location,))
        cur.execute("SELECT update_xp(%s)", (user_id,))
        conn.commit()
        
        return jsonify({"message": f"Location {location} crowd level updated succesfully"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400

'''
Curl methods to test the backend integration:

curl -X GET http://localhost:5000/api/crowds

curl -X POST http://localhost:5000/api/users/add \
     -H "Content-Type: application/json" \
     -d '{"id": "1", "name": "Test", "email": "Test@test.com"}'
     
curl -X POST http://localhost:5000/api/users/delete \
     -H "Content-Type: application/json" \
     -d '{"id": "1"}'
     
curl -X POST http://localhost:5000/api/report \
     -H "Content-Type: application/json" \
     -d '{"user_id": "2", "location": "Leutner Commons", "crowd_level": "5"}'
'''