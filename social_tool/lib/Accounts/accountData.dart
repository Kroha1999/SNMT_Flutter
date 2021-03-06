import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

import "package:social_tool/Data/dataController.dart";
import 'package:social_tool/Data/globalVals.dart';


class AccountData{
  final String _socialNetwork;
  String _nickName;
  String _fullName;
  String _imgUrl;
  String _lang;
  String _uid;
  bool needsRelogin = false;

  //INSTA
  int _numberOfLikes;
  int _numberOfComments;
  Map<String, dynamic> _genInfoVar;

  AccountData(this._socialNetwork);
  
  //GETTERS AND SETTERS
  String getSocial(){
    return this._socialNetwork;
  }
  String getSocialUrl(){
    return _socialNetwork == "Instagram" ? Globals.instImg:
                        _socialNetwork == "Twitter"?Globals.twitImg:Globals.faceImg;
  }
  String getNick(){
    return this._nickName;
  }
  String fullName(){
    return this._fullName;
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
  static AccountData newAccFromJson(Map<String, dynamic> json,{bool update = true}){
    var acc = AccountData(json['soc']);
    acc._nickName = json['nick'];
    acc._fullName = json['fullName'];
    acc._imgUrl = json['img'];
    acc._lang = json['lang'];
    acc._uid = json['uid'];
    //updating data (in case something was changed[img,name,...,etc])
    if(update) 
      acc.updateData(acc._uid);
      //TODO: NEEDS RELOGIN MUST BE DONE
      if(acc.needsRelogin){
        print(acc._nickName.toString()+":  NEEDS RELOGIN");
        DataController.accountsDataInstances.remove(acc);
      }
      //print("QQQQQQQQQQQQQ: "+jsonEncode(acc));
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
    var resp = await http.get(Globals.url+"/instagram/login/"+nick+"/"+password).then(_processResponce);
    if(resp == 'Success'){
      await getInfo();
      await getGenInfo();
    }else{
      return resp.toString();
    }
    return resp;
  }

  //updateAccountData by uid
  Future<String> updateData(uid) async {
    print("Updating Data");
    var resp = await http.get(Globals.url+"/instagram/login/"+uid).then(_processResponce);
    if(resp == 'Success'){
      await getInfo();
      await getGenInfo();
    }
    else{
      needsRelogin = true;
    }
    print("Updating Data");

    return  resp;
  }
  
  //_processResponce for auth and updateData funcs
  Future<String> _processResponce(http.Response response) async {
    print("RESP: "+response.statusCode.toString());
    if (response.statusCode == 200){
      
      print(response.body);

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
    await http.delete(Globals.url+"/remove/"+uid);
  }
  
  Future<Map<String, dynamic>> getInfo({String uid})async{
    if(uid == null){
      uid = _uid;
    }
    //int numbOfLikes = 0;
    http.Response response = await http.get(Globals.url+"/instagram/info/"+uid);
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
    http.Response response = await http.get(Globals.url+"/instagram/genInfo/"+uid);
    
    Map<String, dynamic> val = jsonDecode(response.body);
    this._genInfoVar = val['user'];
    return val;
  }

  Future<String> translate(String text)async{
    http.Response resp = await http.post(Globals.url+'/translate',body: {'text':text,'lang':this.getLang()});
    if(resp.statusCode==200){
      print(resp.body);
    }
    return resp.body;
  }

  void postAPhoto(){}

}