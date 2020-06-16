import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:first_flutter_app/todo.dart';
import 'API.dart';


class TodoListDone extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoListDone>{
  List<Todo> todos = [];


  _getTodos(int state){
    API.getTodos(state).then((response){
      setState(() {
        Iterable list = json.decode(response.body);
        todos = list.map((model) => Todo.fromJson(model)).toList();
      });
    });
  }

  initState(){
    super.initState();
    _getTodos(1);
  }


  Widget _buildItem(BuildContext context, int index) {
    final todo = todos[index];
    return ListTile(
      onTap: null,
      title: new Row(
        children: <Widget>[
          new Expanded(child: new Text(todo.title)),
          new IconButton(
              icon: Icon(
                Icons.undo, color: Colors.orange),
                onPressed: () {
                  _markUndone(todo);
                }
          ),
          new IconButton(
              onPressed: (){
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text("Delete task"),
                        content: Text("Are you sure to delete this task ?"),
                        actions: [
                          FlatButton(
                            child: Text("Yes"),
                            onPressed: (){
                              setState(() {
                                _removeTodo(todo);
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                          FlatButton(
                            child: Text("No"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    }
                );
              },
              icon: Icon(Icons.remove_circle, color: Colors.red)
          )
        ],
      ),
    );
  }

  _removeTodo(Todo todo){
    setState(() {
      API.deleteTask(todo.id);
      _getTodos(1);
      final snackbar = SnackBar(content: Text("Removed: ${todo.title}"), backgroundColor: Colors.red);
      Scaffold.of(context).showSnackBar(snackbar);
    });
  }

  _markUndone(Todo todo)
  {
    todo.isDone = false;
    API.updateTask(todo).then((res) => {
      _getTodos(1)
    });
    final snackbar = SnackBar(content: Text("Sent back: ${todo.title}"), backgroundColor: Colors.red);
    Scaffold.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: _buildItem,
        itemCount: todos.length,
      ),
    );
  }

}