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
      title: "To-Do List",
      themeMode: ThemeMode.system,
      home: TodoList()
    );
  }
}


