// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print
// import 'dart:convert';

// ignore_for_file: unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:prpertymanagementapp/models/user.dart';

import '../../utilis/constants.dart';

import 'package:flutter/material.dart';

import '../../widgets/bezierContainer.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool? hidePass;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  // Login
  Future<http.Response> _login({username, password}) async {
    // user data
    var userData = {
      "user": {'emailOrUsername': username, 'password': password}
    };
    print(userData);

    // send login request
    http.Response response = await http.post(Uri.parse('${apiUrl}/auth/login'),
        body: json.encode(userData),
        headers: {'Content-Type': 'application/json'});
    return response;
  }

  // clear text fields
  void _clear() {
    emailController.clear();
    passwordController.clear();
  }

  @override
  void initState() {
    hidePass = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SizedBox(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  _title(),
                  SizedBox(height: 50),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Material(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                            elevation: 3,
                            child: TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.black),
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                ),
                                labelText: 'Enter your username',
                              ),
                              validator: (value) {
                                // check if username is empty
                                if (value == null || value.isEmpty) {
                                  return "Please enter username";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Material(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                            elevation: 3,
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: hidePass!,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.key),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (hidePass == true) {
                                          hidePass = false;
                                        } else {
                                          hidePass = true;
                                        }
                                      });
                                    },
                                    icon: hidePass!
                                        ? Icon(Icons.visibility)
                                        : Icon(Icons.visibility_off)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0))),
                                labelText: 'Enter your password',
                              ),
                              validator: (value) {
                                // check if password is empty
                                if (value == null || value.isEmpty) {
                                  return "Please enter password";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  _submitButton(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: Text('Forgot Password?',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  _divider(),
                  _signUpContent(),
                  SizedBox(height: height * .055),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: (() async {
        print(emailController.text);
        print(passwordController.text);

        try {
          // Show loading spinner
          _showSpinner();
          // check if login form is submitted
          // correctly
          if (!_formKey.currentState!.validate()) {
            return;
          }
          try {
            // login
            var res = await _login(
              username: emailController.text,
              password: passwordController.text,
            );
            if (res.statusCode == 200) {
              print(res.statusCode);
              // get the token
              var token = json.decode(res.body)['token'];

              // Obtain Share preferences object
              final prefs = await SharedPreferences.getInstance();

              prefs.setString('token', token);

              print('token: ' + token);
              print(
                  'stored token: ' + await prefs.getString('token').toString());

              // Hide loading spinner
              Navigator.of(context).pop();

              _clear();

              // Go to dashboard
              Navigator.pushNamed(context, 'home');
              print('Success');
            } else {
              _showError(error: 'Error ${json.decode(res.body)['token']}');
            }
          } catch (e) {
            print(e.toString());
            // Show error
            _showError(error: 'Error ${e.toString()}');
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
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _signUpContent() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Does not have an account?',
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 15,
              color: Colors.blueGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'P',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.blueGrey),
          children: [
            TextSpan(
              text: 'M',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'S',
              style: TextStyle(color: Colors.blueGrey, fontSize: 30),
            ),
          ]),
    );
  }

  _showSpinner() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // CircularProgressIndicator(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        color: Colors.white,
                        child: SpinKitCircle(
                          color: Colors.blueGrey[700],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
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
}
