import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

import "package:social_tool/Data/dataController.dart";

String url = "http://10.0.3.2:5000";


class AccountData{
  final String _socialNetwork;
  String _nickName;
  String _fullName;
  String _imgUrl;
  String _lang;
  String _uid;

  //INSTA
  int _numberOfLikes;
  int _numberOfComments;
  Map<String, dynamic> _genInfoVar;

  AccountData(this._socialNetwork);
  
  //GETTERS AND SETTERS
  String getSocial(){
    return this._socialNetwork;
  }
  String getNick(){
    return this._nickName;
  }
  String getImg(){
    return this._imgUrl;
  }
  String getLang(){
    return this._lang;
  }
  void setLang(String lan){
    this._lang = lan;
  }
  String getID(){
    return this._uid;
  }

  int getLikes(){
    return this._numberOfLikes;
  }
  
  int getComments(){
    return this._numberOfComments;
  }
  
  Map<String, dynamic> getGenInfoVariable(){
    return this._genInfoVar;
  }



  //Deserializing object from json
  AccountData.fromJson(Map<String, dynamic> json)
      : _socialNetwork = json['soc'],
        _nickName = json['nick'],
        _fullName = json['fullName'],
        _imgUrl = json['img'],
        _lang = json['lang'],
        _uid = json['uid'];

  //creating AccountData from json strings
  static AccountData newAccFromJson(Map<String, dynamic> json){
    var acc = AccountData(json['soc']);
    acc._nickName = json['nick'];
    acc._fullName = json['fullName'];
    acc._imgUrl = json['img'];
    acc._lang = json['lang'];
    acc._uid = json['uid'];
    //updating data (in case something was changed[img,name,...,etc])
    acc.updateData(acc._uid);
    return acc;
  }

  //Serializing object to json
  Map<String, dynamic> toJson() => {
    'soc' : _socialNetwork,
    'nick' : _nickName,
    'fullName' : _fullName,
    'img' : _imgUrl,
    'lang' : _lang,
    'uid' : _uid
  };



  //FUNCTIONS --------------------------------------------------------------------------
  //Auth request and responce 
  Future<String> auth(nick,password,lan) async {
    this._lang = lan;
    print("Logging In");
    var resp = await http.get(url+"/instagram/login/"+nick+"/"+password).then(_processResponce);
    await getInfo();
    await getGenInfo();
    return resp;
  }

  //updateAccountData by uid
  Future<String> updateData(uid) async {
    print("Updating Data");
    var resp = await http.get(url+"/instagram/login/"+uid).then(_processResponce);
    print("Updating Data");
    await getInfo();
    await getGenInfo();
    return resp;
  }
  
  //_processResponce for auth and updateData funcs
  String _processResponce(http.Response response)  {
    print("RESP: "+response.statusCode.toString());
    if (response.statusCode == 200){
      
      //print(response.body);

      try{
        //on successful responce
        Map<String, dynamic> userInfo =jsonDecode(response.body);
        this._nickName = userInfo['nickName'];
        this._fullName = userInfo['fullName'];
        this._imgUrl = userInfo['imgUrl'];
        this._uid = userInfo['userKey'];
        // initialize VIew
        DataController.createAccView(
          this._fullName, 
          this._nickName, 
          this._socialNetwork, 
          this._lang, 
          this._uid,
          this._imgUrl
        );
        print(this._nickName.toString() + " View SUCEESS");
        return "Success";
        
      } catch(e){
        return response.body;
      }
    }
    else{
      print("ERROR: "+response.statusCode.toString()+": ERROR");
      return "Error";
    }
  }

  //updateAccountData by uid
  void removeAccount({String uid}) async {
    if(uid == null){
      uid = _uid;
    }

    print("DELETING DATA FROM WEB");
    await http.delete(url+"/remove/"+uid);
  }
  
  Future<Map<String, dynamic>> getInfo({String uid})async{
    if(uid == null){
      uid = _uid;
    }
    //int numbOfLikes = 0;
    http.Response response = await http.get(url+"/instagram/info/"+uid);
    print(response.body);
    Map<String, dynamic> val = jsonDecode(response.body);
    this._numberOfComments = val['comments'];
    this._numberOfLikes = val['likes'];
    return val;
  }

  Future<Map<String, dynamic>> getGenInfo({String uid}) async
  {
    if(uid == null){
      uid = _uid;
    }
    http.Response response = await http.get(url+"/instagram/genInfo/"+uid);
    
    Map<String, dynamic> val = jsonDecode(response.body);
    this._genInfoVar = val['user'];
    return val;
  }

  void postAPhoto(){}

}