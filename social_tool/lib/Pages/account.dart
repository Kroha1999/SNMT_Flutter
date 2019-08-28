import "package:flutter/material.dart";
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:social_tool/Data/dataController.dart';
import 'package:social_tool/Data/dataController.dart' as prefix0;
import 'package:social_tool/Data/globalVals.dart';

enum ConfirmAction { CANCEL, ACCEPT }
//DELETE ALERT WINDOW 
Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Account?'),
        content: const Text(
            'This action will delete your account, You can restore it by relogining.'),
        actions: <Widget>[
          FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          FlatButton(
            child: const Text('ACCEPT'),
            onPressed: () {
              //Deleting the account
              
              DataController.removeAccount(context);
              Navigator.of(context).popAndPushNamed('/home');
              //Navigator.of(context).pop(ConfirmAction.ACCEPT);
            },
          )
        ],
      );
    },
  );
}

class AccountPage extends StatelessWidget {

  void _deleteAccount(context){
    _asyncConfirmDialog(context);   
  }
  
  Widget deleteBar(context){
    return GestureDetector(
            onTap: (){
              _deleteAccount(context);
            },
            child: Container(
            padding: EdgeInsets.all(0.0),
            margin: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),//BorderRadius.circular(20.0),
              color: Colors.red
            ),
            child: Center(
              child: Icon(Icons.delete_forever, color:Colors.white,size: 30.0,),
            ),
        ),
    );
  }

  Widget upBar(context){
    //Because of different accounts may have different values
    if(DataController.lastGrad == Globals.instaGrad){
      return Container(
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),//BorderRadius.circular(20.0),
          color: Globals.interfaceCol
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
          SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Text("Followers",style: TextStyle(color: Colors.black,fontSize: 12),),
                  Center(child: dataLoaderWidget(dataToGet: 'followers')),
                ],
              )
            ),
          ),
          
          VerticalDivider(color: Globals.secondInterfaceCol,),
          
          SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Text("Following",style: TextStyle(color: Colors.black,fontSize: 12),),
                  Center(child: dataLoaderWidget(dataToGet: 'following')),
                ],
              )
            ),
          ),
          
          
          VerticalDivider(color: Globals.secondInterfaceCol,),
          //Comments
          Icon(Icons.message, color:Colors.green,),
          Center(child: dataLoaderWidget(dataToGet: 'comments')),
          VerticalDivider(color: Globals.secondInterfaceCol,),
          //Likes
          Icon(Icons.star,color: Colors.red,),
          Center(child: dataLoaderWidget(dataToGet: 'likes')),// HEART Icon must be replaced instead 
        ],),
      );
    }
    else{
      return null;
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("Account Info",style: TextStyle(color: Globals.secondInterfaceCol),),iconTheme: IconThemeData(color: Globals.secondInterfaceCol), backgroundColor:  Colors.transparent,),
      body: Builder( builder: (context)=> Container(
          height: MediaQuery.of(context).size.height,
          color: Globals.backgroundCol,
            child: Stack(
                children: <Widget>[ 
                  Positioned(
                    top: 145 ,
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: Container(
                      color: Colors.black26,
                      height: MediaQuery.of(context).size.height - 145,
                      child: ListView(children: <Widget>[
                        upBar(context),
                        //This ListView must be a custom object with analyze data (for Insta/Twit/Face separetly)
                        Text("TEXT",style: TextStyle(fontSize: 50),),
                        Text("TEXT",style: TextStyle(fontSize: 50),),
                        Text("TEXT",style: TextStyle(fontSize: 50),),
                        Text("TEXT",style: TextStyle(fontSize: 50),),
                        Text("TEXT",style: TextStyle(fontSize: 50),),
                        Text("TEXT",style: TextStyle(fontSize: 50),),
                        Text("TEXT",style: TextStyle(fontSize: 50),),
                        Text("TEXT",style: TextStyle(fontSize: 50),),
                        Text("TEXT",style: TextStyle(fontSize: 50),),
                        Text("TEXT",style: TextStyle(fontSize: 50),),
                        Text("TEXT",style: TextStyle(fontSize: 50),),
                        Text("TEXT",style: TextStyle(fontSize: 50),),
                        Text("TEXT",style: TextStyle(fontSize: 50),),
                        Text("TEXT",style: TextStyle(fontSize: 50),),
                        Text("TEXT",style: TextStyle(fontSize: 50),),
                        Text("TEXT",style: TextStyle(fontSize: 50),),
                        Text("TEXT",style: TextStyle(fontSize: 50),),
                        Text("TEXT",style: TextStyle(fontSize: 50),),
                        deleteBar(context),
                      ],),
                    ),
                  ),
                  Hero(
                    transitionOnUserGestures: true,
                    tag: DataController.lastUid,
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      width: MediaQuery.of(context).size.width,
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0),bottomRight: Radius.circular(20.0)),//BorderRadius.circular(20.0),
                        
                        gradient: LinearGradient(
                          colors: DataController.lastGrad,
                        ),
                      ),
                      child: Stack(
                        children: <Widget>[ 
                          
                          Positioned(
                            bottom: 0.0,
                            //alignment: Alignment.bottomLeft,
                            child: Container(
                              width: 60.0,
                              height: 60.0,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white,width: 2.0),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AdvancedNetworkImage(
                                      DataController.lastImgUrl,
                                      useDiskCache: true,
                                      cacheRule: CacheRule(maxAge: const Duration(days: 10))
                                    ),//NetworkImage(_url)
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                    width: 23,
                                    height: 23,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white,width: 2.0),
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AdvancedNetworkImage(
                                          DataController.lastSocImg,
                                          useDiskCache: true,
                                          cacheRule: CacheRule(maxAge: const Duration(days: 10))
                                        ),
                                      )
                                    ),
                                  ),
                                ),
                            ),
                          ),
                        //Language Choser
                        Positioned(
                          bottom: 15,
                          right: 10,
                          child: Center(child: Material(color:Colors.transparent,child: LangMenu())),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 60,
                          child:Container(
                            margin: EdgeInsets.only(left: 10.0),
                            child:Material(
                              type: MaterialType.transparency,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                      Text(DataController.lastAccName,textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),
                                      Text(DataController.lastAccNick,textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic,),),
                                  ],
                              ),
                            ),            
                          )
                        ),
                      ]),
                    ),
                  ),
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    bottom: MediaQuery.of(context).size.height - 80,
                    child: AppBar(
                      title: Text("Account Info",style: TextStyle(color: Globals.interfaceCol),),
                      iconTheme: IconThemeData(color: Globals.interfaceCol),
                      backgroundColor:  Colors.transparent,
                      elevation: 0.0,),
                  ),
                ],
              ),
          ),
      ),
    );
  }
}

