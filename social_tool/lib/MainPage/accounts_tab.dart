import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:social_tool/Data/customWidgets.dart';
import 'package:social_tool/Data/dataController.dart';

import 'package:social_tool/Data/globalVals.dart';

class AccountsTab extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Globals.backgroundCol,
      child: Center(
        child: AccountsListView()
      ),
      
    );
  }
}

class AccountsListView extends StatefulWidget {
  @override
  AccountsListViewState createState() => AccountsListViewState();
}

class AccountsListViewState extends State<AccountsListView> {

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: DataController.accounts.map((AccountListEl acc){return acc;}).toList(),
    );
  }
}





class AccountListEl extends StatefulWidget {
  String _url;
  
  final String _uid;
  String _accountName;
  String _accountNick;
  final String _socialNetwork;
  String _accountLan;
  
  void updateView({String accountName, String accountNick, String accountLan,String url}){
    if(accountName !=null){this._accountName = accountName;}
    if(accountNick !=null){this._accountNick = accountNick;}
    if(accountLan !=null){this._accountLan = accountLan;}
    if(url !=null){this._url = url;}
  }

  String getID(){
    return _uid;
  }

  AccountListEl(this._accountName,this._accountNick,this._socialNetwork,this._accountLan,this._uid,{String imageurl}){
    if(imageurl == null || imageurl == ''){
      _url = Globals.standartImg;
      }
    else{
      _url = imageurl;
    }
  }

  @override
  _AccountListElState createState() => _AccountListElState();
}

class _AccountListElState extends State<AccountListEl> {

  @override
  Widget build(BuildContext context) {
    
    String _socImg;
    List<Color> _socGrad;

    if(widget._socialNetwork == "Instagram"){
      _socImg = Globals.instImg;
      _socGrad = Globals.instaGrad;
    }else if(widget._socialNetwork == "Twitter"){
      _socImg = Globals.twitImg;
      _socGrad =Globals.twitGrad;
    }else if(widget._socialNetwork == "Facebook"){
      _socImg = Globals.faceImg;
      _socGrad =Globals.faceGrad;
    }


    return GestureDetector(
      onTap: (){
        DataController.getClickedAccount(widget._accountNick,widget._accountName,widget._uid,widget._url,_socGrad);
        Navigator.of(context).pushNamed('/accountPage');
      },
      child:Hero(
        tag: widget._uid,
        child: Container(
          margin: EdgeInsets.all(6.0),
          padding: EdgeInsets.all(15.0),
          child: Stack(children: <Widget>[
            Align(alignment: Alignment.centerLeft,
            child: accAndSocialView(size: 60, imageUrl: widget._url, socImageUrl: _socImg,borderWidth: 2.0)
            ),
            
            Positioned(
              top: 10,
              left: 60,
              child:Container(
                margin: EdgeInsets.only(left: 10.0),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                        Text(widget._accountName,textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),
                        Text(widget._accountNick,textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic,),),
                    ],
                ),            
              )
            ),
            
            Positioned(
              top: 0,
              right: 0, 
              child: Text(widget._accountLan,style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,))         
            ),
          ],
        ),
          
          width: 360.0,
          decoration: BoxDecoration(
            /*boxShadow: [BoxShadow(
              color: Colors.black,
              offset: Offset(3.0,1.0),
              blurRadius: 30.0,
              spreadRadius: 1.0
            )],*/ //SHADOW
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradient(
              colors: _socGrad,
            ),
          ),
        ),
      )
    );
  }
}