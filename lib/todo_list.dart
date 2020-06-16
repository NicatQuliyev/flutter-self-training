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
    _getTodos(0);
  }

  _getTodos(int state){
    API.getTodos(state).then((response){
          setState(() {
            Iterable list = json.decode(response.body);
            todos = list.map((model) => Todo.fromJson(model)).toList();
          });
    });
  }

  List<Todo> todos = [
  ];

    TextEditingController controller = new TextEditingController();

  _toggleTodo(Todo todo, bool isChecked){
    todo.isDone = isChecked;
    API.updateTask(todo);
    _getTodos(0);
  }
  _removeTodo(Todo todo){
    setState(() {
      API.deleteTask(todo.id);
      _getTodos(0);
    });
  }
  _addToList(String title){
    setState(() {
      API.storeTodo(title);
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
              onPressed: null,
              child: Icon(
                Icons.edit,
                color: Colors.green,
              ),
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
      _addToList(todo.title);
      _getTodos(0);
    }
  }

  _editTodo() {

  }

  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

