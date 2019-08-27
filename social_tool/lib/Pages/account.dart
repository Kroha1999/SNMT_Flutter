import "package:flutter/material.dart";
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:social_tool/Data/dataController.dart';
import 'package:social_tool/Data/globalVals.dart';

enum ConfirmAction { CANCEL, ACCEPT }
 
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
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height - 145,
                      child: ListView(children: <Widget>[
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
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: (){
                              print("Deleting Item");
                              _deleteAccount(context);
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                              child: Material(
                                type: MaterialType.transparency,
                                child: Icon(Icons.delete_forever, color: Colors.red,),
                             ),       
                            ),
                          )
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