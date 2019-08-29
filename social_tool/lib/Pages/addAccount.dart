import "package:flutter/material.dart";
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import "package:social_tool/Accounts/accountData.dart";
import "package:social_tool/Data/dataController.dart";
import 'package:social_tool/Data/globalVals.dart';

class AddAccountPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Account",style: TextStyle(color: Globals.secondInterfaceCol),),
        iconTheme: IconThemeData(color: Globals.secondInterfaceCol), 
        backgroundColor: Globals.interfaceCol ,),
      body: Container(
        color: Globals.backgroundCol,
        child: Center(
          child: AccChooser()        
        ),
      )
    );
  }
}


class AccChooser extends StatelessWidget {
  void goNext(BuildContext context , var pageToGo){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => pageToGo),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        // INSTAGRAM ADD ACCOUNT
        GestureDetector(
          onTap: (){
            //Go to Insta Page
            goNext(context,AddInsta());
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
                      image: AdvancedNetworkImage(
                        Globals.instImg,
                        useDiskCache: true,
                        cacheRule: CacheRule(maxAge: const Duration(days: 10))
                      ),//NetworkImage(Globals.instImg)
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
              colors:  Globals.instaGrad,
              ),
            ),
          ),
        ),

        //TWITTER ADD ACCOUNT
        GestureDetector(
          onTap: (){
            //Go to Twitter Page (DEBUG to Insta)
            goNext(context,AddInsta());
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
                      image: AdvancedNetworkImage(
                        Globals.twitImg,
                        useDiskCache: true,
                        cacheRule: CacheRule(maxAge: const Duration(days: 10))
                      ),//NetworkImage(Globals.twitImg)
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
              colors:  Globals.twitGrad,
              ),
            ),
          ),
        ),
      ],),
    );
  }
}



class AddInsta extends StatelessWidget {
  
  final controllerNick = TextEditingController();
  final controllerPass = TextEditingController();
  

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Account Info",style: TextStyle(color: Globals.secondInterfaceCol),),iconTheme: IconThemeData(color: Globals.secondInterfaceCol), backgroundColor:  Globals.interfaceCol,),
      body: Builder(
        builder: (context) => Center(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(30.0),
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width-60,
                height: MediaQuery.of(context).size.height-150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient: LinearGradient(
                    colors:  Globals.instaGrad,
                    ),
                  ),

                child: Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                    //Nickname
                    Container(
                      height: 43,
                      width: MediaQuery.of(context).size.width - 80,
                      margin: EdgeInsets.all(5.0),
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),//EdgeInsets.all(2.0),
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
                      height: 43,
                      width: MediaQuery.of(context).size.width - 80,
                      margin: EdgeInsets.all(5.0),
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                      height: 43,
                      width: MediaQuery.of(context).size.width - 80,
                      margin: EdgeInsets.all(5.0),
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        ),
                      child: LangMenu(),
                    ),
                    //Submit Button with Loading
                    SubmitBtn(controllerNick: controllerNick,controllerPass: controllerPass,),
                  ],)
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


//SUBMIT BUTTON WITH LOADING STATE
class SubmitBtn extends StatefulWidget {
  final controllerNick;
  final controllerPass;

  const SubmitBtn({Key key, this.controllerNick,this.controllerPass}):super(key:key);
  
  @override
  _SubmitBtnState createState() => _SubmitBtnState();
}

class _SubmitBtnState extends State<SubmitBtn> {
  
  bool _isLoading = false;
  

  void logIn(nick,pass,lang,context) async {
    var acc = AccountData("Instagram");
    String resp = await acc.auth(nick,pass,lang);
    if(resp.trimRight() == '"invalid_user"'){
      DataController.showMessage(context, "Wrong username");
    }else if(resp.trimRight() == '"bad_password"'){
      DataController.showMessage(context, "Wrong password");
    }else{
      DataController.showMessage(context, resp.trimRight());
    }
    
    if(resp == 'Success'){
      //SAVING ACCOUNTS TEST
      DataController.chosenlang = null; //Making default value on successfull 
      DataController.accountsDataInstances.add(acc);
      DataController.saveAccountsInstanses();
      Navigator.of(context).popAndPushNamed('/home');
      setState(() {
      _isLoading = false; 
      });
    }else{
      setState(() {
      _isLoading = false; 
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isLoading ? _buildLoading() : _buildCommon(),
    );
  }


  Widget _buildLoading(){
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width - 80,
        height: 43,
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        ),
        child: Center(child: SpinKitThreeBounce(color: Globals.secondInterfaceCol,size: 20,),),
      ),
    );
  }

  Widget _buildCommon(){
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width - 80,
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        ),
        child: Center(child: Text("Submit",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0,color: Globals.secondInterfaceCol),)),
      ),
      onTap: (){
        //CREATING ACCOUNT
        String nick = widget.controllerNick.text;
        String pass = widget.controllerPass.text;
        String lang = DataController.chosenlang;//langControl.of(context)._curentVal;
        print("ADD ACCOUNT: Nick: $nick, Pass: $pass, Lang: $lang");
        
        if(nick == null || nick == ""){
          DataController.showMessage(context, "Please enter nickname");
        }else if(pass==null || pass == ""){
          DataController.showMessage(context, "Please enter password");
        }else if(lang == null || lang == "null" || lang == "Choose prior language"){
          DataController.showMessage(context, "Please choose your language");
        }else if (DataController.checkIfLogged(nick,"Instagram")){
          DataController.showMessage(context, "You are already logged in");
        }else{
          setState(() {
           _isLoading=true; 
          });
          logIn(nick, pass, lang, context);
        }

        
      },
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
  var _curentVal = DataController.chosenlang;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.all(0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text("Choose prior language"),
          items: Globals.languages.map((String dropDownStringItem){
            return DropdownMenuItem<String>(
              value: dropDownStringItem,
              child: Text(dropDownStringItem),
            );
          }
          ).toList(),

          onChanged: (String newValue){
            setState(() {
              this._curentVal = newValue;    
              DataController.chosenlang = newValue;
            });
          },

          value: _curentVal,
        ),
      ),
    );
  }
}

