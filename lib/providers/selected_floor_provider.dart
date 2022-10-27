import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pmsmbileapp/models/floor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../utilis/constants.dart';

class SelectedFloor with ChangeNotifier {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  Floor? floor;
  List<Floor>? floorList;

  setApartment(Floor value) {
    floor = value;
    notifyListeners();
  }

  SelectedFloor() {
    getAllFloor();
  }

  getAllFloor() async {
    var sharedPrefs = await prefs;

    http.Response response = await http
        .get(Uri.parse(apiUrl + '/get-all-floors'), headers: {
      "Authorization": await sharedPrefs.getString('token').toString()
    });

    if (response.statusCode == 200) {
      List jsonResponse = await json.decode(response.body)['data'];

      floorList = jsonResponse
          .map((floor) => Floor.fromJson(floor))
          .toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }
}