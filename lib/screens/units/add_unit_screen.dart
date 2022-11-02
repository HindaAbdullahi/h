import 'dart:convert';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:pmsmbileapp/models/floor.dart';
import 'package:pmsmbileapp/utilis/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/apartmrnt.dart';
import '../../service/floor_service.dart';
import '../../service/unit_service.dart';
import '../../utilis/constants.dart';

class AddUnitScreen extends StatefulWidget {
  const AddUnitScreen({super.key});

  @override
  State<AddUnitScreen> createState() => _AddUnitScreenState();
}

class _AddUnitScreenState extends State<AddUnitScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController unitNameController = new TextEditingController();
  TextEditingController noOfRoomsController = new TextEditingController();

  // loading state
  var saving = false;

  String floorID = '';

  // The inital status value
  String _selectedStatus = 'available';

  // get all apartments
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();





  _clear() {
    unitNameController.clear();
    noOfRoomsController.clear();
    setState(() {
      _selectedStatus = 'available';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new Unit'),
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
                      controller: unitNameController,
                      decoration: InputDecoration(
                        labelText: "Enter Unit Name...",
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.apartment),
                        ),
                      ),
                      validator: (value) {
                        // check if floor is empty
                        if (value == null || value.isEmpty) {
                          return "Please enter unit name";
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
                      controller: noOfRoomsController,
                      decoration: InputDecoration(
                        labelText: "Enter number of rooms...",
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.numbers),
                        ),
                      ),
                      validator: (value) {
                        // check if units is empty
                        if (value == null || value.isEmpty) {
                          return "Please enter number of rooms";
                        }
                        return null;
                      },
                    ),
                  ),
                  FutureBuilder(
                    future: FloorService.getAllFloors(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Floor> unitFloors = snapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            hint: Text('Choose floor'),
                            icon: Icon(Icons.apartment),
                            onChanged: (value) {
                              floorID = value.toString();
                            },
                            validator: (value) {
                              // check if units is empty
                              if (value == null || value.isEmpty) {
                                return "Please choose floor";
                              }
                              return null;
                            },
                            items: unitFloors
                                .map((apartment) => DropdownMenuItem(
                                      child: Text(apartment.name.toString()),
                                      value: apartment.id,
                                    ))
                                .toList(),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            hint: Text('No floor found!'),
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
                          tileColor: AppColors.backgroundColor1,
                          leading: Radio<String>(
                            activeColor: AppColors.primary,
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
                          tileColor: AppColors.backgroundColor1,
                          leading: Radio<String>(
                            activeColor: AppColors.primary,
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
        print(unitNameController.text);
        print(noOfRoomsController.text);
        print(floorID);
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
                var res = await UnitService.createUnit(
                    unitName: unitNameController.text,
                    floorID: floorID,
                    noOfRooms: noOfRoomsController.text,
                    status: _selectedStatus);

                if (res.statusCode == 200) {
                  // Check if there is an error
                  String message = json.decode(res.body)['message'];
                  _clear();

                  // hide button circle progress indicator
                  setState(() {
                    saving = false;
                  });

                  CoolAlert.show(
                    context: context,
                    backgroundColor: AppColors.backgroundColor1,
                    confirmBtnColor: AppColors.primary,
                    onConfirmBtnTap: () => // Go to apartments screen
                        Navigator.pushNamed(context, 'units'),
                    type: CoolAlertType.success,
                    title: 'Success!',
                    text: message,
                  );

                  
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
          color: AppColors.primary,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
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