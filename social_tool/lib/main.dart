// THIS PAGE INITIALIZE ROUTES FOR THE APP

import 'package:flutter/material.dart';

//Splash screen
import 'SplashScreen/splashScreen.dart';
//Main screen
import 'package:social_tool/MainPage/mainScreen.dart';


//Pages
import 'package:social_tool/Pages/account.dart' as myAcc;
import 'package:social_tool/Pages/addAccount.dart' as addAcc;
import 'package:social_tool/Pages/makePost.dart' as makePost;
import 'package:social_tool/Pages/post.dart' as myPost;
import 'package:social_tool/Pages/mySettings.dart' as mySet;
import 'package:social_tool/Pages/location.dart' as myLocs;
import 'package:social_tool/Pages/previewPost.dart' as myPrev;


void main() => runApp(MyApp());

//App creation
class MyApp extends StatelessWidget{
  
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Flutter SNMT',
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        "/home": (BuildContext context) => Home(),
        "/accountPage": (BuildContext context) => myAcc.AccountPage(),
        "/addAccountPage": (BuildContext context) => addAcc.AddAccountPage(),
        "/makePost": (BuildContext context) => makePost.MakePost(),
        "/myPost": (BuildContext context) => myPost.MyPost(),
        "/settings": (BuildContext context) => mySet.MySettings(),
        "/makePost/locations": (BuildContext context) => myLocs.MyLocs(),
        "/makePost/Preview": (BuildContext context) => myPrev.MyPrev(),
      },
    );
  }
}

