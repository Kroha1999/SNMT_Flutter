import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:social_tool/Data/dataController.dart';
import 'package:social_tool/Data/globalVals.dart';

class AccountsTab extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Container(
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
  
  
  static List<AccountListEl> accounts = [AccountListEl("Zoriana Bighun","@zorik","Instagram","EN",imageurl: "https://bit.ly/2MunTk6",)];


  void addAccountToList(uid,name,nick,social,lan,img){
    setState(() {
     accounts.add(new AccountListEl(name,nick,social,lan,imageurl:img)); 
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: accounts.map((AccountListEl acc){return acc;}).toList(),
    );
  }
}





class AccountListEl extends StatelessWidget {
  String _url;
  
  final String _accountName;
  final String _accountNick;
  final String _socialNetwork;
  final String _accountLan;


  AccountListEl(this._accountName,this._accountNick,this._socialNetwork,this._accountLan,{String imageurl}){
    if(imageurl == null || imageurl == ''){
      _url = Globals.standartImg;
      }
    else{
      _url = imageurl;
    }
  }

  @override
  Widget build(BuildContext context) {
    
    String _socImg;
    List<Color> _socGrad;

    if(_socialNetwork == "Instagram"){
      _socImg = Globals.instImg;
      _socGrad = Globals.instaGrad;
    }else if(_socialNetwork == "Twitter"){
      _socImg = Globals.twitImg;
      _socGrad =Globals.twitGrad;
    }else if(_socialNetwork == "Facebook"){
      _socImg = Globals.faceImg;
      _socGrad =Globals.faceGrad;
    }


    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed('/accountPage');
      },
      child:Container(
        margin: EdgeInsets.all(6.0),
        padding: EdgeInsets.all(15.0),
        child: Stack(children: <Widget>[
          Align(alignment: Alignment.centerLeft,child:
            Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white,width: 2.0),
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(_url)
                ),
              ),
              
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
                    image: NetworkImage(_socImg)
                  )
                ),
              ),
            ),
          ),
          
          Positioned(
            top: 10,
            left: 60,
            child:Container(
              margin: EdgeInsets.only(left: 10.0),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                      Text(_accountName,textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),
                      Text(_accountNick,textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic,),),
                  ],
              ),            
            )
          ),
          
          Positioned(
            top: 0,
            right: 0, 
            child: Text(_accountLan,style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,))         
          ),
        ],
      ),
        
        width: 360.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(
            colors: _socGrad,
          ),
        ),
      )
    );
  }
}