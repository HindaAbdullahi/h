import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pmsmbileapp/models/announcement.dart';
import 'package:pmsmbileapp/providers/selected_userAnouncement_provider.dart';
import 'package:pmsmbileapp/utilis/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';
import '../screens.dart';

class AnouncementListScreen extends StatefulWidget {
  const AnouncementListScreen({super.key});

  @override
  State<AnouncementListScreen> createState() => _AnouncementListScreenState();
}

class _AnouncementListScreenState extends State<AnouncementListScreen> {
  TextEditingController searchFieldController = new TextEditingController();

  late Future<List<Anouncement>> anouncementList;

  String searchString = '';
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  // get all apartments
  // Future<List<Apartment>> _getAllApartments() async {
  //   var sharedPrefs = await prefs;

  //   http.Response response = await http
  //       .get(Uri.parse(apiUrl + '/get-all-apartments'), headers: {
  //     "Authorization": await sharedPrefs.getString('token').toString()
  //   });

  //   if (response.statusCode == 200) {
  //     List jsonResponse = await json.decode(response.body)['data'];
  //     return jsonResponse
  //         .map((apartment) => Apartment.fromJson(apartment))
  //         .toList();
  //   } else {
  //     throw Exception('Unexpected error occured!');
  //   }
  // }

  // get all anouncement
  Future<List<Anouncement>> _getAllAnouncements() async {
    var sharedPrefs = await prefs;
    http.Response response = await http.get(
        Uri.parse(apiUrl + '/get-all-anouncements'),
        headers: {'Authorization': await sharedPrefs.getString('token')!});

    if (response.statusCode == 200) {
      List jsonResponse = await json.decode(response.body)['data'];

      return jsonResponse
          .map((anouncement) => Anouncement.fromJson(anouncement))
          .toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  // Delete floor
  _deleteAnouncement({id}) async {
    var sharedPrefs = await prefs;

    http.Response response = await http.delete(
        Uri.parse(apiUrl + "/delete-anouncement/${id}"),
        headers: {'Authorization': await sharedPrefs.getString('token')!});
    return response;
  }

  @override
  void initState() {
    anouncementList = _getAllAnouncements();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Anouncements"),
        ),
        body: SafeArea(
          child: Center(
            child: FutureBuilder(
              future: anouncementList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Anouncement> anouncements = snapshot.data!;

                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 12.0),
                        child: Material(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          elevation: 1,
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              labelText: 'Search anouncement by name',
                            ),
                            onChanged: ((value) {
                              setState(() {
                                searchString = value;
                              });
                            }),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: anouncements.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: anouncements[index]
                                    .name!
                                    .toLowerCase()
                                    .contains(searchString.toLowerCase())
                                ? ListTile(
                                    dense: true,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    tileColor: Colors.blueGrey[100],
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: ((context) {
                                          return AlertDialog(
                                            title: Text(
                                              anouncements[index].name.toString(),
                                            ),
                                            content: Row(
                                              children: [
                                                Text(
                                                  anouncements[index]
                                                      .user!
                                                      .name
                                                      .toString(),
                                                ),
                                                Text(
                                                  anouncements[index]
                                                      .status
                                                      .toString(),
                                                ),
                                              ],
                                            ),
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
                                              backgroundColor:
                                                  Colors.transparent,
                                              content: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                child: Image(
                                                  fit: BoxFit.fill,
                                                  image: AssetImage(
                                                      'assets/bj1.jpg'),
                                                ),
                                              ),
                                            );
                                          }),
                                        );
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.blueGrey[200],
                                        child:
                                            anouncements[index].status == 'available'
                                                ? Icon(
                                                    Icons.house,
                                                    color: Colors.green,
                                                  )
                                                : Icon(
                                                    Icons.house,
                                                    color: Colors.blueGrey,
                                                  ),
                                      ),
                                    ),
                                    title: Text(
                                      anouncements[index].name.toString(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    subtitle: Text(
                                      anouncements[index].message.toString(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    // trailing:
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              print(anouncements[index].id);
                                              print(anouncements[index].name);
                                              print(anouncements[index].user);
                                              print(anouncements[index].createdAt);
                                              print(anouncements[index].status);
                                              Provider.of<SelectedUser>(
                                                      context,
                                                      listen: false)
                                                  .setUser(
                                                      anouncements[index].user!);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: ((context) {
                                                    return UpdateAnouncementScreen(
                                                      id: anouncements[index].id,
                                                      name: anouncements[index].name,
                                                      message: anouncements[index]
                                                          .message
                                                          .toString(),
                                                      status:
                                                          anouncements[index].status,
                                                    );
                                                  }),
                                                ),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.blue,
                                            )),
                                        IconButton(
                                          onPressed: () async {
                                            _showSpinner();
                                            // sending delete request
                                            var response = await _deleteAnouncement(
                                                id: anouncements[index].id);

                                            if (response.statusCode == 200) {
                                              setState(() {
                                                anouncementList = _getAllAnouncements();
                                              });
                                              Navigator.pop(context);
                                            } else {
                                              Navigator.pop(context);

                                              _showError(
                                                  error: json.decode(
                                                      response.body)['error']);
                                            }
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                          ),
                        ),
                      ),
                    ],
                  );
                  print("error");
                } else if (snapshot.hasError) {
                  return Text('No anouncement found!');
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, 'add_anouncement');
          },
          label: Row(
            children: [
              Icon(Icons.add),
              Text('Add Anouncement'),
            ],
          ),
        ),
      ),
      onWillPop: () {
        Navigator.pushNamed(context, 'home');

        //we need to return a future
        return Future.value(false);
      },
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