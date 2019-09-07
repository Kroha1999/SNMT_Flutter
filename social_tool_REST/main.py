import flask as fl
from flask import request
from instagram_private_api import Client, ClientCompatPatch,MediaRatios
from instagram_private_api_extensions import media
import json
import pickle
import uuid

import binascii
import copy
import sys

import languages

encoding = 'utf-8'
app = fl.Flask(__name__)

user_cache = {}
posts_statuses_cache={}

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


@app.route('/translate', methods = ['POST'])
def translateText():
  text = request.form['text']
  targetLang = request.form['lang']
  translated = languages.translate(text,languages.LANGTOCODES[targetLang.lower()])
  print(translated)
  return translated

@app.route('/post',methods =['POST'])
def postApost():
  #TODO: posting
  #here empty string ("") will be equal to None


  postUid = request.form['uidPost']
  uid = request.form['uid']
  text = request.form['text']
  translate = request.form['trans']
  targetLang = request.form['lang']
  location = request.form['loc']
  photo = request.form['photo']
  social = request.form['social']
  width = request.form['width']
  height = request.form['height']
  status = request.form['status']

  res = postToWeb(uid,text,translate,targetLang,location,photo,social,width,height)
  
  #storing post statuses
  addPostStatus(status,postUid,uid,res)
  return res
  
def addPostStatus(status,postUid,accUid,res):
  global posts_statuses_cache
  #getting stored data about posts statuses
  if posts_statuses_cache == {}:
    with open('cookies/postStatuses', "rb") as f:
      posts_statuses_cache = pickle.load(f)

  #setting status
  try:
    posts_statuses_cache[str(postUid)]['status'] = status
    posts_statuses_cache[str(postUid)][str(accUid)] = res
  except:
    posts_statuses_cache[str(postUid)] = {}
    posts_statuses_cache[str(postUid)]['status'] = status
    posts_statuses_cache[str(postUid)][str(accUid)] = res
  
  #saving stored data
  with open('cookies/postStatuses', "wb") as f:
    pickle.dump(posts_statuses_cache,f)

def postToWeb(uid,text,translate,targetLang,location,photo,social,width,height):
  #looking for account
  account = None
  try:
      if not (uid in user_cache.keys()):
        with open('cookies/cookie2', "rb") as f:
          user_cook = pickle.load(f)
        print('not cahced uid = '+str(uid), file=sys.stdout)
        user_cache[uid] = Client('user','pass',cookie=user_cook[uid])
        
        account = user_cache[uid]
      else:
        print('cahced uid', file=sys.stdout)
        account = user_cache[uid]
  except Exception as e:
    return fl.jsonify(str(e))

  print(text, file=sys.stdout)
  
  #checking Image
  if(translate == 'true' and text != ''):
    text = languages.translate(text,languages.LANGTOCODES[targetLang.lower()])

  #checking photo for instagram and posting to Instagram
  if(social == 'Instagram' and photo == ''):
    return 'INSTAGRAM POST: No photo added'
  else:
    if(location == ''):
      location = None
    else:
      location = account.location_info(location)['location']
      location['address'] = location['lat']
    try:
      #account.post_photo(binascii.a2b_base64(photo), (int(width),int(height)),text,location = location)
      return 'Success' 
    except Exception as ex:
      return str(ex)



if __name__ == '__main__':
    app.run()
    #app.run(host= '0.0.0.0', port=8090)
