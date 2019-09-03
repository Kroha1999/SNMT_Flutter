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

#Returns client by uid if 
def getUserByUID(uid):
  global user_cache
  
  try:
    if not (uid in user_cache.keys()):
      
      with open('cookies/cookie2', "rb") as f:
        user_cook = pickle.load(f)
      
      user_cache[uid] = Client('user','pass',cookie=user_cook[uid])
      return user_cache[uid]
    
    else:
      return user_cache[uid]
  except Exception as e:
    return str(e)

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

      #print(str(user_cache[uid].user_detail_info(user_cache[uid].authenticated_params['_uid'])), file=sys.stdout)

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


    try:
      if not (uid in user_cache.keys()):

        with open('cookies/cookie2', "rb") as f:
          user_cook = pickle.load(f)
        
        print('not cahced uid', file=sys.stdout)

        user_cache[uid] = Client('user','pass',cookie=user_cook[uid])
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

@app.route('/remove/<uid>',methods=['DELETE'])
def removeAcc(uid):
  global user_cache 

  with open('cookies/cookie2', "rb") as f:
    user_cook = pickle.load(f)
  

  #Deleting from cache
  print("Poped :"+str(user_cache.pop(uid)), file=sys.stdout)
  #Deleting from storage
  print("Poped :"+str(user_cook.pop(uid)), file=sys.stdout)
  
  #saving changes
  with open('cookies/cookie2', "wb") as f:
    pickle.dump(user_cook,f)

  return "success"
  

@app.route('/instagram/info/<uid>')
def getLikes(uid):
  usr = getUserByUID(uid)
  usrId = usr.authenticated_params['_uid']
  
  number_of_likes = 0
  number_of_comments = 0

  #Pagination implemented through 'next_max_id'
  results = usr.user_feed(usrId)
  next_max_id = -100
  while next_max_id:
    if(next_max_id == -100):
      results = usr.user_feed(usrId)
    else:
      results = usr.user_feed(usrId, max_id=next_max_id)

    data = results['items']
    for x in data:
      number_of_likes += x['like_count']
      number_of_comments += x['comment_count']
    next_max_id = results.get('next_max_id')

  retVal = {
    'likes':number_of_likes,
    'comments':number_of_comments
  }
  return fl.jsonify(retVal)

@app.route('/instagram/genInfo/<uid>')
def getInfo(uid):
  usr = getUserByUID(uid)
  usrId = usr.authenticated_params['_uid']
  return fl.jsonify(usr.user_info(usrId))

@app.route('/location/<uid>/<text>')
def getLocSugestions(uid,text):
  usr = getUserByUID(uid)
  locs = usr.location_fb_search(text,usr.generate_uuid())
  suggestions = []
  #print(json.dumps(locs,indent=4,sort_keys=True))
  for i in locs['items']:
    suggestions.append({'location':{'lng':i['location']['lng'],'lat':i['location']['lat']},'id':i['location']['facebook_places_id'],'title':i['title'],'name':i['location']['name']})
  return fl.jsonify(suggestions)

if __name__ == '__main__':
    app.run()