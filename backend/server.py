from flask import Flask, request
from flask_cors import CORS
from flask_bcrypt import Bcrypt
from connect import Connection
from bson.objectid import ObjectId
from bson import json_util


# initializations

app = Flask(__name__)
app.config['SECRET_KEY'] = 'so_secret'

CORS(app)
bcrypt = Bcrypt(app)

db = Connection()

# utilities

def json_encode(data):
    return json_util.dumps(data)

# routers

@app.route('/test')
def test():
    d = list(db._getUsers())
    return json_encode(d)

@app.route('/')
def index():
    return "This is entry"

@app.route('/register', methods=['POST'])
def register():
    """
    @req: FormData({sid: str, password: str, name: str})
    @res: message: str
    """
    sid = request.json['sid']
    password = request.json['password']
    name = request.json['name']

    # p_hash = bcrypt.generate_password_hash(password).decode('utf-8')
    # id = db.newUser(sid, p_hash, name)
    id = db.newUser(sid, password, name)
    if id == None:
        return "You have already registered"

    return "Register success"

@app.route('/login', methods=['POST'])
def login():
    """
    @req: FormData({sid: str, password: str})
    @res: userdata: json
    """
    sid = request.json['sid']
    password = request.json['password']

    # p_hash = bcrypt.generate_password_hash(password).decode('utf-8')
    # userdata = db.login(sid, p_hash)
    userdata = db.login(sid, password)
    if userdata == None:
        return "Who are you?"

    return json_encode(userdata)

@app.route('/users/<id>', methods=['GET'])
def get_user(id):
    """
    """
    oid = ObjectId(id)
    userdata = db.getUserData(oid)

    return json_encode(userdata)

@app.route('/call', methods=['POST'])
def call():
    pid = request.json['pid']
    s = request.json['s']
    d = request.json['d']

    pid = ObjectId(pid)
    call_oid = db.newRequest(pid, s, d)
    
    return json_encode(call_oid)['$oid']

@app.route('/rides/<id>', methods=['GET'])
def get_ride(id):
    oid = ObjectId(id)

    ride_data = db.getRequestData(oid)
    if ride_data == None:
        return 'failed'
    return json_encode(ride_data)

@app.route('/search', methods=['GET'])
def search():
    s = request.json['s']
    d = request.json['d']

    searched_rides = list(db.search(s,d))
    return json_encode(searched_rides)

@app.route('/take', methods=['POST'])
def take():
    oid = request.json['oid']
    did = request.json['did']

    oid = ObjectId(oid)
    did = ObjectId(did)

    ride_data = db.takeRequest(oid, did)
    if ride_data == None:
        return 'failed'
    
    return json_encode(ride_data)

@app.route('/cancel', methods=['POST'])
def cancel():
    oid = request.json['oid']
    id = request.json['id']
    
    oid = ObjectId(oid)
    id = ObjectId(id)

    result = db.cancelReq(oid, id)
    return json_encode(result)

@app.route('/finish', methods=['POST'])
def finish():
    oid = request.json['oid']
    id = request.json['id']

    oid = ObjectId(oid)
    id = ObjectId(id)
    
    result = db.finishReq(oid, id)
    return json_encode(result)

@app.route('/review', methods=['POST'])
def review():
    oid = request.json['oid']
    id = request.json['id']
    rate = request.json['rate']

    oid = ObjectId(oid)
    id = ObjectId(id)
    rate = int(rate)

    result = db.review(oid, id, rate)
    return json_encode(result)

@app.route('/set_driver', methods=['POST'])
def set_driver():
    oid = request.json['oid']
    oid = ObjectId(oid)
    result = db.setDriver(oid)
    return json_encode(result)

@app.route('/profile', methods=['POST'])
def set_profile():
    oid = request.json['id']
    name = request.json['name']
    dept = request.json['dept']
    grade = request.json['grade']
    gender = request.json['gender']

    oid = ObjectId(oid)
    grade = int(grade)

    result = db.editProfile(oid, name, dept, grade, gender)
    return json_encode(result)

@app.route('/cert', methods=['POST'])
def post_cert():
    # not sure if this works
    oid = request.json['oid']
    f = request.files['file']
    t = 'jpg'
    oid = ObjectId(oid)
    result = db.uplodeCert(oid, f, t)
    return result

# TODO: No API to use db.extractCert yet
