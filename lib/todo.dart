class Todo {
  Todo({this.title, this.isDone = false});

  String title;
  bool isDone;

  Todo.fromJson(Map json)
    : title  = json['title'],
    isDone = false;

  Map toJson(){
    return {'title': title, 'isDone': isDone};
  }
}