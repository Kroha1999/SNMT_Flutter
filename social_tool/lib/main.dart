import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

//Accounts
import 'Accounts/instaAccount.dart';

//Pages
import 'Pages/account.dart' as myAcc;
import 'Pages/addAccount.dart' as addAcc;
import 'Pages/makePost.dart' as makePost;
import 'Pages/post.dart' as myPost;
import 'Pages/MySettings.dart' as mySet;


//Tabs
import 'accounts_tab.dart' as accTab;
import 'posts_tab.dart' as postTab; 

void main() => runApp(MyApp());

//App creation
class MyApp extends StatelessWidget{


  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Flutter SNMT',
      home: Home(),
      routes: <String, WidgetBuilder>{
        "/accountPage": (BuildContext context) => myAcc.AccountPage(),
        "/addAccountPage": (BuildContext context) => addAcc.AddAccountPage(),
        "/makePost": (BuildContext context) => makePost.MakePost(),
        "/myPost": (BuildContext context) => myPost.MyPost(),
        "/settings": (BuildContext context) => mySet.MySettings(),
      },
    );
  }
}

//Dynamic home page
class Home extends StatefulWidget {
  @override
  _MyTabState createState() => _MyTabState();
}

//Home page View + handle multiple states
class _MyTabState extends State<Home> with SingleTickerProviderStateMixin {

  TabController _tabController;
  ScrollController _scrollController;

  final Color _interfaceCol = Colors.deepPurple;
  
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
                  onPressed: (){Navigator.of(context).pushNamed('/settings');},
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
            TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3),weight: 2),
            TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0),weight: 3),
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
        heroTag: 'AddAccount',
        key: UniqueKey(),
        onPressed: (){Navigator.of(context).pushNamed('/addAccountPage');},
        backgroundColor: _interfaceCol,
        icon: Icon(Icons.add),
        label: Text("Account"),
        )
      : FloatingActionButton.extended(
        heroTag: 'Post',
        key: UniqueKey(),
        onPressed: (){Navigator.of(context).pushNamed('/makePost');},
        label: Text("Post"),
        backgroundColor: _interfaceCol,
        icon: Icon(Icons.add),  
      );
      
  }
}

  
 
