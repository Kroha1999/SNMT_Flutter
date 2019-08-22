import "package:flutter/material.dart";


class MakePost extends StatelessWidget {

  final Color _interfaceCol = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Make a Post"), backgroundColor: _interfaceCol ,),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.local_post_office, color: Colors.red,),
                iconSize: 100.0,
                onPressed: null,
              ),
              Text("Make a Post"),
            ],
          ),
        ),
      ),
    );
  }
}