import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:social_tool/Accounts/instaAccount.dart";
import 'package:social_tool/MainPage/accounts_tab.dart';

class DataController{
  
  static String lang;
  static List<String> accountsStrings = []; // key: uid - represents curent accounts
  static List<AccountData> accountsDataInstances = [];
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
  //Save accounts uids to local memory
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

  //Get Account from local memory to accountsDataInstances and assighn View (with update params)
  static void getAccounts() async {
    var pref =  await SharedPreferences.getInstance();
    //pref.remove("accounts");  //Cleaning account FOR TESTING
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

  //Check if this nick is logged into accounts
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



  //------------------------------VIEW---------------------------------------------
  //In Accounts tab
  static void createAccView(fullName,nickName,socialNetwork,lang,imgUrl)
  {
    
    AccountsListViewState.accounts.add(AccountListEl(
            fullName,
            nickName,
            socialNetwork,
            lang,
            imageurl: imgUrl,
            ));

  }

}