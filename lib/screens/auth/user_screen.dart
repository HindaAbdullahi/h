// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:pmsmbileapp/utilis/constants.dart';
import 'package:pmsmbileapp/models/user.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  late Future<List<User>> users;

  // get all users
  Future<List<User>> _getAllUsers() async {
    http.Response response = await http.get(Uri.parse(apiUrl + '/users'));
    if (response.statusCode == 200) {
      List jsonResponse = await json.decode(response.body)['users'];
      print(jsonResponse);
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  void _clear() {
    nameController.clear();
    emailController.clear();
  }

  @override
  void initState() {
    users = _getAllUsers();
    print(users);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FutureBuilder(
            future: users,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<User>? user = snapshot.data;

                return ListView.builder(
                  itemCount: user?.length,
                  itemBuilder: (context, index) => Slidable(
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: ((context) {}),
                          backgroundColor: Color(0xFF0392CF),
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Update',
                        ),
                        SlidableAction(
                          // An action can be bigger than the others.
                          onPressed: (context) async {
                            http.Response response = await http.delete(
                                Uri.parse(
                                    apiUrl + "/users/${user![index].id}"));
                            if (response.statusCode == 200) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          super.widget));
                            } else {
                              throw Exception('Unexpected error occured!');
                            }
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        dense: true,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        tileColor: Colors.blueGrey[300],
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: ((context) {
                              return AlertDialog(
                                title: Text(
                                  user[index].name,
                                ),
                                content: Text(user[index].email),
                              );
                            }),
                          );
                        },
                        leading: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: ((context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.transparent,
                                    content: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      child: Image(
                                          fit: BoxFit.fill,
                                          image:
                                              AssetImage('assets/profile.jpg')),
                                    ),
                                  );
                                }));
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.blue[100],
                            backgroundImage: AssetImage('assets/profile.jpg'),
                          ),
                        ),
                        title: Text(
                          user![index].name,
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          user[index].email,
                          style: TextStyle(color: Colors.white),
                        ),
                        // trailing:
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: (() {
                                  showDialog(
                                    context: context,
                                    builder: ((context) {
                                      return Center(
                                        child: SingleChildScrollView(
                                          child: AlertDialog(
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Update user',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25),
                                                  ),
                                                ],
                                              ),
                                              backgroundColor: Color(0xff8f00),
                                              content: Form(
                                                key: _formKey,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Material(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(12.0),
                                                        ),
                                                        elevation: 1,
                                                        child: TextFormField(
                                                          controller:
                                                              nameController,
                                                          decoration:
                                                              const InputDecoration(
                                                            prefixIcon: Icon(
                                                                Icons.person),
                                                            hintText:
                                                                'Enter Full name',
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    12.0),
                                                              ),
                                                            ),
                                                          ),
                                                          validator: (value) {
                                                            // check if username is empty
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return "Please enter Full name";
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Material(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(12.0),
                                                        ),
                                                        elevation: 3,
                                                        child: TextFormField(
                                                          controller:
                                                              emailController,
                                                          decoration:
                                                              const InputDecoration(
                                                            prefixIcon:
                                                                Icon(Icons.key),
                                                            hintText:
                                                                'Enter email',
                                                            border: OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            12.0))),
                                                          ),
                                                          validator: (value) {
                                                            // check if password is empty
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return "Please enter email";
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    _submitButton()
                                                  ],
                                                ),
                                              )),
                                        ),
                                      );
                                    }),
                                  );
                                }),
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                )),
                            IconButton(
                              onPressed: () async {
                                // sending delete request
                                http.Response response = await http.delete(
                                    Uri.parse(
                                        apiUrl + "/users/${user[index].id}"));

                                if (response.statusCode == 200) {
                                  setState(() {});
                                } else {
                                  throw Exception('Unexpected error occured!');
                                }
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Something went wrong!');
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: (() async {
        // check if login form is submitted
        // correctly
        if (_formKey.currentState!.validate()) {
          return;
        }

        print(nameController.text);
        print(emailController.text);

        // Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.indigo,
            dismissDirection: DismissDirection.up,
            content: Text('User Updated successfully!'),
          ),
        );
        _clear();
      }),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 8),
          padding: EdgeInsets.all(15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color.fromARGB(255, 211, 161, 91),
                    Color(0xfff7892b)
                  ])),
          child: Text(
            'Login',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
