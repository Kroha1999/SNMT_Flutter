import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:social_tool/Accounts/instaAccount.dart";
import 'package:social_tool/accounts_tab.dart';

class DataController{
  
  static String lang;
  static List<String> accountsKeys = []; // key: uid - represents curent accounts
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
    DataController.accountsKeys.forEach((f)=>print(f));
    pref.setStringList("accounts", DataController.accountsKeys);
  }

  //Get Account from local memory and assighn View
  static void getAccounts() async {
    var pref =  await SharedPreferences.getInstance();
    //pref.remove("accounts");  //Cleaning account FOR TESTING
    var keysFromStorage = pref.getStringList("accounts");
    
    //check if empty
    if (keysFromStorage == null)
    {
      print("NULL");
      DataController.saveAccountsInstanses(); 
      return;
    }

    print("STORED: $keysFromStorage,");
    var k = DataController.accountsKeys;
    print("Cached: $k,");
    //Comparing Stored Data and that which we can see on the screen
    keysFromStorage.forEach((uid){
      if(!DataController.accountsKeys.contains(uid)){
        print(uid);
        DataController.accountsKeys.add(uid);
        var soc = uid.substring(0,4);
        //looking for type of social in order to work with proper account
        var social = (soc == 'inst') ? 'Instagram': ((soc == 'twit') ? 'Twitter': "Facebook");
        var acc = AccountData("Instagram");
        acc.reAuth(uid); 
      }
    });
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