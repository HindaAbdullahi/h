import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:pmsmbileapp/models/gurantorModel.dart';
import 'package:pmsmbileapp/service/services.dart';

import '../../utilis/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
class UpdateGuarantorScreen extends StatefulWidget {
  String? id;
  String? guarantorName;
  String? phone;
  String? address;
  String? status;
  String? title;
  UpdateGuarantorScreen({
    super.key,
    this.id,
    this.guarantorName,
    this.phone,
    this.address,
    this.status,
    this.title,
  });

  @override
  State<UpdateGuarantorScreen> createState() => _UpdateGuarantorScreenState();
}

class _UpdateGuarantorScreenState extends State<UpdateGuarantorScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController guarantorNameController = new TextEditingController();
  TextEditingController guarantorPhoneController = new TextEditingController();
  TextEditingController guarantorAddressController =
      new TextEditingController();
  TextEditingController guarantorTitleController = new TextEditingController();

  // loading state
  var updating = false;

  // The inital status value
  String _selectedGender = 'female';
// Future<SharedPreferences> prefs = SharedPreferences.getInstance();

// Future<List<Guarantor>> _getAllGuarantors() async {
//     // get user token
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     http.Response response = await http.get(
//         Uri.parse(apiUrl + '/get-all-guarantor'),
//         headers: {'Authorization': prefs.getString('token').toString()});

//     if (response.statusCode == 200) {
//       List jsonResponse = await json.decode(response.body)['data'];

//       return jsonResponse.map((guarantor) => Guarantor.fromJson(guarantor))
//           .toList();
//     } else {
//       throw Exception('Unexpected error occured!');
//     }
//   }
//   // Update apartment
//   _updateGuarantor({data}) async {
//       var sharedPrefs = await prefs;
//     var guarantorData = {'guarantor': data};
//     http.Response response = await http.put(
//         Uri.parse(apiUrl + "/update-guarantor"),
//         body: json.encode(guarantorData),
//       headers: {  'Content-Type': 'application/json',
//         'Authorization': await sharedPrefs.getString('token')!});
//     return response;
//   }
 
  _initializeData() {
    guarantorNameController.text = widget.guarantorName.toString();
    guarantorPhoneController.text = widget.phone.toString();
    guarantorAddressController.text = widget.address.toString();
    _selectedGender = widget.status.toString();
    guarantorTitleController.text = widget.title.toString();
  }

  _clear() {
    guarantorNameController.clear();
    guarantorPhoneController.clear();
    guarantorAddressController.clear();
    setState(() {
      _selectedGender = 'female';
    });
    guarantorTitleController.clear();
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Guarantor'),
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
                      controller: guarantorNameController,
                      decoration: InputDecoration(
                        labelText: "Enter Guarantor Name...",
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.apartment),
                        ),
                      ),
                      validator: (value) {
                        // check if username is empty
                        if (value == null || value.isEmpty) {
                          return "Please enter guarantor";
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
                            controller: guarantorPhoneController,
                            decoration: InputDecoration(
                              labelText: "Enter phone  ...",
                              icon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.numbers),
                              ),
                            ),
                            validator: (value) {
                              // check if username is empty
                              if (value == null || value.isEmpty) {
                                return "Please enter phone number";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: guarantorAddressController,
                            decoration: InputDecoration(
                              labelText: "Enter Address...",
                              icon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.place),
                              ),
                            ),
                            validator: (value) {
                              // check if username is empty
                              if (value == null || value.isEmpty) {
                                return "Please enter address";
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
                            value: 'female',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                          ),
                          title: const Text(
                            'female',
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
                            value: 'male',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                          ),
                          title: const Text(
                            'male',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //end title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: guarantorTitleController,
                            decoration: InputDecoration(
                              labelText: "Enter title  ...",
                              icon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.person),
                              ),
                            ),
                            validator: (value) {
                              // check if username is empty
                              if (value == null || value.isEmpty) {
                                return "Please enter title ";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

//end title
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
        print(guarantorNameController.text);
        print(guarantorPhoneController.text);
        print(guarantorAddressController.text);
        print(_selectedGender);
        print(guarantorAddressController.text);
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
                var res = await GuarantorService.updateGuarantor(data: {
                  "_id": widget.id,
                  'guarantorName': guarantorNameController.text,
                  'phone': guarantorPhoneController.text,
                  'address': guarantorAddressController.text,
                  'status': _selectedGender,
                   'title': guarantorTitleController.text,
                });
                print(res.body);

                if (res.statusCode == 200) {
                  // Check if there is an error
                  String message = json.decode(res.body)['message'];
                  _showSuccess(message: message);

                  _clear();

                  // hide button circle progress indicator
                  setState(() {
                    updating = false;
                  });

                  // Go to apartments screen
                  Navigator.pushNamed(context, 'guarantors');
                  print('Success');
                } else {
                  _showError(error: 'Something went wrong!');
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