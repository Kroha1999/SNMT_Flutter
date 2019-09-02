import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:social_tool/Data/dataController.dart';
import 'package:social_tool/Data/globalVals.dart';

//Tabs
import 'accounts_tab.dart' as accTab;
import 'posts_tab.dart' as postTab; 


//Dynamic home page
class Home extends StatefulWidget {
  @override
  _MyTabState createState() => _MyTabState();
}

//Home page View + handle multiple states
class _MyTabState extends State<Home> with SingleTickerProviderStateMixin {

  TabController _tabController;
  ScrollController _scrollController;
  
  @override
  void initState(){
    _scrollController = ScrollController();
    _tabController = new TabController(vsync: this, length: 2, initialIndex: 0);
    _tabController.addListener((){setState((){});});
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context,bool innerBoxIsScrolled){
          return <Widget>[
            SliverAppBar(
              title: Text("SNM Tool",style: TextStyle(color: Globals.secondInterfaceCol),),
              backgroundColor:  Globals.interfaceCol,
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,

              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.settings,color: Globals.secondInterfaceCol,),
                  onPressed: (){
                    Navigator.of(context).pushNamed('/settings');
                    },
                )
              ],
              
              bottom: TabBar(
                indicatorColor: Globals.secondInterfaceCol,
                controller: _tabController,
                tabs: <Widget>[
                  Tab(icon: Icon(Icons.supervised_user_circle,color: Globals.secondInterfaceCol,),),
                  Tab(icon: Icon(Icons.send,color: Globals.secondInterfaceCol,),),
                ],
              ),
            )
          ];
        },
        body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          accTab.AccountsTab(),
          postTab.PostsTab(),
        ],  
      ),
      ),
      
      floatingActionButton: AnimatedSwitcher(
        duration: Duration(milliseconds: 100),
        child: fabOnTab(),
        transitionBuilder: (Widget child, Animation<double> animation){
          final scaleTween = TweenSequence([
            TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.1),weight: 1),
            TweenSequenceItem(tween: Tween(begin: 0.1, end: 1.0),weight: 1),
          ]);
          return ScaleTransition(
            scale: scaleTween.animate(animation),
            child: child,
          );
        },
      ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget fabOnTab(){
    return _tabController.index == 0
      ? FloatingActionButton.extended(
        heroTag: 'btn1',
        key: UniqueKey(),
        onPressed: (){Navigator.of(context).pushNamed('/addAccountPage');},
        backgroundColor: Globals.secondInterfaceCol,
        icon: Icon(Icons.add,color: Globals.interfaceCol,),
        label: Text("Account",style: TextStyle(color: Globals.interfaceCol,)),
        )
      : FloatingActionButton.extended(
        heroTag: 'btn2',
        key: UniqueKey(),
        onPressed:(){
          DataController.aditionalStringsData = [];
          DataController.defaultAddString();
          Navigator.of(context).pushNamed('/makePost');
          },
        label: Text("Post",style: TextStyle(color: Globals.interfaceCol,),),
        backgroundColor: Globals.secondInterfaceCol,
        icon: Icon(Icons.add,color: Globals.interfaceCol,),  
      );
      
  }


}

  
 
