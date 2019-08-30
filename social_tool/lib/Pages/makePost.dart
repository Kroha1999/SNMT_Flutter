import 'dart:io';

import "package:flutter/material.dart";
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:social_tool/Accounts/accountData.dart';
import 'package:social_tool/Data/customWidgets.dart';
import 'package:social_tool/Data/dataController.dart';
import 'package:social_tool/Data/globalVals.dart';
import 'package:image_picker/image_picker.dart';


class MakePost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Make a Post",style: TextStyle(color: Globals.secondInterfaceCol),),iconTheme: IconThemeData(color: Globals.secondInterfaceCol), backgroundColor:  Globals.interfaceCol ,),
      body: Container(
        color: Globals.backgroundCol,
        child: Center(
          child: ChooseAccs(),
        ),
      ),
    );
  }
}


//Choose accounts form
class ChooseAccs extends StatefulWidget {
  @override
  _ChooseAccsState createState() => _ChooseAccsState();
}

class _ChooseAccsState extends State<ChooseAccs> {
  
  List<bool> _checkBoxes = [];
  
  void _toogleButton(){
    bool val = false;
    _checkBoxes.forEach((ch){
      if(ch)val=ch;
    });
    setState(() {
     _isButtonDisabled=!val;
    });
  }

  void _continueBtnClick(){
    setState(() {
      _checkBoxes.asMap().forEach((index,value){
        if(value){
          _accounts.add(DataController.accountsDataInstances[index]);
        }
      _accsChosen = true;
      });
    });
  }

  bool _isButtonDisabled = true;
  bool _accsChosen = false;
  
  List<AccountData> _accounts = [];


  Widget chooseAccounts(){
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          border: Border.all(width: 1,color: Colors.black),
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0)
        ),
        child: Stack(children: <Widget>[
          Positioned(
            child: Container(
              margin: EdgeInsets.fromLTRB(15, 15, 15, 60),
              child: ListView(
                
                children: DataController.accountsDataInstances.map((acc){
                  if(_checkBoxes.length!=DataController.accountsDataInstances.length)
                    _checkBoxes.add(false);
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        _checkBoxes[DataController.accountsDataInstances.indexOf(acc)] = !_checkBoxes[DataController.accountsDataInstances.indexOf(acc)];
                        _toogleButton();
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(4),
                      color: Colors.transparent,
                      child: Column(
                        children: <Widget>[
                          Row(children: <Widget>[
                            accAndSocialView(size: 60,borderWidth: 0.8,borderColor: Colors.black ,socImageUrl: acc.getSocialUrl(), imageUrl: acc.getImg()),
                            Container(
                              width: 170,
                              margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                Text(acc.fullName()),
                                Text(acc.getNick()),
                              ],),
                            ),
                            Container(
                              child: Checkbox(
                                value: _checkBoxes[DataController.accountsDataInstances.indexOf(acc)],
                                checkColor: Colors.black,
                                activeColor: Colors.white,
                                onChanged: (bool value){
                                  setState(() {
                                  _checkBoxes[DataController.accountsDataInstances.indexOf(acc)] = value; 
                                  _toogleButton();
                                  });
                                },
                              ),
                            ),
                          ],),
                          Divider(color: Colors.black, height: 16,indent: 6, endIndent: 10,) //Or can be without divider
                        ],
                      ),
                    ),
                  );
                }).toList()
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            left: 70,
            right: 70,
            child: FlatButton(
              color: Globals.secondInterfaceCol,
              textColor: Globals.interfaceCol,
              child: Text(_isButtonDisabled ? 'Choose at least 1 account' : "continue"),
              onPressed: _isButtonDisabled ? null : _continueBtnClick,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
            ),
          ),

        
        ],),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return _accsChosen 
            ? MakePostBody(_accounts)
            : chooseAccounts();
  }
}




class MakePostBody extends StatefulWidget {
  final List<AccountData> chosenAccs;

  MakePostBody(this.chosenAccs);

  @override
  _MakePostBodyState createState() => _MakePostBodyState();
}

class _MakePostBodyState extends State<MakePostBody> {
  
  //---------------------------------------------------------------Checkboxes
  //Checkbox bools
  List<bool> _isChecked = [true,false];  // photo = 0  lang = 1
  
  //Checkbox Check function
  void onChecked(int id,bool value)
  {
    setState(() {
      _isChecked[id] = value; 
    });
  }
  
  //---------------------------------------------------------------Image
  //ImageFile
  File _imageFile;

  //Function to get image
  Future _getImage(source) async {
    File image = await ImagePicker.pickImage(source: source);
    File cropped = await _cropImage(image);
    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  //Croping function
  Future<File> _cropImage(File imagefile) async {
    if(imagefile!=null){
      File cropped = await ImageCropper.cropImage(
        sourcePath: imagefile.path,
        ratioX: 1.0,
        ratioY: 1.0,
        maxWidth: 512,
        maxHeight: 512,
        toolbarColor: Globals.interfaceCol,
        toolbarWidgetColor: Globals.secondInterfaceCol,
        toolbarTitle: "Crop Wise"
      );
      return cropped;
    }
    return null;
  }

  //Choose photoView if checked
  Widget choosePhotoWidget(){
    if(_isChecked[0]){
      return Column(children: <Widget>[
        GestureDetector(
          child: _imageFile == null
            //If image file is not chosen
            ? Container(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.add_a_photo),onPressed: (){_getImage(ImageSource.camera);} ,),
                        Text("Make a photo")
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.add_photo_alternate),onPressed: (){_getImage(ImageSource.gallery);} ,),
                        Text("Choose from galery")
                      ],
                    ),
                  )
                ],),
            )   
            //If image file is chosen
            : Container(
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: IconButton(icon: Icon(Icons.add_a_photo,color: Colors.white),onPressed: (){_getImage(ImageSource.camera);} ,),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: IconButton(icon: Icon(Icons.add_photo_alternate,color: Colors.white,),onPressed: (){_getImage(ImageSource.gallery);} ,),                     
                      )
                    ],),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.file(_imageFile).image,
                    fit: BoxFit.cover
                  )
                ),
            )    
        ),
        
        Divider(color: Globals.secondInterfaceCol, height: 5,),
      ],);
    }
    else return Container();
  }
  
  //---------------------------------------------------------------StartText
  List<String> startTexts = [];

  Widget addStartText(){
    return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      FlatButton(
        color: Colors.green,
        child: Text("+ add custom start text"),
        onPressed: (){},
        textColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),       
      ),
    ],);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(children: <Widget>[
            Text("Add photo:"),
            Checkbox(checkColor: Colors.black,activeColor: Colors.white,value: _isChecked[0], onChanged: (bool value){onChecked(0,value);},),
            Text("Translate:"),
            Checkbox(checkColor: Colors.black,activeColor: Colors.white,value: _isChecked[1], onChanged: (bool value){onChecked(1,value);},),
            Container(
                  //ACCOUNTS IMAGES
                  child: cirleImagesRow(
                    contHeight: 30,
                    size: 30,
                    maxVisible: 5,
                    imgs: widget.chosenAccs.map((acc){
                      return acc.getImg();
                      }).toList(),
                    offset: 50
                    ),
                  
                ),
          ],),
        ),
        Divider(color: Globals.secondInterfaceCol, height: 5,),
        choosePhotoWidget(),
        addStartText(),
        Divider(color: Globals.secondInterfaceCol, height: 5,),



      ],)
    );
  }
}

class startString{
  final String str;
  final List<String> socials;
  final List<AccountData> accounts;
  startString(this.str, this.socials, this.accounts);
}