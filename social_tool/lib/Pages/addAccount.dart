import "package:flutter/material.dart";
import "package:social_tool/Accounts/instaAccount.dart";
import "package:social_tool/Data/dataController.dart";

class AddAccountPage extends StatelessWidget {

  final Color _interfaceCol = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Account"), backgroundColor: _interfaceCol ,),
      body: Container(
        child: Center(
          child: AccChooser()        
        ),
      )
    );
  }
}



//Dynamic
class AccChooser extends StatefulWidget {
  @override
  AccChooserState createState() => AccChooserState();
}

class AccChooserState extends State<AccChooser> {
  
  static int page = 0;
  

  void goNext(int numb){
    setState(() {
      page = numb;
    });
  }

  
  
 
  @override
  Widget build(BuildContext context) {
    
    if(page == 0)
      return Container(
        child: Column(children: <Widget>[
          // INSTAGRAM ADD ACCOUNT
          GestureDetector(
            onTap: (){
              //Go to Insta Page
              goNext(1);
            },
            child: Container(
              margin: EdgeInsets.all(6.0),
              padding: EdgeInsets.all(10.0),
              child: Row(children: <Widget>[
                // INSTAGRAM icon
                Container(
                    width: 35,
                    height: 35,
                    margin: EdgeInsets.fromLTRB(5, 0, 80, 0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage( "https://en.instagram-brand.com/wp-content/uploads/2016/11/Glyph-Icon-hero.png")
                      )
                    ),
                ),
                //Text
                Text("Instagram",style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),)
              ],),
              width: 360.0,
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: LinearGradient(
                colors:  [const Color(0xFF915FB5), const Color(0xFFCA436B)],
                ),
              ),
            ),
          ),

          //TWITTER ADD ACCOUNT
          GestureDetector(
            onTap: (){
              //Go to Twitter Page (DEBUG to Insta)
              goNext(1);
            },
            child: Container(
              margin: EdgeInsets.all(6.0),
              padding: EdgeInsets.all(10.0),
              child: Row(children: <Widget>[
                Container(
                    width: 35,
                    height: 35,
                    margin: EdgeInsets.fromLTRB(5, 0, 90, 0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage("https://pbs.twimg.com/profile_images/1111729635610382336/_65QFl7B.png")
                      )
                    ),
                ),
                //Text
                Text("Twitter",style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),)

              ],),
              width: 360.0,
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: LinearGradient(
                colors:  [ const Color(0xFF20cecd),const Color(0xFF0181cc)],
                ),
              ),
            ),
          ),
        ],),
      );
    
    
    
    else {
      page = 0;
      return AddInsta();
    }
  }
}



class AddInsta extends StatelessWidget {
  
  final controllerNick = TextEditingController();
  final controllerPass = TextEditingController();
  
  

  void logIn(nick,pass,lang,context) async {
    var acc = AccountData("Instagram");
    String resp = await acc.auth(nick,pass,lang);
    DataController.showMessage(context, resp.trimRight());
    if(resp == 'Success'){
      DataController.accountsKeys.add(acc.getKey());

      await DataController.saveAccountsInstanses();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30.0),
      padding: EdgeInsets.all(10.0),
      width: 360.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: LinearGradient(
          colors:  [const Color(0xFF915FB5), const Color(0xFFCA436B)],
          ),
        ),

      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
          //Nickname
          Container(
            margin: EdgeInsets.all(5.0),
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              ),

            child: TextField(
              controller: controllerNick,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Nickname",
              ),
            )
          ),

          //Password
          Container(
            margin: EdgeInsets.all(5.0),
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              ),
            child: TextField(
              controller: controllerPass,
              obscureText: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Password"
              ),
            )
          ),

          //Language choose
          Container(
            margin: EdgeInsets.all(5.0),
            padding: EdgeInsets.all(0.0),
            width: 295,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              ),
            child: LangMenu(),
          ),

          //Submit btn
          GestureDetector(
            child: Container(
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.all(10.0),
              width: 295,
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              ),
              child: Center(child: Text("Submit",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30.0,color: Colors.blueGrey),)),
            ),
            onTap: (){
              //CREATING ACCOUNT
              String nick = controllerNick.text;
              String pass = controllerPass.text;
              String lang = DataController.lang;//langControl.of(context)._curentVal;
              print("ADD ACCOUNT: Nick: $nick, Pass: $pass, Lang: $lang");
              
              if(nick == null || nick == ""){
                DataController.showMessage(context, "Please enter nickname");
              }else if(pass==null || pass == ""){
                DataController.showMessage(context, "Please enter password");
              }else if(lang == null || lang == "Choose prior language"){
                DataController.showMessage(context, "Please choose your language");
              }else{
                logIn(nick, pass, lang, context);
              }

              
            },
          ),
        ],)
      ),
    );
  }
}





//LANGUAGE MENU CODE
class LangMenu extends StatefulWidget {
  static _LangMenuState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<_LangMenuState>());
  
  @override
  _LangMenuState createState() => _LangMenuState();
}

class _LangMenuState extends State<LangMenu> {
  var _dropDownItems = ["Choose prior language","EN","DE","SC","AT","QW","RE","ZC",];
  var _curentVal = "Choose prior language";


  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton<String>(
              items: _dropDownItems.map((String dropDownStringItem){
                return DropdownMenuItem<String>(
                  value: dropDownStringItem,
                  child: Text(dropDownStringItem),
                );
              }
              ).toList(),

              onChanged: (String newValue){
                setState(() {
                  this._curentVal = newValue;    
                  DataController.lang = newValue;
                });
              },

              value: _curentVal,
            ),
    );
  }
}

