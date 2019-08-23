import flask as fl
from instagram_private_api import Client, ClientCompatPatch
import json
import pickle

encoding = 'utf-8'
app = fl.Flask(__name__)

@app.route('/')
def start():
    return "HELLO INFO"

@app.route('/instagram/login/<username>/<password>')
def auth(username,password):
    global api
    #load cookies
    with open('cookie', "rb") as f:
        cook = pickle.load(f)
    

    api = Client(str(username),str(password),cookie=cook)
    info = api.user_info(api.authenticated_params['_uid'])

    #save cookies
    #as = pickle.dumps(api.cookie_jar.dump(), f)
    user_info = {}
    user_info['fullName'] = info['user']['full_name']
    user_info['nickName'] = info['user']['username']
    user_info['imgUrl'] = info['user']['profile_pic_url']
    
    

    return fl.jsonify(user_info)


if __name__ == '__main__':
    app.run()