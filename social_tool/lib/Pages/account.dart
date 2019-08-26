import "package:flutter/material.dart";
import 'package:social_tool/Data/globalVals.dart';


class AccountPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Account Info",style: TextStyle(color: Globals.secondInterfaceCol),),iconTheme: IconThemeData(color: Globals.secondInterfaceCol), backgroundColor:  Globals.interfaceCol,),
      body: Container(
        color: Globals.backgroundCol,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.account_circle, color: Colors.green,),
                iconSize: 100.0,
                onPressed: null,
              ),
              Text("My Account"),
            ],
          ),
        ),
      ),
    );
  }
}