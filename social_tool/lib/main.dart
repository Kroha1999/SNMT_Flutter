import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

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
  
  @override
  void initState(){
    _scrollController = ScrollController();
    _tabController = new TabController(vsync: this, length: 2);
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
              backgroundColor: Colors.grey,

              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
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

      /*appBar: AppBar(
        title: Text("Flutter SNMT"),
        backgroundColor: Colors.black54,
        
        bottom: TabBar(
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: <Widget>[
             Tab(icon: Icon(Icons.supervised_user_circle),),
             Tab(icon: Icon(Icons.send),),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          accTab.AccountsTab(),
          postTab.PostsTab(),
        ],
      ),*/
    );
  }
}


