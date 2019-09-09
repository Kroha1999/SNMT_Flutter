import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_tool/PostsData/postData.dart';
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
      children: DataController.posts.reversed.toList()//DataController.posts.map((PostListEl el){return el;}).toList(),
    );
  }
}

class PostListEl extends StatefulWidget {
  
  String _postUuid;
  final PostData post;
  String _status;
  
  String _description;
  var _img;
  List<String> _socials;
  List<String> _accsImgs;
  DateTime _timeStamp;
  
  String saveInstance(){
    return post.savePost();
  }

  String getUUID(){
    return _postUuid;
  }

  
  //Constructor
  PostListEl(this.post){
    this._postUuid = this.post.getUid();
    this._timeStamp = post.getTimeStamp();
    this._description = post.getDescription();
    this._img = post.getPhoto();
    this._socials = post.getSocials();
    this._accsImgs = post.getAccsImgs();
    this._status = post.getStatus();
  }

  @override
  _PostListElState createState() => _PostListElState();
}

class _PostListElState extends State<PostListEl> {
  
  double offset = 7.0;
  
  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, "/myPost",arguments: widget);
      },
      child: Hero(
        tag: widget._postUuid, // UUID HERO
        child:mainElementView(),
      ),
    );
  }


  Container mainElementView() {
    return Container( 
        margin: EdgeInsets.all(6.0),
        padding: EdgeInsets.all(15.0),
        width: 360.0,
        height: 91,
        decoration: BoxDecoration(
          border: Border.all(color: Globals.secondInterfaceCol, width: 1),
          borderRadius: BorderRadius.circular(20.0),
          color: Globals.interfaceCol,
        ),
        child: Stack(
          children: <Widget>[
            postAndSocialsView(
              offset: 8,
              size: 60,
              //IMAGE TO POST
              img: widget._img,
              borderWidth: 1,
              borderColor: Colors.black,
              //SOCIALS TO POST
              socImgs: widget._socials,
            ),
            //MAIN TEXT OBJECT - DESCRIPTION OF THE POST
            Positioned(
              top: 4,
              left: 83,
              child: Material(
                child: Container(
                  height: 55,
                  width: 175,
                  child: Text(widget._description,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 9, wordSpacing: 1),
                    textAlign: TextAlign.justify,
                    
                  )
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  //STATUS
                  Material(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 4, 0, 2),
                      child: Text(widget._status, style: TextStyle(color:Colors.green,fontSize: 12),)
                    ),
                  ),
                  //TIME
                  Material(child: Text(widget._timeStamp.year.toString()+"/"+widget._timeStamp.month.toString()+"/"+widget._timeStamp.day.toString(), style: TextStyle(color:Colors.grey,fontSize: 8),)),
                  Material(child: Text(widget._timeStamp.hour.toString()+":"+widget._timeStamp.minute.toString()+":"+widget._timeStamp.second.toString(), style: TextStyle(color:Colors.grey,fontSize: 8),)),
                  
                ],
              )
            ),
            Positioned(
              bottom: 0,
              right:  0,
              child: Container(
                //ACCOUNTS IMAGES
                child: circleImagesRow(
                  contHeight: 0,
                  size: 20,
                  imgs: widget._accsImgs,
                  maxVisible: 4,
                  offset: 35
                  ),
                  width: 95,
              ),
            )
          ],
        ),
      );
  }
}