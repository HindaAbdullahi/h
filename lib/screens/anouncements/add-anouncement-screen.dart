import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';
import '../../utilis/constants.dart';

class AddAnouncementScreen extends StatefulWidget {
  const AddAnouncementScreen({super.key});

  @override
  State<AddAnouncementScreen> createState() => _AddAnouncementScreenState();
}

class _AddAnouncementScreenState extends State<AddAnouncementScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController anouncementNameController = new TextEditingController();
  TextEditingController anouncementmessageController = new TextEditingController();
  

  // loading state
  var saving = false;

  String? userID = '';

  // The inital status value
  String _selectedStatus = 'available';

  // get all apartments
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  Future<List<User>> _getAllUsers() async {
    var sharedPrefs = await prefs;

    http.Response response = await http
        .get(Uri.parse(apiUrl + '/get-all-users'), headers: {
      "Authorization": await sharedPrefs.getString('token').toString()
    });

    if (response.statusCode == 200) {
      List jsonResponse = await json.decode(response.body)['data'];

      return jsonResponse
          .map((user) => User.fromJson(user))
          .toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  // Create floor
  Future<http.Response> _createAnouncement(
      {anouncementName, userID, message, status}) async {
    var sharedPrefs = await prefs;

    // floor data
    var anouncementData = {
      'anouncement': {
        'name': anouncementName,
        'message': message,
        'user': userID,
        'status': status
      }
    };

    // send create anouncement request
    http.Response response = await http.post(
        Uri.parse('${apiUrl}/create-anouncement'),
        body: json.encode(anouncementData),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": await sharedPrefs.getString('token').toString()
        });
    return response;
  }

  _clear() {
    anouncementNameController.clear();
    anouncementmessageController.clear();
    setState(() {
      _selectedStatus = 'available';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new anouncement'),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(padding: const EdgeInsets.only(top: 10)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: anouncementNameController,
                      decoration: InputDecoration(
                        labelText: "Enter anouncement Name...",
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.apartment),
                        ),
                      ),
                      validator: (value) {
                        // check if floor is empty
                        if (value == null || value.isEmpty) {
                          return "Please enter anouncement name";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: anouncementmessageController,
                      decoration: InputDecoration(
                        labelText: "Enter message of anouncements...",
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.numbers),
                        ),
                      ),
                      validator: (value) {
                        // check if units is empty
                        if (value == null || value.isEmpty) {
                          return "Please enter message of anouncement";
                        }
                        return null;
                      },
                    ),
                  ),
                  FutureBuilder(
                    future: _getAllUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<User> anouncementuser = snapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            hint: Text('Choose user'),
                            icon: Icon(Icons.apartment),
                            onChanged: (value) {
                              userID = value.toString();
                            },
                            validator: (value) {
                              // check if units is empty
                              if (value == null || value.isEmpty) {
                                return "Please choose apartment";
                              }
                              return null;
                            },
                            items: anouncementuser
                                .map((user) => DropdownMenuItem(
                                      child: Text(user.name.toString()),
                                      value: user.id,
                                     
                                    ))
                                .toList(),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            hint: Text('No anouncement found!'),
                            icon: Icon(Icons.apartment),
                            onChanged: null,
                            items: [],
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField(
                          hint: Text('Loading....'),
                          onChanged: null,
                          items: [],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: const Text(
                            'Status:',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: ListTile(
                          leading: Radio<String>(
                            value: 'available',
                            groupValue: _selectedStatus,
                            onChanged: (value) {
                              setState(() {
                                _selectedStatus = value!;
                              });
                            },
                          ),
                          title: const Text(
                            'Available',
                            textAlign: TextAlign.justify,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: ListTile(
                          leading: Radio<String>(
                            value: 'occupied',
                            groupValue: _selectedStatus,
                            onChanged: (value) {
                              setState(() {
                                _selectedStatus = value!;
                              });
                            },
                          ),
                          title: const Text(
                            'Occupied',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _submitButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: (() async {
        print(anouncementNameController.text);
        print(anouncementmessageController.text);
        print(userID);
        print(_selectedStatus);

        try {
          // Check internet connectivity
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            // check if login form is submitted
            // correctly
            if (_formKey.currentState!.validate()) {
              try {
                // show button circle progress indicator
                setState(() {
                  saving = true;
                });

                // saving apartment
                var res = await _createAnouncement(
                    anouncementName: anouncementNameController.text,
                    userID: userID,
                    message: anouncementmessageController.text,
                    status: _selectedStatus);

                if (res.statusCode == 200) {
                  // Check if there is an error
                  String message = json.decode(res.body)['message'];
                  _showSuccess(message: message);

                  _clear();

                  // hide button circle progress indicator
                  setState(() {
                    saving = false;
                  });

                  // Go to apartments screen
                  Navigator.pushNamed(context, 'anouncements');
                } else {
                  setState(() {
                    saving = false;
                  });
                  _showError(error: '${res.statusCode}');
                }
                // Navigator.pushNamed(context, 'home');
                print(json.decode(res.body)['error']);
              } catch (e) {
                print(e.toString());
                // Show error
                _showError(error: 'Error ${e.toString()}');
              }
            }
          }
        } on SocketException catch (_) {
          // show internet error
          _showError(error: 'Not connected');
        }
      }),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 15),
        padding: EdgeInsets.all(15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade300,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.blueGrey, Color.fromARGB(255, 194, 194, 194)])),
        child: saving
            ? CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                'Save',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
      ),
    );
  }

  // show error in scaffold
  _showError({error}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        dismissDirection: DismissDirection.up,
        content: Text(error),
      ),
    );
  }

  // show success in scaffold
  _showSuccess({message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
        dismissDirection: DismissDirection.up,
        content: Text(message),
      ),
    );
  }
}