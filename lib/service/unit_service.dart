import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pmsmbileapp/models/unit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilis/constants.dart';

class UnitService {
  static SharedPreferences? prefs;

  // Get jwt token
  static Future<String> getToken() async {
    // Get current logged in user token
    prefs = await SharedPreferences.getInstance();
    String token = prefs!.getString('token').toString();
    return token;
  }

  // Get all units
  static Future<List<Unit>> getAllUnits() async {
    // Send http request
    http.Response response = await http.get(
      Uri.parse(apiUrl + '/get-all-units'),
      headers: {'Authorization': await getToken()},
    );

    // Check if request is successful
    if (response.statusCode == 200) {
      // Get the json data
      List jsonResponse = await json.decode(response.body)['data'];

      return jsonResponse
          .map((unit) => Unit.fromJson(unit))
          .toList(); // Convert the json data to dart object
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

    // Get all floor units
  static Future<List<Unit>> getFloorUnits({String? id}) async {
    // Send http request
    http.Response response = await http.get(
      Uri.parse(apiUrl + '/get-floor-units/' + id!),
      headers: {'Authorization': await getToken()},
    );
    print(response.statusCode);

    // Check if request is successful
    if (response.statusCode == 200) {
      // Get the json data
      List jsonResponse = await json.decode(response.body)['data'];
      print(jsonResponse);

      return jsonResponse
          .map((unit) => Unit.fromJson(unit))
          .toList(); // Convert the json data to dart object
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  // Create unit
  static Future<http.Response> createUnit(
      {unitName, floorID, noOfRooms, status}) async {
    // unit data
    var unitData = {
      'unit': {
        'name': unitName,
        'noOfRooms': noOfRooms,
        'floor': floorID,
        'status': status
      }
    };

    // send create floor request
    http.Response response = await http.post(Uri.parse('${apiUrl}/create-unit'),
        body: json.encode(unitData),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": await getToken()
        });
    return response;
  }

  // Update apartment
  static Future<http.Response> updateUnit({data}) async {
    // Get passed data
    var apartmentData = {'unit': data};
    http.Response response = await http.put(Uri.parse(apiUrl + "/update-unit"),
        body: json.encode(apartmentData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': await getToken()
        });

    return response;
  } // Update unit

  // Delete unit
  static Future<http.Response> deleteUnit({id}) async {
    http.Response response = await http.delete(
        Uri.parse(apiUrl + "/delete-unit/${id}"),
        headers: {'Authorization': await getToken()});
    return response;
  } // Delete unit
} 