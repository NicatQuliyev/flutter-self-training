import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:first_flutter_app/todo.dart';
import 'API.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class DateFiled extends StatelessWidget {
final format = DateFormat("yyyy-MM-dd");
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text('Date (${format.pattern})'),
      DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
      ),
    ]);
  }
}

class _TodoListState extends State<TodoList> {

  initState(){
    super.initState();
     _getTodos(0);
  }

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

  List<Todo> todos = [
  ];
  Todo selectedTodo;
  Future todo_future;

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
      API.deleteTask(todo.id).then((value) => {
        _getTodos(0)
      });
    final snackbar = SnackBar(content: Text("Removed: ${todo.title}"), backgroundColor: Colors.red);
    Scaffold.of(context).showSnackBar(snackbar);
  }
  _addToList(String title){
      API.storeTodo(title).then((value) => {
        _getTodos(0)
      });
    final snackbar = SnackBar(content: Text("Added: $title"), backgroundColor: Colors.greenAccent);
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
    return new Container(
        child : new Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.alarm, color: Colors.blue),
                title: Text(todo.title),
                subtitle: Text("${todo.created_at}"),
              ),
              new ButtonBar(
                children:[
                  new IconButton( // Mark as done button
                      icon: Icon(Icons.check_circle_outline, color: Colors.green),
                      onPressed: (){
                        _toggleTodo(todo, true);
                      }
                  ),
                new IconButton( //Edit button
                    onPressed: () {
                      setState(() {
                        selectedTodo = todo;
                      });
                      editController.text = selectedTodo.title;
                      _editTodo();
                    },
                    icon: Icon(
                      Icons.mode_edit,
                      color: Colors.orange,
                    ),
                  ),
                  new IconButton( //Delete button
                      icon: Icon(Icons.remove_circle, color: Colors.red,),
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
                  )
                ]
              )
            ],
          ),
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
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Colors.blueGrey[800],
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
            return CircularProgressIndicator(backgroundColor: Colors.transparent,valueColor:  new AlwaysStoppedAnimation<Color>(Colors.yellow),);
          },
        ),
      ),
      bottomNavigationBar: new BottomAppBar(
        color: Colors.blueGrey[700],
        shape: CircularNotchedRectangle(),
        child: Row(
          children: [
            IconButton(icon: Icon(Icons.menu, color: Colors.transparent, size: 32.0), onPressed: null),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Center(
          child: Icon(Icons.add, size: 32.0,),
        ),
        backgroundColor: Colors.blueGrey[700],
        foregroundColor: Colors.white,
        onPressed: (){
          _addTodo();
        },
      ),
    );
  }
}

