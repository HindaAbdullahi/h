import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/gurantorModel.dart';
import '../utilis/constants.dart';

class GuarantorService {
  static SharedPreferences? prefs;

  // Get jwt token
  static Future<String> getToken() async {
    // Get current logged in user token
    prefs = await SharedPreferences.getInstance();
    String token = prefs!.getString('token').toString();
    return token;
  }

  // Get all apartments
  static Future<List<Guarantor>> getAllGuarantors() async {
    // Send http request
    http.Response response = await http.get(
      Uri.parse(apiUrl + '/get-all-guarantors'),
      headers: {'Authorization': await getToken()},
    );

    // Check if request is successful
    if (response.statusCode == 200) {
      // Get the json data
      List jsonResponse = await json.decode(response.body)['data'];

      return jsonResponse
          .map((guarantor) => Guarantor.fromJson(guarantor))
          .toList(); // Convert the json data to dart object
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  // Create apartment
  static Future<http.Response> createGuarantor(
      {guarantorName, phone, address, gender,title}) async {
    // user data
    var guarantorData = {
      'guarantor': {
        'name': guarantorName,
        'phone': phone,
        'address': address,
        'gender': gender,
        'title': title,
      }
    };

    // Send create apartment request
    http.Response response = await http.post(
        Uri.parse('${apiUrl}/create-guarantor'),
        body: json.encode(guarantorData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': await getToken()
        });
    return response;
  }

  // Update apartment
  static Future<http.Response> updateGuarantor({data}) async {
    // Get passed data
    var guarantorData = {'guarantor': data};
    http.Response response = await http.put(
        Uri.parse(apiUrl + "/update-guarantor"),
        body: json.encode(guarantorData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': await getToken()
        });

    return response;
  } // Update apartment

  // Delete apartment
  static Future<http.Response> deleteGuarantor({id}) async {
    http.Response response = await http.delete(
        Uri.parse(apiUrl + "/delete-guarantor/${id}"),
        headers: {'Authorization': await getToken()});
    return response;
  } // Delete apartment
}