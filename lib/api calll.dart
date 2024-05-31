import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class apiCall {
  api() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var request =
        http.Request("GET", Uri.parse("https://reqres.in/api/users?page=2"));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var s = json.encode(response.toString());
      await prefs.setString('musics_key', s);
      print("dope");
      print(response);
      print(json.decode(s));
    } else {
      print("try agai");
    }
  }
}
