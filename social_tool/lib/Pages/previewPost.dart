import 'dart:async';
import 'dart:io';

import "package:flutter/material.dart";
import 'package:social_tool/Data/dataController.dart';
import 'package:social_tool/Data/globalVals.dart';


class MyPrev extends StatelessWidget {
  File _photo;
  Map<String,dynamic> _location;

  
  void _initValues(){
    _photo = DataController.lastCroppedPhoto;
    _location = DataController.chosenLocation;
  }


  Widget buildView(context){
    
    _initValues();
    
    var photoWidget = Container();
    if(_photo != null)
      photoWidget = Container(
        height: 300,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Image.file(_photo).image,
                      fit: BoxFit.cover
                    )
                  ),
      );

    var locationWidget = Container();
    if(_location != null)
      locationWidget = Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          Text(_location['title'],style: TextStyle(color: Colors.black,fontSize: 16),),
          Text(_location['name'],style: TextStyle(color: Colors.grey,fontSize: 12),),
        ],),
      );



    return ListView(
      children: <Widget>[
      photoWidget,
      locationWidget,
      TextPart(),      

    ]);
  }

  @override
  Widget build(BuildContext context) {
    String _nick = DataController.previewAcc.getNick();
    return Scaffold(
      appBar: AppBar(title: Text("Preview for $_nick",overflow: TextOverflow.ellipsis,style: TextStyle(color: Globals.secondInterfaceCol),),iconTheme: IconThemeData(color: Globals.secondInterfaceCol), backgroundColor:  Globals.interfaceCol ,),
      body: Container(
        color: Globals.backgroundCol,
        child: Center(
          child: buildView(context)
        ),
      ),
    );
  }
 
}

class TextPart extends StatefulWidget {
  @override
  _TextPartState createState() => _TextPartState();
}

class _TextPartState extends State<TextPart> {

  String _startText = "";
  String _mainText = "";
  String _endText = "";

  void parseStarts() {
    _startText = "";
    String soc = DataController.previewAcc.getSocial();
    DataController.aditionalStringsData[0].forEach((str){
      if(str.socials.contains(soc) || str.accounts.contains(DataController.previewAcc) || (str.socials.isEmpty && str.accounts.isEmpty))
        _startText += str.str;
    });
  }

  void parseMain(){
    _mainText = "";
    _mainText = _startText + DataController.mainText +_endText;
  }

  void parseEnds(){
    _endText = "";
    String soc = DataController.previewAcc.getSocial();
    DataController.aditionalStringsData[1].forEach((str){
      if(str.socials.contains(soc) || str.accounts.contains(DataController.previewAcc) || (str.socials.isEmpty && str.accounts.isEmpty))
        _endText += str.str;
    });
  }

  void initText()async{
    parseStarts();
    parseEnds();
    parseMain();
  }

  void translate()async{
    if(DataController.translate){
      _mainText = await DataController.previewAcc.translate(_mainText);
      setState(() { });
      print("Main  "+_mainText);
    }
  }

  @override
  void initState() {
    initText();
    translate();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      alignment: Alignment.centerLeft,
      child: Text(_mainText),      
    );
  }
}