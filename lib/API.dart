import 'dart:async';
import 'dart:convert';
import 'package:first_flutter_app/todo.dart';
import 'package:http/http.dart' as http;

const baseUrl = "http://23.102.178.205:8080/api/v1/";
const headers = <String, String>{
  'Content-Type': 'application/json; charset=UTF-8'
};

class API {
  static Future getTodos(int state) {
    var url = baseUrl + "tasks/?isdone=${state}";
    return http.get(url);
  }

  static Future storeTodo(String title)
  {
    var url = baseUrl + "tasks";
    return http.post(
      url,
      headers: headers,
      body: jsonEncode(<String, String>{
        'title': title
      })
    );
  }

  static Future deleteTask(int id)
  {
    var url = baseUrl + "tasks/${id}";
    return http.delete(url);
  }

  static Future updateTask(Todo todo)
  {
    var url = baseUrl+"tasks";
    return http.put(
      url,
      headers: headers,
      body: jsonEncode(todo)
    );
  }

}