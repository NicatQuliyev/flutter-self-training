import 'dart:async';
import 'package:http/http.dart' as http;

const baseUrl = "http://notronsoft.000webhostapp.com/";

class API {
  static Future getTodos() {
    var url = baseUrl + "tasks.php";
    return http.get(url);
  }
}