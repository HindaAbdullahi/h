import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pmsmbileapp/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../utilis/constants.dart';

class SelectedUser with ChangeNotifier {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  User? user;
  List<User>? userList;

  setUser(User value) {
    user = value;
    notifyListeners();
  }

  SelectedUser() {
    getAllUser();
  }

  getAllUser() async {
    var sharedPrefs = await prefs;

    http.Response response = await http
        .get(Uri.parse(apiUrl + '/get-all-users'), headers: {
      "Authorization": await sharedPrefs.getString('token').toString()
    });

    if (response.statusCode == 200) {
      List jsonResponse = await json.decode(response.body)['data'];

      userList = jsonResponse
          .map((user) => User.fromJson(user))
          .toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }
}