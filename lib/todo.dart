class Todo {
  Todo({this.title, this.isDone = false});

  int id;
  String title;
  bool isDone;

  Todo.fromJson(Map<String, dynamic> json)
    :
    id = json['id'],
    title  = json['title'],
    isDone = false;

  Map toJson(){
    return {'id': id,'title': title, 'isDone': isDone};
  }
}