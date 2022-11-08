import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Username extends ChangeNotifier {
  var url = "http://10.0.2.2:3400/getusers";

  String username = "";
  List<dynamic> list = [];

  void getName(String name, String password) async {
    try {
      var response = await http.post(Uri.parse(url),
          body: jsonEncode({"email": name, "password": password}),
          headers: {"content-type": "application/json"});

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var val = jsonDecode(response.body);
        list = val['data'];
        username = list[0]['email'];
      } else {
        return Future.error("Server error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
