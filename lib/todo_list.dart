import 'package:flutter/material.dart';
import 'package:first_flutter_app/todo.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
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

  Widget _buildItem(BuildContext context, int index) {
    final todo = todos[index];

    return CheckboxListTile(
      value:todo.isDone,
      title: Text(todo.title),
      onChanged: (bool isChecked) {
        _toggleTodo(todo, isChecked);
      },
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
      setState(() {
        todos.add(todo);
      });
    }
  }

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
        onPressed: _addTodo,
      ),
    );
  }
}

