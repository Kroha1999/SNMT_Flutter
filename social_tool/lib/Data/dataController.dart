import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:social_tool/Accounts/accountData.dart";
import 'package:social_tool/Data/customWidgetsPostMake.dart';
import 'package:social_tool/MainPage/accounts_tab.dart';
import 'package:social_tool/MainPage/posts_tab.dart';

import 'globalVals.dart';

class DataController{


  //
  static String chosenlang;
  static List<String> accountsStrings = []; // key: uid - represents curent accounts
  static List<AccountData> accountsDataInstances = [];
  static List<AccountListEl> accounts = [/*AccountListEl("Zorik","zik","Instagram",'English','12351234123',imageurl: Globals.standartImg,)*/];
  
  static List<PostListEl> posts = [PostListEl(
            description: Globals.textExample,
            imgUrl: Globals.imgExample,
            status: "Completed",
            socials: [Globals.faceImg,Globals.instImg,Globals.twitImg],
            accs: DataController.accountsDataInstances.map((acc){return acc.getImg();}).toList(), 
            timeStamp: DateTime.now(),
          ),];
  

  //static List<AdditionalString> startsStringsData = [];
  //static List<AdditionalString> endStringsData = [];
  static List<List<AdditionalString>> aditionalStringsData = [[],[]];//[startsStringsData,endStringsData];//0-startTexts//1-endTexts
  
  //parametrs for creation of the additional string in the POSTMAKE alert
  static int addStringId = 0; //0 - for all posts, 1- cust for socials, 2 - for cust accounts
  static String addLineText = '';
  static List<AccountData> accsChosen = [];
  static List<String> socialsChosen = [];
  static Map<String, dynamic> chosenLocation;

  static void defaultAddString(){
    DataController.addStringId=0;
    DataController.addLineText='';
    DataController.accsChosen = [];
    DataController.socialsChosen = [];
  }
  

  //Preview of the account
  static File lastCroppedPhoto;
  static AccountData previewAcc;
  static String mainText;



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
  static void saveAccountsInstanses({AccountData accToReplace}) async {
    //Changing Data instance in local memory
    if(accToReplace!=null){
      DataController.accountsDataInstances.forEach((acc){
        if(acc.getID() == accToReplace.getID()){
          acc = accToReplace;
          return;
        }
      });
    }
    
    
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

  static void removeAccount(context,{String elementUID})
  {
    if(elementUID == null || elementUID == ""){
      elementUID = DataController.lastUid;
    }
    // As this function can be called only from the account
    // We can use 'last' variables to delete right account 
    var remEl;
    //remove from STRINGS
    DataController.accountsStrings.forEach((encStr){
      //decrypting of encrypted string
      var jsonStr = jsonDecode(encStr);
      if(jsonStr['uid'] == elementUID)
      {
        remEl = encStr;
        print("ACCOUNT STRING INSTANCE REMOVED");
        return;
      }
    });
    DataController.accountsStrings.remove(remEl);

    //REMOVE FROM DATA
    DataController.accountsDataInstances.forEach((acc){
      if(acc.getID() == elementUID){
        print("ACCOUNT DATA INSTANCE REMOVED");
        remEl = acc;
        return;
      }
    });
    DataController.accountsDataInstances.remove(remEl);
    //REMOVE SAVED INSTANCE IN THE WEB
    remEl.removeAccount();

    //REMOVE FROM VIEW
    DataController.accounts.forEach((acc){
      if(acc.getID() == elementUID){
        print("ACCOUNT DATA VIEW REMOVED");
        remEl = acc;
        return;
      }
    });
    DataController.accounts.remove(remEl);
    
    // SAVING INSTANCES LOCALLY
    DataController.saveAccountsInstanses();    
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
  static AccountData lastAccInstance;

  
  static void getClickedAccount(String nick,String fullName,String uid, String imgUrl, grad){
    DataController.lastAccName = fullName;
    DataController.lastAccNick = nick;
    DataController.lastUid = uid;
    DataController.lastImgUrl = imgUrl;
    DataController.lastGrad = grad;
    DataController.accountsDataInstances.forEach((acc){
      if(acc.getID() == uid){
        DataController.lastAccInstance = acc;
        return;
      }
    });
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