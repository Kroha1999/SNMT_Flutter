import flask as fl
from instagram_private_api import Client, ClientCompatPatch
import json
import pickle
import uuid

import copy
import sys

encoding = 'utf-8'
app = fl.Flask(__name__)

user_cache = {}

@app.route('/')
def start():
    return "HELLO INFO"

@app.route('/instagram/login/<username>/<password>')
def auth(username,password):
    #cached apis
    global user_cache 
    #load cookies
    with open('cookies/cookie2', "rb") as f:
        user_cook = pickle.load(f)
    
    try:
      uid = str(uuid.uuid4())
      #cahing in order to use during this session of server side
      #cahcing just api variable 
      
      user_cache[uid] = Client(str(username),str(password))#,cookie=user_cook['df8a7cbf-6528-4fff-a7e4-64b3cd53cbcb'])
      info = user_cache[uid].user_info(user_cache[uid].authenticated_params['_uid'])

      user_info = {}
      user_info['fullName'] = info['user']['full_name']
      user_info['nickName'] = info['user']['username']
      user_info['imgUrl'] = info['user']['profile_pic_url']
      #UID consists of 3 parts: 'socNetwork'+'username(as id for account)'+'uuid'
      user_info['userKey'] = "inst"+info['user']['username']+uid

      user_cook[user_info['userKey']] = user_cache[uid].cookie_jar.dump()

      with open('cookies/cookie2', "wb") as f:
        pickle.dump(user_cook,f)

      return fl.jsonify(user_info)

    except Exception as e:
      return fl.jsonify(str(e))

@app.route('/instagram/login/<uid>')
def reAuth(uid):
    #cached apis
    global user_cache 

    with open('cookies/cookie2', "rb") as f:
        users_cook = pickle.load(f)

    try:
      if not (uid in user_cache.keys()):

        print('not cahced uid', file=sys.stdout)

        user_cache[uid] = Client('user','pass',cookie=users_cook[uid])
        info = user_cache[uid].user_info(user_cache[uid].authenticated_params['_uid'])

        user_info = {}
        user_info['fullName'] = info['user']['full_name']
        user_info['nickName'] = info['user']['username']
        user_info['imgUrl'] = info['user']['profile_pic_url']
        user_info['userKey'] = uid

        return fl.jsonify(user_info)
      else:
        print('cahced uid', file=sys.stdout)
        info = user_cache[uid].user_info(user_cache[uid].authenticated_params['_uid'])

        user_info = {}
        user_info['fullName'] = info['user']['full_name']
        user_info['nickName'] = info['user']['username']
        user_info['imgUrl'] = info['user']['profile_pic_url']
        user_info['userKey'] = uid

        return fl.jsonify(user_info)

    except Exception as e:
      return fl.jsonify(str(e))



if __name__ == '__main__':
    app.run()