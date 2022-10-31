import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pmsmbileapp/providers/selected_userAnouncement_provider.dart';
import 'package:pmsmbileapp/utilis/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';

class UpdateAnouncementScreen extends StatefulWidget {
  String? id;
  String? name;
  String? message;
  String? status;

  UpdateAnouncementScreen({
    super.key,
    this.id,
    this.name,
    this.message,
    this.status,
  });

  @override
  State<UpdateAnouncementScreen> createState() => _UpdateAnouncementScreenState();
}

class _UpdateAnouncementScreenState extends State<UpdateAnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dropdownFormFieldKey = GlobalKey<FormFieldState>();

  String? selectedUserID;
  String? selectedUserName;

  TextEditingController anouncementNameController = new TextEditingController();
  TextEditingController anouncementmessageController = new TextEditingController();

  // loading state
  var updating = false;

  // The inital status value
  String _selectedStatus = 'available';

  // get all apartments
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  // Update anouncement
  _updateUser({data}) async {
    var sharedPrefs = await prefs;

    var userData = {'anouncement': data};

    http.Response response = await http.put(
      Uri.parse(apiUrl + "/update-anouncement"),
      body: json.encode(userData),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": await sharedPrefs.getString('token').toString()
      },
    );

    return response;
  }

  _initializeData() {
    anouncementNameController.text = widget.name.toString();
    anouncementmessageController.text = widget.message.toString();
    _selectedStatus = widget.status.toString();
  }

  @override
  void initState() {
    super.initState();

    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    // Get floor apartment using provider
    var selectedUse = Provider.of<SelectedUser>(context);
    selectedUserID = selectedUse.user!.id;
    selectedUserName = selectedUse.user!.name;

    return Scaffold(
      appBar: AppBar(
        title: Text('Update anouncement'),
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
                        // check if username is empty
                        if (value == null || value.isEmpty) {
                          return "Please enter anouncement";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: anouncementmessageController,
                            decoration: InputDecoration(
                              labelText: "Enter message of anouncement...",
                              icon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.numbers),
                              ),
                            ),
                            validator: (value) {
                              // check if username is empty
                              if (value == null || value.isEmpty) {
                                return "Please enter message of anouncement...";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField(
                      hint: Text(selectedUserName!),
                      onChanged: (value) {
                        selectedUserID = value.toString();
                      },
                      // validator: (value) {
                      //   // check if units is empty
                      //   if (value == null) {
                      //     return "Please choose apartment";
                      //   }
                      //   return null;
                      // },
                      items: selectedUse.userList!
                          .map((user) => DropdownMenuItem(
                                child: Text(user.name.toString()),
                                value: user.id,
                                // enabled: user.status == 'available'
                                //     ? true
                                //     : false,
                              ))
                          .toList(),
                    ),
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
        print(widget.id);
        print(anouncementNameController.text);
        print(anouncementmessageController.text);
        print(selectedUserID);
        print(selectedUserName);
        print(_selectedStatus);

        try {
          // Show loading spinner
          // _showSpinner();
          // Check internet connectivity
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            // check if login form is submitted
            // correctly
            if (_formKey.currentState!.validate()) {
              try {
                // show button circle progress indicator
                setState(() {
                  updating = true;
                });

                // saving apartment
                var res = await _updateUser(data: {
                  "_id": widget.id,
                  'name': anouncementNameController.text,
                  'message': anouncementmessageController.text,
                  "user": selectedUserID,
                  'status': _selectedStatus
                });
                print(res.body);

                if (res.statusCode == 200) {
                  // Check if there is an error
                  String message = json.decode(res.body)['message'];
                  _showSuccess(message: message);

                  // hide button circle progress indicator
                  setState(() {
                    updating = false;
                  });

                  // Go to apartments screen
                  Navigator.pushNamed(context, 'anouncements');
                  print('Success');
                } else {
                  _showError(error: json.decode(res.body)['error']);

                  // hide button circle progress indicator
                  setState(() {
                    updating = false;
                  });
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
        child: updating
            ? CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                'update',
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