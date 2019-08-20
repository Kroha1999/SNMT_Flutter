import 'package:flutter/material.dart';

class AccountsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(children: <Widget>[
          Text('Accounts'),
          Padding(padding: EdgeInsets.all(20),),
          Icon(Icons.supervised_user_circle, size: 90,)
        ],),
      ),
      
    );
  }
}