//This widget loads data about comments and likes
class dataLoaderWidget extends StatefulWidget {
  final String dataToGet;

  const dataLoaderWidget({Key key, this.dataToGet}):super(key:key);

  @override
  _dataLoaderWidgetState createState() => _dataLoaderWidgetState();
}

class _dataLoaderWidgetState extends State<dataLoaderWidget> {
  
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(     
        child: Container(
        child: _isLoading ? _buildLoading() : _buildCommon(),
      ),
    );
  }

  Widget _buildLoading(){
    return SingleChildScrollView(
      child: Center(
        child: Column(children: <Widget>[
          Text("Counting " + widget.dataToGet,style: TextStyle(fontSize: 8),),
          SpinKitCircle(size: 20,color: Colors.black,)
        ],),
      ),
    );
  }

  Widget _buildCommon(){
    String text;
    if(widget.dataToGet == 'likes'){
      text = DataController.lastAccInstance.getLikes().toString();
    }else if(widget.dataToGet == 'comments'){
      text = DataController.lastAccInstance.getComments().toString();
    }else if(widget.dataToGet == 'followers'){
      text = DataController.lastAccInstance.getGenInfoVariable()['follower_count'].toString();
    }else if(widget.dataToGet == 'following'){
      text = DataController.lastAccInstance.getGenInfoVariable()['following_count'].toString();
    }else{
      text = "NOT SPECIFIED";
    }

    
    if(text == null || text == ''){
      setState(() {
        _updateData();
        _isLoading = true;
       }); 
    }
    
    return GestureDetector(
      onTap: (){
       setState(() {
        _updateData();
        _isLoading = true;
       }); 
      },
      child: Text(text),
    );
  }

  void _updateData()async{
    widget.dataToGet == 'likes' || widget.dataToGet == 'comments' 
      ? await DataController.lastAccInstance.getInfo()
      : await DataController.lastAccInstance.getGenInfo();
    setState(() {
     _isLoading = false; 
    });
  }
}

//LANGUAGE MENU CODE
class LangMenu extends StatefulWidget {
  static _LangMenuState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<_LangMenuState>());
  
  @override
  _LangMenuState createState() => _LangMenuState();
}

class _LangMenuState extends State<LangMenu> {
  var _dropDownItems = ["EN","DE","SC","AT","QW","RE","ZC",];
  var _curentVal = DataController.lastAccInstance.getLang();


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white
      ),
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.all(0),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          focusColor: Colors.white,
          highlightColor: Colors.white,
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Text("Choose prior language"),
            items: _dropDownItems.map((String dropDownStringItem){
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Text(dropDownStringItem, style: TextStyle(color: Colors.black),),
              );
            }
            ).toList(),

            onChanged: (String newValue){
              setState(() {
                this._curentVal = newValue;
                //UpdateView
                DataController.accounts.forEach((accView){
                  if (accView.getID() == DataController.lastAccInstance.getID()){
                    accView.updateView(accountLan: newValue);
                  }
                });    

                DataController.lastAccInstance.setLang(newValue);
                DataController.saveAccountsInstanses(accToReplace:DataController.lastAccInstance);
              });
            },

            value: _curentVal,
          ),
        ),
      ),
    );
  }
}