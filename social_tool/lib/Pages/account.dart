import "package:flutter/material.dart";


class AccountPage extends StatelessWidget {

  final Color _interfaceCol = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Account Info"), backgroundColor: _interfaceCol ,),
      body: Container(
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