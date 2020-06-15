import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:first_flutter_app/todo_list.dart';

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
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.category)),
                Tab(icon: Icon(Icons.done)),
                Tab(icon: Icon(Icons.filter_list))
              ],
            ),
            title: Text("To-do List"),
          ),
          body: TabBarView(
            children: [
              TodoList(),
              Icon(Icons.done),
              Icon(Icons.filter_list)
            ],
          ),
        ),
      )
    );
  }
}


