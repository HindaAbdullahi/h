import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pmsmbileapp/providers/selected_floor_provider.dart';
import 'package:pmsmbileapp/utilis/colors.dart';
import 'package:pmsmbileapp/utilis/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/apartmrnt.dart';
import '../../models/unit.dart';
import '../screens.dart';

class UnitListScreen extends StatefulWidget {
  const UnitListScreen({super.key});

  @override
  State<UnitListScreen> createState() => _UnitListScreenState();
}

class _UnitListScreenState extends State<UnitListScreen> {
  TextEditingController searchFieldController = new TextEditingController();

  String searchString = '';
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  late Future<List<Unit>> unitList;



  // get all units
  Future<List<Unit>> _getAllUnits() async {
    var sharedPrefs = await prefs;
    http.Response response = await http.get(
        Uri.parse(apiUrl + '/get-all-units'),
        headers: {'Authorization': await sharedPrefs.getString('token')!});

    if (response.statusCode == 200) {
      List jsonResponse = await json.decode(response.body)['data'];
      print(jsonResponse);
      return jsonResponse.map((unit) => Unit.fromJson(unit)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  // Delete unit
  _deleteUnit({id}) async {
    var sharedPrefs = await prefs;

    http.Response response = await http.delete(
        Uri.parse(apiUrl + "/delete-unit/${id}"),
        headers: {'Authorization': await sharedPrefs.getString('token')!});
    return response;
  }

  @override
  void initState() {
    unitList = _getAllUnits();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Units"),
        ),
        body: SafeArea(
          child: Center(
            child: FutureBuilder(
              future: unitList,
              builder: (context, snapshot) {
                print('Snapshot: ' + snapshot.data.toString());
                if (snapshot.hasData) {
                  List<Unit> units = snapshot.data!;

                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 12.0, left: 12.0, right: 12.0),
                        child: Material(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.search),
                              labelText: 'Search unit by name',
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
                          itemCount: units.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(
                                bottom: 4, top: 4, right: 16, left: 16),
                            child: units[index]
                                    .name!
                                    .toLowerCase()
                                    .contains(searchString.toLowerCase())
                                ? ListTile(
                                    dense: true,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: ((context) {
                                          return AlertDialog(
                                            title: Text(
                                              units[index].name.toString(),
                                            ),
                                            content: Row(
                                              children: [
                                                Text(
                                                  units[index]
                                                      .floor!
                                                      .name
                                                      .toString(),
                                                ),
                                                Text(
                                                  units[index]
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
                                        backgroundColor:
                                            AppColors.backgroundColor1,
                                        child:
                                            units[index].status == 'available'
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
                                      units[index].name.toString(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    subtitle: Text(
                                      units[index].noOfRooms.toString() +
                                          " rooms",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    // trailing:
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              print(units[index].id);
                                              print(units[index].name);
                                              print(units[index].floor);
                                              print(units[index].createdAt);
                                              print(units[index].status);
                                              Provider.of<SelectedFloor>(
                                                      context,
                                                      listen: false)
                                                  .setFloor(
                                                      units[index].floor!);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: ((context) {
                                                    return UpdateFloorScreen(
                                                      id: units[index].id,
                                                      name: units[index].name,
                                                      noOfUnits: units[index]
                                                          .noOfRooms
                                                          .toString(),
                                                      status:
                                                          units[index].status,
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
                                            var response = await _deleteUnit(
                                                id: units[index].id);

                                            if (response.statusCode == 200) {
                                              setState(() {
                                                unitList = _getAllUnits();
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
                } else if (snapshot.hasError) {
                  return Text('No unit found!');
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, 'add_unit');
          },
          label: Row(
            children: [
              Icon(Icons.add),
              Text('Add Unit'),
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