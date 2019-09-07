import 'dart:convert';

import "package:flutter/material.dart";
import 'package:social_tool/Accounts/accountData.dart';
import 'package:social_tool/Data/globalVals.dart';
import 'package:http/http.dart' as http;
import 'package:social_tool/Data/dataController.dart';


class MyLocs extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose Location",style: TextStyle(color: Globals.secondInterfaceCol),),iconTheme: IconThemeData(color: Globals.secondInterfaceCol), backgroundColor:  Globals.interfaceCol ,),
      body: Container(
        color: Globals.backgroundCol,
        child: Center(
          child: LocationChooser()
        ),
      ),
    );
  }
}




class LocationChooser extends StatefulWidget {
  @override
  _LocationChooserState createState() => _LocationChooserState();
}

class _LocationChooserState extends State<LocationChooser> {

  
  List<Widget> _locationsView = [];

  Future<List<dynamic>> onChangedTextLocation(String text) async {
    if(text.length>1){
      List<dynamic> _locations;
      String uid = randInstaAcc();
      http.Response resp = await http.get(Globals.url+'/location/$uid/$text');
      
      if(resp.statusCode == 200)
        _locations = jsonDecode(resp.body);
        return _locations;
    }
    return [];
  }

  void changeView(String text)async{
    List<dynamic> _locations = await onChangedTextLocation(text);
    _locationsView = [];
    

    _locations.forEach((acc){
      _locationsView.add(GestureDetector(
        onTap: (){
          DataController.chosenLocation = acc;
          Navigator.pop(context);
        },
        child: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Globals.interfaceCol
            
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(acc['title'],style: TextStyle(color: Colors.black),),
              Text(acc['name'],style: TextStyle(color: Colors.grey),),
              Row(children: <Widget>[
                Text(acc['location']['lng'].toString()+",   ",style: TextStyle(color: Colors.grey),),
                Text(acc['location']['lat'].toString(),style: TextStyle(color: Colors.grey),),
              ],)
            ],
          ),
        ),
      ));
    });
    setState(() {
    });
    
  }

  String randInstaAcc(){
    String randAcUid;
    DataController.accountsDataInstances.forEach((acc){
      if (acc.getSocial()=='Instagram'){
        randAcUid = acc.getID();
      }
    });
    return randAcUid;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.location_on,color: Colors.black,),
                    hintText: "Location",
                  ),
                  onChanged: (String text){
                    changeView(text);
                  
                    },
                  maxLines: 1,
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.grey[300],
                  child: ListView(
                    children: _locationsView,
                  ),
                ),
              )
            ],
          ),      
    );
  }
}