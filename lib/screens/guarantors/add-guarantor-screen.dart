import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pmsmbileapp/models/gurantorModel.dart';
import 'package:pmsmbileapp/screens/guarantors/guarantor.dart';
import '../../utilis/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AddGuarantorScreen extends StatefulWidget {
  const AddGuarantorScreen({super.key});

  @override
  State<AddGuarantorScreen> createState() => _AddGuarantorScreenState();
}

class _AddGuarantorScreenState extends State<AddGuarantorScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController guarantorNameController = new TextEditingController();
  TextEditingController guarantorPhoneController = new TextEditingController();
  TextEditingController guarantorAddressController =new TextEditingController();
  TextEditingController guarantorTitleController = new TextEditingController();
  // loading state
  var saving = false;

  // The inital status value
  String _selectedGender = 'female';
 Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  
  Future<List<Guarantor>> _getAllGuarantors() async {

    var sharedPrefs = await prefs;
    
    http.Response response = await http
        .get(Uri.parse(apiUrl + '/get-all-guarantors'), headers: {
      "Authorization": await sharedPrefs.getString('token').toString()
    });

    if (response.statusCode == 200) {
      List jsonResponse = await json.decode(response.body)['data'];

      return jsonResponse
          .map((guarantor) => Guarantor.fromJson(guarantor))
          .toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }
  // Create guarantor
  Future<http.Response> _createGuaranor(
      {name, phone, address, gender, title}) async {
         var sharedPrefs = await prefs;
    // user data
    var guarantorData = {
      'guarantor': {
        'name': name,
        'phone': phone,
        'address': address,
        'gender': gender,
        'title': title,
      }
    };

    // send create guarantor request
      http.Response response = await http.post(
        Uri.parse('${apiUrl}/create-guarantor'),
        body: json.encode(guarantorData),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": await sharedPrefs.getString('token').toString()
        });
    return response;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new Guarantor'),
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
                              labelText: "Enter phone...",
                              icon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.call),
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
        print(guarantorTitleController.text);
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
                  saving = true;
                });

                // saving guarantor
                var res = await _createGuaranor(
                    name: guarantorNameController.text,
                    phone: guarantorPhoneController.text,
                    address: guarantorAddressController.text,
                    gender: _selectedGender,
                    title: guarantorTitleController.text );
                print(res.body);

                if (res.statusCode == 200) {
                  // Check if there is an error
                  String message = json.decode(res.body)['message'];
                  _showSuccess(message: message);

                  _clear();

                  // hide button circle progress indicator
                  setState(() {
                    saving = false;
                  }); 
                  //button 
                  // Go to guarantor screen
                  Navigator.pushNamed(  context, 'guarantors');
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
