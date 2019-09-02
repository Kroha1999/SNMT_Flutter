import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:social_tool/Accounts/accountData.dart';
import 'package:social_tool/Data/customWidgets.dart';
import 'package:social_tool/Data/dataController.dart';
import 'package:social_tool/Data/globalVals.dart';



//Croping function
Future<File> cropImage(File imagefile) async {
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


//Class with additional text string
class AdditionalString{
  int typeOfAddString; // 0 - add for all accounts, 1 - for custom socials 2 -for custom accounts
  String str;
  List<String> socials;
  List<AccountData> accounts;
  AdditionalString(this.typeOfAddString,this.str, this.socials, this.accounts);
}


Widget textButton({double height = 25, func, int position = 0,
                    Color btnColor =  Colors.black, Color textColor = Colors.white,
                    String text = "+ add custom start text",index})
{
  List<MaterialColor> cols = [Colors.red,Colors.amber,Colors.blue,Colors.brown,Colors.indigo,Colors.orange];
  if(btnColor == null){
    Random random = Random();
    btnColor = cols[random.nextInt(cols.length)];
  }
  List<String >imgs = [];
  if(index!=null){
    if(DataController.aditionalStringsData[position][index].typeOfAddString == 1){
      if(DataController.aditionalStringsData[position][index].socials.contains("Instagram"))
        imgs.add(Globals.instImg);
      if(DataController.aditionalStringsData[position][index].socials.contains("Facebook"))
        imgs.add(Globals.faceImg);
      if(DataController.aditionalStringsData[position][index].socials.contains("Twitter"))
        imgs.add(Globals.twitImg);
    }else if(DataController.aditionalStringsData[position][index].typeOfAddString == 2){
      imgs = DataController.aditionalStringsData[position][index].accounts.map((acc){return acc.getImg().toString();}).toList();
    }
  }

  return Container(
      height: 25,
      margin: EdgeInsets.all(2),
      child: FlatButton(
        color: btnColor,
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              circleImagesRow(
                maxVisible: 2,
                borderColor: Colors.white,
                imgs: imgs,
                iconColor: Colors.white,
                offset: -21,
              ),
              Expanded(child: Text(text,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16),)),
            ],
          )
        ),
        onPressed: (){func(position,index);},
        textColor: textColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),       
    ));
}

Future<bool> deleteDialog(BuildContext context,String text) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Warning'),
        content: Text(text),
        actions: <Widget>[
          FlatButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: const Text('Delete',style: TextStyle(color: Colors.red),),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}

