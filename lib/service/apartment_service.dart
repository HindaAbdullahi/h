import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/apartmrnt.dart';
import '../utilis/constants.dart';

class ApartmentService {
  static SharedPreferences? prefs;

  // Get jwt token
  static Future<String> getToken() async {
    // Get current logged in user token
    prefs = await SharedPreferences.getInstance();
    String token = prefs!.getString('token').toString();
    return token;
  }

  // Get all apartments
  static Future<List<Apartment>> getAllApartments() async {
    // Send http request
    http.Response response = await http.get(
      Uri.parse(apiUrl + '/get-all-apartments'),
      headers: {'Authorization': await getToken()},
    );

    // Check if request is successful
    if (response.statusCode == 200) {
      // Get the json data
      List jsonResponse = await json.decode(response.body)['data'];

      return jsonResponse
          .map((apartment) => Apartment.fromJson(apartment))
          .toList(); // Convert the json data to dart object
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  // Create apartment
  static Future<http.Response> createApartment(
      {apartmentName, noOfFloors, address, status}) async {
    // user data
    var apartmentData = {
      'apartment': {
        'name': apartmentName,
        'noOfFloors': noOfFloors,
        'address': address,
        'status': status
      }
    };

    // Send create apartment request
    http.Response response = await http.post(
        Uri.parse('${apiUrl}/create-apartment'),
        body: json.encode(apartmentData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': await getToken()
        });
    return response;
  }

  // Update apartment
  static Future<http.Response> updateApartment({data}) async {
    // Get passed data
    var apartmentData = {'apartment': data};
    http.Response response = await http.put(
        Uri.parse(apiUrl + "/update-apartment"),
        body: json.encode(apartmentData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': await getToken()
        });

    return response;
  } // Update apartment

  // Delete apartment
  static Future<http.Response> deleteApartment({id}) async {
    http.Response response = await http.delete(
        Uri.parse(apiUrl + "/delete-apartment/${id}"),
        headers: {'Authorization': await getToken()});
    return response;
  } // Delete apartment
}