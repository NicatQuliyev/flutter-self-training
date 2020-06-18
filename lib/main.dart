import 'package:first_flutter_app/add_new.dart';
import 'package:first_flutter_app/todo_list_done.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:first_flutter_app/todo_list.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';


void main() {
//  runApp(MyApp());
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.blueGrey[900],
            bottom: new TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              onTap: null,
              indicator: new BubbleTabIndicator(
                indicatorHeight: 25.0,
                indicatorColor: Colors.pinkAccent,
                tabBarIndicatorSize: TabBarIndicatorSize.tab
              ),
              tabs: [
                Tab(text: "Todo"),
                Tab(text: "Completed"),
                Tab(text: "Archived")
              ],
            ),
            title: Text(" - HYBRID TODO - ", style: TextStyle( fontFamily: "Segoe",letterSpacing: 2.0,fontWeight: FontWeight.bold)),
          ),
          body: TabBarView(
            children: [
              TodoList(),
              TodoListDone(),
              Text("Archiveds")
            ],
          ),
        ),
      ),
    );
  }
}


