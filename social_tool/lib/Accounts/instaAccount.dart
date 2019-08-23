import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:social_tool/accounts_tab.dart';
import 'dart:async';

String url = "http://10.0.3.2:5000";


class InstaAcccount{
  String _nickName;
  String _fullName;
  String _imgUrl;
  Map<String, dynamic> userInfo;

  void getUser(nick,password) async {
    print("BLALBALBLALBAL");
    await http.get(url+"/instagram/login/"+nick+"/"+password).then(_processResponce);
  }
  
  void _processResponce(http.Response response)  {
    print("RESP: "+response.statusCode.toString());
    if (response.statusCode == 200){
      
      this.userInfo =jsonDecode(response.body);
      this._nickName = this.userInfo['nickName'];
      this._fullName = this.userInfo['fullName'];
      this._imgUrl = this.userInfo['imgUrl'];
      AccountsListViewState.accounts.add(AccountListEl(this._fullName,this._nickName,'Twitter','SC',imageurl: this._imgUrl,));
      print(userInfo['imgUrl']);
    }
    else{
      print("ERROR: "+response.statusCode.toString()+": ERROR");
    }

  }
  void selfUpdate(){}
  void postAPhoto(){}

}