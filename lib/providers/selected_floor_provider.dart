import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/floor.dart';
import '../utilis/constants.dart';

class SelectedFloor with ChangeNotifier {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  Floor? floor;
  List<Floor>? floorList;

  setFLoor(Floor value) {
    floor = value;
    notifyListeners();
  }



  
}