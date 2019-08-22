import "package:flutter/material.dart";


class MyPost extends StatelessWidget {

  final Color _interfaceCol = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Post"), backgroundColor: _interfaceCol ,),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.local_see, color: Colors.tealAccent,),
                iconSize: 100.0,
                onPressed: null,
              ),
              Text("My Post"),
            ],
          ),
        ),
      ),
    );
  }
}