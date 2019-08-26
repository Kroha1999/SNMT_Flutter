import 'package:flutter/material.dart';
import 'package:social_tool/Data/globalVals.dart';

class PostsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Globals.backgroundCol,
      child: Center(
        child: Column(children: <Widget>[
          Text('Posts'),
          Padding(padding: EdgeInsets.all(20),),
          Icon(Icons.send, size: 90,)
        ],),
      ),
      
    );
  }
}