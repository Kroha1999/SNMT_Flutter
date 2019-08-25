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

  AccountData(this._socialNetwork);




  //Deserializing object from json
  AccountData.fromJson(Map<String, dynamic> json)
      : _socialNetwork = json['soc'],
        _nickName = json['nick'],
        _fullName = json['fullName'],
        _imgUrl = json['img'],
        _lang = json['lang'],
        _uid = json['uid'];

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
    return resp;
  }

  //reauth from uid
  Future<String> updateData(uid) async {
    print("Updating Data");
    var resp = await http.get(url+"/instagram/login/"+uid).then(_processResponce);
    return resp;
  }
  
  String _processResponce(http.Response response)  {
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
          this._imgUrl
        );
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
  
  
  String getKey()
  {
    return _uid;
  }
  
  
  void selfUpdate(){}
  void postAPhoto(){}

}