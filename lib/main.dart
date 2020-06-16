import 'package:first_flutter_app/todo_list_done.dart';
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
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.category)),
                Tab(icon: Icon(Icons.done))
              ],
            ),
            title: Text("To-do List"),
          ),
          body: TabBarView(
            children: [
              TodoList(),
              TodoListDone()
            ],
          ),
        ),
      )
    );
  }
}


