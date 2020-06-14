import 'dart:async';
import 'package:http/http.dart' as http;

const baseUrl = "https://jsonplaceholder.typicode.com/";

class API {
  static Future getTodos() {
    var url = baseUrl + "todos";
    return http.get(url);
  }
}