//Alert after Alert
warningDialog(BuildContext context,String text){
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Warning'),
        content: Text(text),
        actions: <Widget>[
          FlatButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}






checkIfPossibleToAdd(){
  if(DataController.addStringId == 1){
    if(DataController.socialsChosen.isEmpty)
      return [false,"You need to choose social network or networks for which this first line will be added"];
  }else if (DataController.addStringId == 2){
    if(DataController.accsChosen.isEmpty)
      return [false,"You need to choose account or accounts for which this first line will be added"];
  }
  if(DataController.addLineText.split(" ").join("") == ""){
    return [false,"You need to enter the text in order to add the line"];
  }
  return [true,"Success"];
}

class ChooseAddStringOption extends StatefulWidget {
  final List<AccountData> accounts;
  final int index;
  ChooseAddStringOption(this.accounts,this.index);

  @override
  _ChooseAddStringOptionState createState() => _ChooseAddStringOptionState();
}

class _ChooseAddStringOptionState extends State<ChooseAddStringOption> {
  
  void initViewForAlert(){
    setState(() {
      //if we need to restore data      
      if(widget.index!=null){
        
        //By default it is true - as we restoring values let's make it false
        _allAccs = false;
        //restoring type of add string
        if(DataController.addStringId == 0)
          _allAccs = true;   

        else if(DataController.addStringId == 1){
            _chooseSocials = true;
            //restoring socials
            DataController.socialsChosen.forEach((el){
            if(el == "Instagram")
              _instaCheck = true;
            else if (el == "Twitter")
              _twitCheck = true;
            else if (el == "Facebook")
              _faceCheck = true;
            });
          }

        else if(DataController.addStringId == 2){
          _chooseAccs = true;
          //restoring accounts
          widget.accounts.forEach((acc){
            if(DataController.accsChosen.contains(acc))
              _checkBoxes.add(true);
            else
              _checkBoxes.add(false);
          });
        }

      }
    }); 
  }
  
  @override
  initState(){
    initViewForAlert();
    super.initState();
  }
  
  
  bool _allAccs = true;         //id = 0
  bool _chooseSocials =  false; //id = 1
  bool _chooseAccs =  false;    //id = 2
  
  void _changeState(int id){
    setState(() {
      _allAccs = false;
      _chooseSocials=false;
      _chooseAccs = false;
     if(id==2){
       DataController.addStringId = 2;
       _chooseAccs = true;
     } else if(id == 1){
       DataController.addStringId = 1;
       _chooseSocials = true;
     }
     else{
       DataController.addStringId = 0;
       _allAccs = true;
     }
    });  
  }
  
  bool _instaCheck = false;//id = 0
  bool _twitCheck = false;//id = 1
  bool _faceCheck = false;//id = 2
  //controller for checkboxes
  void _choseSocials(bool value,int id){
    setState(() {
     
    if(id == 0){
      _instaCheck = value;
      DataController.socialsChosen.contains("Instagram")
        ?DataController.socialsChosen.remove("Instagram")
        :DataController.socialsChosen.add("Instagram");
    }else if(id == 1){
      _twitCheck = value;
      DataController.socialsChosen.contains("Twitter")
        ?DataController.socialsChosen.remove("Twitter")
        :DataController.socialsChosen.add("Twitter");
    }
    else{
      _faceCheck= value;
      DataController.socialsChosen.contains("Facebook")
        ?DataController.socialsChosen.remove("Facebook")
        :DataController.socialsChosen.add("Facebook");
      
    } 
    });
    print(DataController.socialsChosen);
  }

  //SOCIALS VIEW - User can choose social network
  Widget _chooseSocialsWidget(){
    return Container(
      child:Column(children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("1.Instagram"),
              Container(
                width:MediaQuery.of(context).size.width-214,
                alignment: Alignment.centerRight,
                child: Checkbox(
                  checkColor: Colors.red,
                  activeColor: Colors.white,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: _instaCheck,
                  onChanged: (bool value){_choseSocials(value,0);},
              ))
          ],),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("2.Twitter"),
              Container(
                width:MediaQuery.of(context).size.width-190,
                alignment: Alignment.centerRight,
                child: Checkbox(
                  checkColor: Colors.red,
                  activeColor: Colors.white,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: _twitCheck,
                  onChanged: (bool value){_choseSocials(value,1);},
              ))
          ],),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("3.Facebook"),
              Container(
                width:MediaQuery.of(context).size.width-210,
                alignment: Alignment.centerRight,
                child: Checkbox(
                  checkColor: Colors.red,
                  activeColor: Colors.white,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: _faceCheck,
                  onChanged: (bool value){_choseSocials(value,2);},
              ))
          ],),
        ),
        Divider(color: Colors.black,height: 8,)
        
      ])
     );
  }
  
  List<bool> _checkBoxes = [];

  //
  _setAddStringAccounts(List<AccountData> accounts){
    if(accounts.length != _checkBoxes.length)
    {
      print("Accounts Length = " + accounts.length.toString() + " Checkboxes length = " + _checkBoxes.length.toString());
      return;
    }
    DataController.accsChosen=[];
    _checkBoxes.asMap().forEach((index, ch){
      if(ch)
      {
        DataController.accsChosen.add(accounts[index]);
      }
    });
    print(DataController.accsChosen.map((acc){return acc.getNick();}).toList());
  }

  //CHOOSE ACCOUNTS VIEW
  Widget _chooseAccsWidget(List<AccountData> accounts){
    
    return Container(
      //margin: EdgeInsets.fromLTRB(15, 15, 15, 60),
      width: 240,
      height: 127,
      child: ListView(
        
        children: accounts.map((acc){
          if(_checkBoxes.length!=accounts.length)
            _checkBoxes.add(false);
          return GestureDetector(
            onTap: (){
              setState(() {
                _checkBoxes[accounts.indexOf(acc)] = !_checkBoxes[accounts.indexOf(acc)];
                _setAddStringAccounts(accounts);
              });
            },
            child: Container(
              //margin: EdgeInsets.all(4),
              color: Colors.transparent,
              child: Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    accAndSocialView(size: 30,borderWidth: 0.8,borderColor: Colors.black ,socImageUrl: acc.getSocialUrl(), imageUrl: acc.getImg()),
                    Container(
                      width: 142,
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
                        value: _checkBoxes[accounts.indexOf(acc)],
                        checkColor: Colors.red,
                        activeColor: Colors.white,
                        onChanged: (bool value){
                          setState(() {
                          _checkBoxes[accounts.indexOf(acc)] = value; 
                          _setAddStringAccounts(accounts);
                          });
                        },
                      ),
                    ),
                  ],),
                  //Divider(color: Colors.black, height: 16,indent: 6, endIndent: 10,) //Or can be without divider
                ],
              ),
            ),
          );
        }).toList()
      ),
    );
  }

  //MAIN BUILD FUNC
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Column(children: <Widget>[
        Container(
          height: 20,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("1.All accounts"),
              Container(
                width:MediaQuery.of(context).size.width-230,
                alignment: Alignment.centerRight,
                child: Checkbox(
                  checkColor: Colors.black,
                  activeColor: Colors.white,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: _allAccs,
                  onChanged: (bool value){_changeState(0);},
              ))
          ],),
        ),
        Container(
          height: 30,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("2.Custom Social Networks"),
              Container(
                width:MediaQuery.of(context).size.width-230-87,
                alignment: Alignment.centerRight,
                child: Checkbox(
                  checkColor: Colors.black,
                  activeColor: Colors.white,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: _chooseSocials,
                  onChanged: (bool value){_changeState(1);},
              ))
          ],),
        ),
        Container(
          height: 20,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("3.Custom Accounts"),
              Container(
                width:MediaQuery.of(context).size.width-230-39,
                alignment: Alignment.centerRight,
                child: Checkbox(
                  checkColor: Colors.black,
                  activeColor: Colors.white,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: _chooseAccs,
                  onChanged: (bool value){_changeState(2);},
              ))
          ],),
        ),
        Divider(color: Colors.black,height: 10,),
        _allAccs ? Container()
                 : (_chooseSocials ? _chooseSocialsWidget() : _chooseAccsWidget(widget.accounts)) 
      ],)
      
    );
  }
}


