import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:social_tool/Accounts/accountData.dart';
import 'dart:async';
import 'package:social_tool/Data/customWidgetsPostMake.dart';
import "package:social_tool/Data/dataController.dart";
import 'package:social_tool/Data/globalVals.dart';
import 'package:uuid/uuid.dart';

class PostData{
  String _uid;
  File _photo;
  Uint8List _photoImageDecoded;
  bool _translate;
  Map<String,dynamic> _location;
  List<AccountData> _accs;
  List<AdditionalString> _startStr;
  List<AdditionalString> _endStr;
  String _mainText;
  String _status;
  List<String> _socialsImgs; //INITIALIZED - NO NEED TO BE STORED
  List<String> _accsImgs;//INITIALIZED - NO NEED TO BE STORED
  DateTime _timeStamp ;

  
  String savePost(){
    String photoBytes = _photo != null ? base64Encode(_photo.readAsBytesSync()) : base64Encode(_photoImageDecoded.toList());
    List<String> accs = _accs.map((acc){return jsonEncode(acc);}).toList();

    List<Map<String,dynamic>> startStrings = _startStr.map((str){
      return {'typeOfAddString':str.typeOfAddString.toString(),
              'str':str.str,
              'socials':str.socials,
              'accounts':str.accounts.map((acc){return jsonEncode(acc);}).toList()//encoded accs
              };}).toList();

    List<Map<String,dynamic>> endStrings = _endStr.map((str){
      return {'typeOfAddString':str.typeOfAddString.toString(),
              'str':str.str,
              'socials':str.socials,
              'accounts':str.accounts.map((acc){return jsonEncode(acc);}).toList()//encoded accs
              };}).toList();
    
    Map<String,dynamic> postMap = { 'photo':photoBytes,
                                    'uid':_uid,
                                    'accs':accs,
                                    'location':_location,
                                    'translate':_translate,
                                    'startStr':startStrings,
                                    'endStr':endStrings,
                                    'mainText':_mainText,
                                    'status':_status,
                                    'timeStamp':_timeStamp.millisecondsSinceEpoch
                                    }; 
    return jsonEncode(postMap);//debugPrint(postMap.toString());
    //DataController.savePosts(jsonEncode(postMap));
  }

  static PostData loadPost(String postMap){
    Map<String,dynamic> map = jsonDecode(postMap);
    
    Uint8List photoUint = base64Decode(map['photo']);
    //File photo = File.fromRawPath(photoUint);
    bool translate = map['translate'];
    Map<String,dynamic> location = map['location'];
    String uid = map['uid'];

    List<dynamic> startStringsRaw = map['startStr'];
    List<AdditionalString> startStrings = startStringsRaw.map((str){ return AdditionalString(
                                                                                int.parse(str['typeOfAddString']),
                                                                                str['str'],
                                                                                getStrings(str['socials']),
                                                                                returnAccounts(str['accounts']));}).toList();

    List<dynamic> endStringsRaw = map['endStr'];
    List<AdditionalString> endStrings = endStringsRaw.map((str){ return AdditionalString(
                                                                                int.parse(str['typeOfAddString']),
                                                                                str['str'],
                                                                                getStrings(str['socials']),
                                                                                returnAccounts(str['accounts']));}).toList();                                                                          

    List<AccountData> accounts = returnAccounts(map['accs']);
    
    String mainText = map['mainText'];
    String status = map['status'];

    DateTime date = DateTime.fromMillisecondsSinceEpoch(map['timeStamp']);  

    return PostData(null,location,accounts,translate,startStrings,mainText,endStrings,status, time: date,uid: uid,photoDecoded: photoUint);
  }

  static List<String> getStrings (List<dynamic> encodedStrs){
    return encodedStrs.map((str){
       return str.toString();
    }).toList();
  }

  static List<AccountData> returnAccounts(List<dynamic> encodedAcc){
    return encodedAcc.map((acc){
       return AccountData.newAccFromJson(jsonDecode(acc),update: false);
    }).toList();
  }

  //  constructor
  PostData(this._photo,this._location,this._accs,this._translate,this._startStr,this._mainText,this._endStr,this._status,{DateTime time, String uid, Uint8List photoDecoded}){
    //creationTime
    this._uid = uid??Uuid().v1();
    this._timeStamp = time??DateTime.now();

    if(photoDecoded!=null){
      this._photoImageDecoded =photoDecoded;
    }

    this._accsImgs = [];
    this._socialsImgs = [];
    this._accs.forEach((acc){
        //settinng accs imgs
        this._accsImgs.add(acc.getImg());
        //setting accs socials
        String curSoc = acc.getSocialUrl();
        if(!this._socialsImgs.contains(curSoc)){
          this._socialsImgs.add(curSoc);
        }
      });
  }

  //getters
  String getDescription(){
    return _prepareText(_accs[0]);
  }
  dynamic getPhoto(){
    return _photo??_photoImageDecoded;
  }
  List<String> getSocials(){
    return _socialsImgs;
  }
  List<String> getAccsImgs(){
    return _accsImgs;
  }
  String getUid(){
    return _uid;
  }
  DateTime getTimeStamp(){
    return _timeStamp;
  }
  void setTimeStamp(DateTime time){
    _timeStamp = time;
  }
  String getStatus(){
    return _status;
  }
  void setStatus(String status){
    _status = status;
  }


  String _prepareText(acc){
    String _startText = "";
    String soc = acc.getSocial();
    if(_startStr!=null)
      _startStr.forEach((str){
        if(str.socials.contains(soc) || str.accounts.contains(acc) || (str.socials.isEmpty && str.accounts.isEmpty))
          _startText += str.str;
      });

    String _endText = "";
    if(_endStr != null)
      _endStr.forEach((str){
        if(str.socials.contains(soc) || str.accounts.contains(acc) || (str.socials.isEmpty && str.accounts.isEmpty))
          _endText += str.str;
      });
    
    String _postmainText = "";
    _postmainText = _startText + _mainText +_endText;
    return _postmainText;
  }

  postApost()async{
    String photoBytes = _photo != null?base64Encode(_photo.readAsBytesSync()):_photoImageDecoded.toList();
    String locId = _location != null?_location['id'].toString():'';
    for(var acc in _accs){
      Map<String,dynamic> body ={
        'uidPost': _uid.toString(),
        'uid': acc.getID(),
        'text': _prepareText(acc),
        'trans': _translate?'true':'false',
        'lang': acc.getLang().toString(),
        'loc': locId.toString(),
        'photo': photoBytes,
        'social':acc.getSocial().toString(),
        'width': 500.toString(), //SIZE MUST BE SET
        'height': 500.toString(),//SIZE MUST BE SET
        'status': _accs.indexOf(acc)!=_accs.length-1? "working" : "finished"
      };

      http.Response resp = await http.post(Globals.url+'/post',body: body);
      if(resp.statusCode==200){
        if(resp.body == 'Success')
          print(acc.getNick()+'    Success');
        else{
          print(acc.getNick()+'    Failure Program Part: '+resp.body.toString());
        }
      }else{
        print(acc.getNick()+'    Failure Code');
      }

    }
    
  }

}