import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
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

  final Color _interfaceCol = Globals.interfaceCol;
  
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
              title: Text("SNM Tool"),
              backgroundColor: _interfaceCol,
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,

              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: (){
                    Navigator.of(context).pushNamed('/settings');
                    },
                )
              ],
              
              bottom: TabBar(
                indicatorColor: Colors.white,
                controller: _tabController,
                tabs: <Widget>[
                  Tab(icon: Icon(Icons.supervised_user_circle),),
                  Tab(icon: Icon(Icons.send),),
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
        duration: Duration(milliseconds: 200),
        child: _FABonTab(),
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

  Widget _FABonTab(){
    return _tabController.index == 0
      ? FloatingActionButton.extended(
        heroTag: 'btn1',
        key: UniqueKey(),
        onPressed: (){Navigator.of(context).pushNamed('/addAccountPage');},
        backgroundColor: _interfaceCol,
        icon: Icon(Icons.add),
        label: Text("Account"),
        )
      : FloatingActionButton.extended(
        heroTag: 'btn2',
        key: UniqueKey(),
        onPressed: (){Navigator.of(context).pushNamed('/makePost');},
        label: Text("Post"),
        backgroundColor: _interfaceCol,
        icon: Icon(Icons.add),  
      );
      
  }
}

  
 
