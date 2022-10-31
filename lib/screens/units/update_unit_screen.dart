import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pmsmbileapp/providers/selected_apartment_provider.dart';
import 'package:pmsmbileapp/utilis/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UpdateUnitScreen extends StatefulWidget {
  String? id;
  String? name;
  String? noOfUnits;
  String? status;

  UpdateUnitScreen({
    super.key,
    this.id,
    this.name,
    this.noOfUnits,
    this.status,
  });

  @override
  State<UpdateUnitScreen> createState() => _UpdateUnitScreenState();
}

class _UpdateUnitScreenState extends State<UpdateUnitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dropdownFormFieldKey = GlobalKey<FormFieldState>();

  String? selectedApartementID;
  String? selectedApartmentName;

  TextEditingController floorNameController = new TextEditingController();
  TextEditingController noOfUnitsController = new TextEditingController();

  // loading state
  var updating = false;

  // The inital status value
  String _selectedStatus = 'available';

  // get all apartments
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  // Update floor
  _updateApartment({data}) async {
    var apartmentData = {'apartment': data};

    http.Response response = await http.put(
        Uri.parse(apiUrl + "/update-apartment"),
        body: json.encode(apartmentData),
        headers: {'Content-Type': 'application/json'});

    return response;
  }

  _initializeData() {
    floorNameController.text = widget.name.toString();
    noOfUnitsController.text = widget.noOfUnits.toString();
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
    var selectedApart = Provider.of<SelectedApartment>(context);
    selectedApartementID = selectedApart.apartment!.id;
    selectedApartmentName = selectedApart.apartment!.name;

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Floor'),
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
                      controller: floorNameController,
                      decoration: InputDecoration(
                        labelText: "Enter floor Name...",
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.apartment),
                        ),
                      ),
                      validator: (value) {
                        // check if username is empty
                        if (value == null || value.isEmpty) {
                          return "Please enter floor";
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
                            controller: noOfUnitsController,
                            decoration: InputDecoration(
                              labelText: "Enter number of units...",
                              icon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.numbers),
                              ),
                            ),
                            validator: (value) {
                              // check if username is empty
                              if (value == null || value.isEmpty) {
                                return "Please enter number of units";
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
                      hint: Text(selectedApartmentName!),
                      onChanged: (value) {
                        selectedApartementID = value;
                      },
                      validator: (value) {
                        // check if units is empty
                        if (value == null) {
                          return "Please choose apartment";
                        }
                        return null;
                      },
                      items: selectedApart.apartmentList!
                          .map((apartment) => DropdownMenuItem(
                                child: Text(apartment.name.toString()),
                                value: apartment.id,
                                enabled: apartment.status == 'available'
                                    ? true
                                    : false,
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
        print(floorNameController.text);
        print(noOfUnitsController.text);
        print(selectedApartementID);
        print(selectedApartmentName);
        print(_selectedStatus);

        // try {
        //   // Show loading spinner
        //   // _showSpinner();
        //   // Check internet connectivity
        //   final result = await InternetAddress.lookup('google.com');
        //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //     // check if login form is submitted
        //     // correctly
        //     if (_formKey.currentState!.validate()) {
        //       try {
        //         // show button circle progress indicator
        //         setState(() {
        //           updating = true;
        //         });

        //         // saving apartment
        //         var res = await _updateApartment(data: {
        //           "_id": widget.id,
        //           'apartmentName': apartmentNameController.text,
        //           'noOfFloors': noOfFloorsController.text,
        //           'address': addressController.text,
        //           'status': _selectedStatus
        //         });
        //         print(res.body);

        //         if (res.statusCode == 200) {
        //           // Check if there is an error
        //           String message = json.decode(res.body)['message'];
        //           _showSuccess(message: message);

        //           _clear();

        //           // hide button circle progress indicator
        //           setState(() {
        //             updating = false;
        //           });

        //           // Go to apartments screen
        //           Navigator.pushNamed(context, 'apartments');
        //           print('Success');
        //         } else {
        //           _showError(error: 'Something went wrong!');
        //         }
        //         // Navigator.pushNamed(context, 'home');
        //         print(json.decode(res.body)['error']);
        //       } catch (e) {
        //         print(e.toString());
        //         // Show error
        //         _showError(error: 'Error ${e.toString()}');
        //       }
        //     }
        //   }
        // } on SocketException catch (_) {
        //   // show internet error
        //   _showError(error: 'Not connected');
        // }
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