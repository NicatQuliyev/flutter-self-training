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
  Future todo_future;

  _getTodos(int state){
    setState(() {
      todo_future = API.getTodos(state);
    });
    todo_future.then((response) => {
      setState(() {
              Iterable list = json.decode(response.body);
              todos = list.map((model) => Todo.fromJson(model)).toList();
        })
    });
  }

  initState(){
    super.initState();
    _getTodos(1);
  }

  Widget _buildItem(BuildContext context, int index) {
    final todo = todos[index];
    return new Container(
        child : new Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text(todo.title),
                subtitle: Text("${todo.created_at}"),
              ),
              new ButtonBar(
                children:[
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
                    icon: Icon(Icons.archive, color: Colors.red)
                )
                ]
              )
            ],
          ),
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

  _markUndone(Todo todo){
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
      backgroundColor: Colors.blueGrey[800],
      body: Center(
        child: FutureBuilder(
          future: todo_future,
          builder: (context, snapshot){
            if(todos.length > 0)
            {
              return ListView.builder(
                itemBuilder: _buildItem,
                itemCount: todos.length,
              );
            }
            return CircularProgressIndicator(backgroundColor: Colors.transparent,valueColor:  new AlwaysStoppedAnimation<Color>(Colors.yellow),);
          },
        ),
      ),
    );
  }

}