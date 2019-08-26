import "package:flutter/material.dart";
import 'package:social_tool/Data/globalVals.dart';


class MySettings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings",style: TextStyle(color: Globals.secondInterfaceCol),),iconTheme: IconThemeData(color: Globals.secondInterfaceCol), backgroundColor:  Globals.interfaceCol ,),
      body: Container(
        color: Globals.backgroundCol,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.settings_applications, color: Colors.grey,),
                iconSize: 100.0,
                onPressed: null,
              ),
              Text("Settings"),
            ],
          ),
        ),
      ),
    );
  }
}