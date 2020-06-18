import 'package:flutter/material.dart';
import 'package:first_flutter_app/todo.dart';
import 'API.dart';


class AddNew extends StatefulWidget {
  @override
  _AddNewState createState() => _AddNewState();
}

class _AddNewState extends State<AddNew>{

  TextFormField taskNameController = new TextFormField();

  Widget _buildItem(BuildContext context){
    return new Form(
      child: new Column(
        children: [
          Text("Will be added soon")
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.blueGrey[800],
      body: _buildItem(context),
    );
  }
}
