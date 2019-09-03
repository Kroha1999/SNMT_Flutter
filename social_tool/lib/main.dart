// THIS PAGE INITIALIZE ROUTES FOR THE APP

import 'package:flutter/material.dart';

//Splash screen
import 'SplashScreen/splashScreen.dart';
//Main screen
import 'package:social_tool/MainPage/mainScreen.dart';


//Pages
import 'Pages/account.dart' as myAcc;
import 'Pages/addAccount.dart' as addAcc;
import 'Pages/makePost.dart' as makePost;
import 'Pages/post.dart' as myPost;
import 'Pages/mySettings.dart' as mySet;
import 'package:social_tool/Pages/location.dart' as myLocs;


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
      },
    );
  }
}

