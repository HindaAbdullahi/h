import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pmsmbileapp/models/floor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilis/constants.dart';

class FloorService {
  static SharedPreferences? prefs;

// Get jwt token
  static Future<String> getToken() async {
// Get current logged in user token
    prefs = await SharedPreferences.getInstance();
    String token = prefs!.getString('token').toString();
    return token;
  }

  // Get all floors
  static Future<List<Floor>> getAllFloors() async {
    // Send http request
    http.Response response = await http.get(
      Uri.parse(apiUrl + '/get-all-floors'),
      headers: {'Authorization': await getToken()},
    );

    // Check if request is successful
    if (response.statusCode == 200) {
      // Get the json data
      List jsonResponse = await json.decode(response.body)['data'];

      return jsonResponse
          .map((floor) => Floor.fromJson(floor))
          .toList(); // Convert the json data to dart object
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  // Get all apartment floors
  static Future<List<Floor>> getApartmentFloors({String? id}) async {
    // Send http request
    http.Response response = await http.get(
      Uri.parse(apiUrl + '/get-apartment-floors/' + id!),
      headers: {'Authorization': await getToken()},
    );
    print(response.statusCode);

    // Check if request is successful
    if (response.statusCode == 200) {
      // Get the json data
      List jsonResponse = await json.decode(response.body)['data'];
      print(jsonResponse);

      return jsonResponse
          .map((floor) => Floor.fromJson(floor))
          .toList(); // Convert the json data to dart object
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  // Create floor
  static Future<http.Response> createFloor(
      {floorName, apartmentID, noOfUnits, status}) async {
    // floor data
    var floorData = {
      'floor': {
        'name': floorName,
        'noOfUnits': noOfUnits,
        'apartment': apartmentID,
        'status': status
      }
    };

    // send create floor request
    http.Response response = await http.post(
        Uri.parse('${apiUrl}/create-floor'),
        body: json.encode(floorData),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": await getToken()
        });
    return response;
  }

  // Update floor
  static Future<http.Response> updateFloor({data}) async {
    // Get passed data
    var apartmentData = {'floor': data};
    http.Response response = await http.put(Uri.parse(apiUrl + "/update-floor"),
        body: json.encode(apartmentData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': await getToken()
        });

    return response;
  } // Update floor

  // Delete floor
  static Future<http.Response> deleteFloor({id}) async {
    http.Response response = await http
        .delete(Uri.parse(apiUrl + "/delete-floor/${id}"), headers: {
      'Content-Type': 'application/json',
      'Authorization': await getToken()
    });
    return response;
  } // Delete floor
}