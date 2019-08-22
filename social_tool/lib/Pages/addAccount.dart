import "package:flutter/material.dart";


class AddAccountPage extends StatelessWidget {

  final Color _interfaceCol = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Account"), backgroundColor: _interfaceCol ,),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.person_add, color: Colors.orange,),
                iconSize: 100.0,
                onPressed: null,
              ),
              Text("Add Account"),
            ],
          ),
        ),
      ),
    );
  }
}