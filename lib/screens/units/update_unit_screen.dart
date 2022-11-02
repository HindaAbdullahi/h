import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pmsmbileapp/providers/selected_apartment_provider.dart';
import 'package:pmsmbileapp/providers/selected_floor_provider.dart';
import 'package:pmsmbileapp/service/floor_service.dart';
import 'package:pmsmbileapp/service/unit_service.dart';
import 'package:pmsmbileapp/utilis/colors.dart';
import 'package:pmsmbileapp/utilis/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/floor.dart';

class UpdateUnitScreen extends StatefulWidget {
  String? id;
  String? name;
  String? noOfRooms;
  String? status;

  UpdateUnitScreen({
    super.key,
    this.id,
    this.name,
    this.noOfRooms,
    this.status,
  });

  @override
  State<UpdateUnitScreen> createState() => _UpdateUnitScreenState();
}

class _UpdateUnitScreenState extends State<UpdateUnitScreen> {
  final _formKey = GlobalKey<FormState>();

  late String selectedFloorID;
  late String selectedFloorName;

  TextEditingController unitNameController = new TextEditingController();
  TextEditingController noOfRoomsController = new TextEditingController();

  // loading state
  var updating = false;

  // The inital status value
  String _selectedStatus = 'available';


  // Update unit

  _initializeData() {
    unitNameController.text = widget.name.toString();
    noOfRoomsController.text = widget.noOfRooms.toString();
    _selectedStatus = widget.status.toString();
  }

  @override
  void initState() {
    super.initState();

    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    // Get unit floor using provider
    var selectedFloor = Provider.of<SelectedFloor>(context);
    selectedFloorID = selectedFloor.floor!.id.toString();
    selectedFloorName = selectedFloor.floor!.name.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Update unit'),
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
                        labelText: "Enter unit Name...",
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.apartment),
                        ),
                      ),
                      validator: (value) {
                        // check if username is empty
                        if (value == null || value.isEmpty) {
                          return "Please enter unit";
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
                            controller: noOfRoomsController,
                            decoration: InputDecoration(
                              labelText: "Enter number of rooms...",
                              icon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.numbers),
                              ),
                            ),
                            validator: (value) {
                              // check if username is empty
                              if (value == null || value.isEmpty) {
                                return "Please enter number of rooms";
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
                    child: FutureBuilder(
                        future: FloorService.getAllFloors(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return DropdownButtonFormField(
                              hint: Text(selectedFloorName),
                              onChanged: (value) {
                                selectedFloorID = value.toString();
                              },
                              items: snapshot.data!
                                  .map((floor) => DropdownMenuItem(
                                        child: Text(floor.name.toString()),
                                        value: floor.id,
                                        enabled: floor.status == 'available'
                                            ? true
                                            : false,
                                      ))
                                  .toList(),
                            );
                          } else if (snapshot.hasError) {
                            return DropdownButtonFormField(
                              items: [],
                              onChanged: (value) {},
                              hint: Text(snapshot.error.toString()),
                            );
                          }
                          return DropdownButtonFormField(
                              items: [],
                              onChanged: (value) {},
                              hint: Text(selectedFloorName));
                        }),
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
        print(widget.id);
        print(unitNameController.text);
        print(noOfRoomsController.text);
        print(selectedFloorID);
        print(selectedFloorName);
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
                var res = await UnitService.updateUnit(data: {
                  "_id": widget.id,
                  'name': unitNameController.text,
                  'noOfRooms': noOfRoomsController.text,
                  'floor': selectedFloorID,
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
                  Navigator.pushNamed(context, '/units');
                  print('Success');
                } else {
                  // hide button circle progress indicator
                  setState(() {
                    updating = false;
                  });
                  _showError(error: json.decode(res.body)['error']);
                }
                // Navigator.pushNamed(context, 'home');
                print(json.decode(res.body)['error']);
              } catch (e) {
                print(e.toString());
                setState(() {
                  updating = false;
                });
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