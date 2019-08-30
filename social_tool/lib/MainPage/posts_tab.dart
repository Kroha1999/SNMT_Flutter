import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:social_tool/Data/customWidgets.dart';
import 'package:social_tool/Data/dataController.dart';
import 'package:social_tool/Data/globalVals.dart';

class PostsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Globals.backgroundCol,
      child: Center(
        child: PostsListView()
      ),
    );
  }
}


class PostsListView extends StatefulWidget {
  @override
  _PostsListViewState createState() => _PostsListViewState();
}

class _PostsListViewState extends State<PostsListView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: DataController.posts.map((PostListEl el){return el;}).toList(),
    );
  }
}

class PostListEl extends StatefulWidget {

  String _description;
  String _imgUrl;
  String _status;
  List<String> _socials;
  List<String> _accs;
  DateTime _timeStamp;
  final String _postUuid = Uuid().v1();

  String getUUID(){
    return _postUuid;
  }

  
  //Constructor
  PostListEl({
    String description,
    String imgUrl,
    String status,
    List<String> socials,
    List<String> accs,
    DateTime timeStamp,
  })
  {
    this._description = description;
    this._imgUrl = imgUrl;
    this._status = status;
    this._timeStamp = timeStamp;
    this._socials = socials;
    this._accs = accs;
  }

  @override
  _PostListElState createState() => _PostListElState();
}

class _PostListElState extends State<PostListEl> {
  
  double offset = 7.0;
  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Hero(
        tag: widget._postUuid, // UUID HERO
        child:Container( 
          margin: EdgeInsets.all(6.0),
          padding: EdgeInsets.all(15.0),
          width: 360.0,
          //height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Globals.secondInterfaceCol, width: 1),
            borderRadius: BorderRadius.circular(20.0),
            color: Globals.interfaceCol,
          ),
          child: Stack(
            children: <Widget>[
              postAndSocialsView(
                offset: 0,
                size: 60,
                //IMAGE TO POST
                imgUrl: widget._imgUrl,
                borderWidth: 1,
                borderColor: Colors.black,
                //SOCIALS TO POST
                socImgs: widget._socials,
              ),
              //MAIN TEXT OBJECT - DESCRIPTION OF THE POST
              Positioned(
                top: 4,
                left: 83,
                child: Container(
                  height: 55,
                  width: 175,
                  child: Text(widget._description,
                    style: TextStyle(fontSize: 9, wordSpacing: 1),
                    textAlign: TextAlign.justify,
                    
                  )
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    //STATUS
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 4, 0, 2),
                      child: Text(widget._status, style: TextStyle(color:Colors.green,fontSize: 12),)
                    ),
                    //TIME
                    Text(widget._timeStamp.year.toString()+"/"+widget._timeStamp.month.toString()+"/"+widget._timeStamp.day.toString(), style: TextStyle(color:Colors.grey,fontSize: 8),),
                    Text(widget._timeStamp.hour.toString()+":"+widget._timeStamp.minute.toString()+":"+widget._timeStamp.second.toString(), style: TextStyle(color:Colors.grey,fontSize: 8),),
                    
                  ],
                )
              ),
              Positioned(
                bottom: 0,
                right:  0,
                child: Container(
                  //ACCOUNTS IMAGES
                  child: cirleImagesRow(
                    contHeight: 0,
                    size: 20,
                    imgs: widget._accs,
                    maxVisible: 4,
                    offset: 25
                    ),
                    width: 95,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}