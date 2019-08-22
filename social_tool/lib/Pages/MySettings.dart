import "package:flutter/material.dart";


class MySettings extends StatelessWidget {

  final Color _interfaceCol = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings"), backgroundColor: _interfaceCol ,),
      body: Container(
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