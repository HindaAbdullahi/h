import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pmsmbileapp/utilis/colors.dart';
import '../../models/apartmrnt.dart';
import '../../service/services.dart';

class AddFloorScreen extends StatefulWidget {
  const AddFloorScreen({super.key});

  @override
  State<AddFloorScreen> createState() => _AddFloorScreenState();
}

class _AddFloorScreenState extends State<AddFloorScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController floorNameController = new TextEditingController();
  TextEditingController noOfUnitsController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();

  // loading state
  var saving = false;

  String? apartmentID = '';

  // The inital status value
  String _selectedStatus = 'available';


 
  _clear() {
    floorNameController.clear();
    noOfUnitsController.clear();
    setState(() {
      _selectedStatus = 'available';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new Floor'),
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
                        labelText: "Enter Floor Name...",
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.apartment),
                        ),
                      ),
                      validator: (value) {
                        // check if floor is empty
                        if (value == null || value.isEmpty) {
                          return "Please enter floor name";
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
                      controller: noOfUnitsController,
                      decoration: InputDecoration(
                        labelText: "Enter number of units...",
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.numbers),
                        ),
                      ),
                      validator: (value) {
                        // check if units is empty
                        if (value == null || value.isEmpty) {
                          return "Please enter number of units";
                        }
                        return null;
                      },
                    ),
                  ),
                  FutureBuilder(
                    future: ApartmentService.getAllApartments(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Apartment> floorApartments = snapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            hint: Text('Choose apartment'),
                            icon: Icon(Icons.apartment),
                            onChanged: (value) {
                              apartmentID = value;
                            },
                            validator: (value) {
                              // check if units is empty
                              if (value == null || value.isEmpty) {
                                return "Please choose apartment";
                              }
                              return null;
                            },
                            items: floorApartments
                                .map((apartment) => DropdownMenuItem(
                                      child: Text(apartment.name.toString()),
                                      value: apartment.id,
                                      enabled: apartment.status == 'available'
                                          ? true
                                          : false,
                                    ))
                                .toList(),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            hint: Text('No apartment found!'),
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
        print(floorNameController.text);
        print(noOfUnitsController.text);
        print(apartmentID);
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
                var res = await FloorService.createFloor(
                    floorName: floorNameController.text,
                    apartmentID: apartmentID,
                    noOfUnits: noOfUnitsController.text,
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
                  Navigator.pushNamed(context, 'floors');
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