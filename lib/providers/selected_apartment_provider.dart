import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pmsmbileapp/models/apartmrnt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../utilis/constants.dart';

class SelectedApartment with ChangeNotifier {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  Apartment? apartment;
  List<Apartment>? apartmentList;

  setApartment(Apartment value) {
    apartment = value;
    notifyListeners();
  }

  SelectedApartment() {
    getAllApartment();
  }

  getAllApartment() async {
    var sharedPrefs = await prefs;

    http.Response response = await http
        .get(Uri.parse(apiUrl + '/get-all-apartments'), headers: {
      "Authorization": await sharedPrefs.getString('token').toString()
    });

    if (response.statusCode == 200) {
      List jsonResponse = await json.decode(response.body)['data'];

      apartmentList = jsonResponse
          .map((apartment) => Apartment.fromJson(apartment))
          .toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }
}