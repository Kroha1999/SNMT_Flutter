import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:social_tool/Accounts/instaAccount.dart";
import 'package:social_tool/MainPage/accounts_tab.dart';

import 'globalVals.dart';

class DataController{
  
  static String chosenlang;
  static List<String> accountsStrings = []; // key: uid - represents curent accounts
  static List<AccountData> accountsDataInstances = [];
  static List<AccountListEl> accounts = [AccountListEl("Zoriana Bighun","@zorik","Instagram","EN",'12345678',imageurl: "https://bit.ly/2MunTk6",)];

  //static List<AccountListEl> accountsViewInstances = [];

  static void showMessage(var context,String text){
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(text),
      elevation: 10,
      backgroundColor: Colors.indigoAccent,
      duration: Duration(seconds: 1),
    ));
  }

  //---------------------------DATA---------------------------------------
  //LOCAL DATA Save accounts uids to local memory
  static void saveAccountsInstanses() async {
    var pref =  await SharedPreferences.getInstance();
    List<String> stringAccs = [];
    
    DataController.accountsDataInstances.forEach((acc){
      var accstr = jsonEncode(acc);
      print(accstr);
      DataController.accountsStrings.add(accstr);
      stringAccs.add(accstr);
    });

    pref.setStringList("accountsInstances", stringAccs);
  }

  //LOCAL DATA Get Account from local memory to accountsDataInstances and assighn View (with update params)
  static void getAccounts() async {
    var pref =  await SharedPreferences.getInstance();
    //pref.remove("accountsInstances");  //Cleaning account FOR TESTING
    var accsFromStorage = pref.getStringList("accountsInstances");
    
    if (accsFromStorage == null)
    {
      print("NULL");
      DataController.saveAccountsInstanses(); 
      return;
    }

    //print("STORED: $accsFromStorage,");
    //var showedStrings = DataController.accountsStrings ;
    //print("Cached: $showedStrings,");

    accsFromStorage.forEach((accData){
      if(!DataController.accountsStrings.contains(accData)){
        print(accData);
        DataController.accountsStrings.add(accData);
        var accDataEncoded = jsonDecode(accData);
        var restoredAcc = AccountData.newAccFromJson(accDataEncoded);
        DataController.accountsDataInstances.add(restoredAcc);
      }
    });
  }

  static void removeAccount(context)
  {
    // As this function can be called only from the account
    // We can use 'last' variables to delete right account 
    var remEl;
    //remove from STRINGS
    DataController.accountsStrings.forEach((encStr){
      //decrypting of encrypted string
      var jsonStr = jsonDecode(encStr);
      if(jsonStr['uid'] == DataController.lastUid)
      {
        remEl = encStr;
        print("ACCOUNT STRING INSTANCE REMOVED");
        return;
      }
    });
    DataController.accountsStrings.remove(remEl);

    //REMOVE FROM DATA
    DataController.accountsDataInstances.forEach((acc){
      if(acc.getID() == DataController.lastUid){
        print("ACCOUNT DATA INSTANCE REMOVED");
        remEl = acc;
        return;
      }
    });
    DataController.accounts.remove(remEl);
    DataController.accountsDataInstances.remove(remEl);

    //REMOVE FROM VIEW
    DataController.accounts.forEach((acc){
      if(acc.getID() == DataController.lastUid){
        print("ACCOUNT DATA VIEW REMOVED");
        remEl = acc;
        return;
      }
    });
    DataController.accounts.remove(remEl);
    //TODO: SAVE INSTANCES LOCALLY and GO TO MAIN SCREEN AFTER
    //TODO: REMOVE SAVED INSTANCE IN THE WEB

    Navigator.of(context).popAndPushNamed('/home');
  }

  //FOR LOG IN Check if this nick is logged into accounts
  static bool checkIfLogged(nick,soc){
    bool isSame = false;
    DataController.accountsDataInstances.forEach((acc){
      if(acc.getSocial() == soc && acc.getNick()==nick){
        isSame = true;
        return;
      }
    });
    return isSame;
  }

  // FOR SAVING LAST TOUCHED ACCOUNT HERO
  static String lastUid;
  static String lastImgUrl;
  static var lastGrad;
  static String lastSocImg;
  static String lastAccName;
  static String lastAccNick;
  
  static void getClickedAccount(String nick,String fullName,String uid, String imgUrl, grad){
    DataController.lastAccName = fullName;
    DataController.lastAccNick = nick;
    DataController.lastUid = uid;
    DataController.lastImgUrl = imgUrl;
    DataController.lastGrad = grad;
    DataController.lastSocImg = (lastGrad == Globals.instaGrad)? Globals.instImg:
              ((lastGrad == Globals.twitGrad) ? Globals.twitGrad:Globals.faceGrad);
  }


  //------------------------------VIEW---------------------------------------------
  //In Accounts tab
  static void createAccView(fullName,nickName,socialNetwork,lang,uid,imgUrl)
  {
    
    DataController.accounts.add(AccountListEl(
            fullName,
            nickName,
            socialNetwork,
            lang,
            uid,
            imageurl: imgUrl,
            ));

  }

}