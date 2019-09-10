import "package:flutter/material.dart";
import 'package:social_tool/Data/dataController.dart';
import 'package:social_tool/Data/globalVals.dart';
import 'package:social_tool/MainPage/posts_tab.dart';

enum ConfirmAction { CANCEL, ACCEPT }
//DELETE ALERT WINDOW 
Future<ConfirmAction> asyncDeletePost(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Post?'),
        content: const Text(
            'This action will delete your post only from the memory of your smartphone, posts will not be deleted at Social Networks.'),
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
              Navigator.of(context).pop(ConfirmAction.ACCEPT);
            },
          )
        ],
      );
    },
  );
}

void deleteEl(BuildContext context,PostListEl widget)async{
  var resp = await asyncDeletePost(context);
  if(resp == ConfirmAction.ACCEPT){
    DataController.deletePostListEl(widget);
    Navigator.of(context).pop();
  }
}

class MyPost extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    PostListEl widget = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(title: Text("My Post",style: TextStyle(color: Globals.secondInterfaceCol),),iconTheme: IconThemeData(color: Globals.secondInterfaceCol), backgroundColor:  Globals.interfaceCol ,),
      body: Container(
        color: Colors.black26,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              widget,
              GestureDetector(
                onTap: (){deleteEl(context,widget);},
                child: deleteView(),
              )
            ],
          ),
        ),
      ),
    );
  }
}



  Container deleteView(){
    return Container(
      child: Center(
        child: Icon(Icons.delete_forever,color: Colors.white,size: 40,),
      ),
      margin: EdgeInsets.all(6.0),
      padding: EdgeInsets.all(5.0),
      width: 360.0,
      height: 50,
      decoration: BoxDecoration(
          //border: Border.all(color: Globals.secondInterfaceCol, width: 1),
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.red,
        ),
    );
  }
