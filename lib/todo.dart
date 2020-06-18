class Todo {
  Todo({this.title, this.isDone = false});

  int id;
  String title;
  bool isDone;
  String created_at;

  Todo.fromJson(Map<String, dynamic> json)
    :
    id = json['id'],
    title  = json['title'],
    isDone = false,
    created_at = json['created_at'];

  Map toJson(){
    return {'id': id,'title': title, 'isDone': isDone, 'created_at': created_at};
  }
}