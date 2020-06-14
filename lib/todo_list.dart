import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:first_flutter_app/todo.dart';
import 'API.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {

  initState(){
    super.initState();
    _getTodos();
  }

  _getTodos(){
    API.getTodos().then((response){
          setState(() {
            Iterable list = json.decode(response.body);
            todos = list.map((model) => Todo.fromJson(model)).toList();
          });
    });
  }

  List<Todo> todos = [
    Todo(title: 'Learn Dart'),
    Todo(title: 'Try Flutter'),
    Todo(title: 'Be amazed!')
  ];

    TextEditingController controller = new TextEditingController();

  _toggleTodo(Todo todo, bool isChecked){
    setState(() {
      todo.isDone = isChecked;
    });
  }
  _removeTodo(Todo todo){
    setState(() {
      this.todos.remove(todo);
    });
  }
  _addToList(Todo todo){
    setState(() {
      this.todos.add(todo);
    });
  }

  Widget _buildItem(BuildContext context, int index) {
    final todo = todos[index];

    return ListTile(
      onTap: null,
      title: new Row(
        children: <Widget>[
          new Expanded(child: new Text(todo.title)),
          new Checkbox(
              value: todo.isDone,
              onChanged: (bool isChecked){
                _toggleTodo(todo, isChecked);
              }
          ),
          new FlatButton(
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
//                              todos.remove(todo);
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
              child: Icon(Icons.remove_circle, color: Colors.red,)
          )
        ],

      ),
    );
 }

  _addTodo() async {
    final todo = await showDialog<Todo>(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("New todo"),
            content: TextField(
              controller: controller,
              autofocus: true,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Add"),
                onPressed: (){
                    final todo = new Todo(title: controller.value.text);
                    controller.clear();
                    Navigator.of(context).pop(todo);
                },
              )
            ],
          );
        }
    );
    if(todo != null){
      _addToList(todo);
    }
  }

  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("To-Do List")),
      body: ListView.builder(
          itemBuilder: _buildItem,
          itemCount: todos.length,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_box),
        onPressed: (){
          _addTodo();
        },
      ),
    );
  }
}

