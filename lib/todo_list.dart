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
            todo_future = API.getTodos(0);
            Iterable list = json.decode(response.body);
            todos = list.map((model) => Todo.fromJson(model)).toList();
          });
    });
  }

  List<Todo> todos = [
  ];
  Todo selectedTodo = null;
  Future todo_future = null;

    TextEditingController controller = new TextEditingController();
    TextEditingController editController = new TextEditingController();

  _toggleTodo(Todo todo, bool isChecked){
    todo.isDone = isChecked;
    API.updateTask(todo);
    setState(() {
      todo_future = null;
    });
    todos.clear();
    _getTodos(0);
    final snackbar = SnackBar(content: Text("Done: ${todo.title}"), backgroundColor: Colors.greenAccent);
    Scaffold.of(context).showSnackBar(snackbar);
  }
  _removeTodo(Todo todo){
    setState(() {
      API.deleteTask(todo.id);
      _getTodos(0);
    });
    final snackbar = SnackBar(content: Text("Removed: ${todo.title}"), backgroundColor: Colors.red);
    Scaffold.of(context).showSnackBar(snackbar);
  }
  _addToList(String title){
    setState(() {
      API.storeTodo(title);
    });
    final snackbar = SnackBar(content: Text("Added: ${title}"), backgroundColor: Colors.greenAccent);
    Scaffold.of(context).showSnackBar(snackbar);
  }

  _editTodo() async{
    final todo = await showDialog<Todo>(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Edit todo"),
            content: TextField(
              controller: editController,
              autofocus: true,
              onSubmitted: (str){
                final todo = new Todo(title: str);
                controller.clear();
                Navigator.of(context).pop(todo);
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Save"),
                onPressed: (){
                  final todo = new Todo(title: editController.value.text);
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
        todo_future = null;
      });
      todos.clear();
      setState(() {
        selectedTodo.title = editController.text;
      });
      API.updateTask(selectedTodo);
      final snackbar = SnackBar(content: Text("Edited: ${todo.title}"), backgroundColor: Colors.greenAccent);
      Scaffold.of(context).showSnackBar(snackbar);
      _getTodos(0);
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    final todo = todos[index];
    return ListTile(
      onTap: null,
      title: new Row(
        children: <Widget>[
          new Expanded(child: new Text(todo.title)),

          new IconButton(
              icon: Icon(Icons.done_all, color: Colors.green),
              onPressed: (){
                _toggleTodo(todo, true);
              }
          ),
          new IconButton(
              onPressed: () {
                setState(() {
                  selectedTodo = todo;
                });
                editController.text = selectedTodo.title;
                _editTodo();
              },
              icon: Icon(
                Icons.edit,
                color: Colors.green,
              ),
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
        todo_future = null;
      });
      todos.clear();
      _addToList(todo.title);
      _getTodos(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: todo_future,
          builder: (context, snapshot){
            if(snapshot.hasData)
              {
                return ListView.builder(
                  itemBuilder: _buildItem,
                  itemCount: todos.length,
                );
              }
            return CircularProgressIndicator();
          },
        ),
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

