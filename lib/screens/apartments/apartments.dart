import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:pmsmbileapp/models/apartmrnt.dart';
import 'package:pmsmbileapp/screens/apartments/update_apartment_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utilis/constants.dart';

class ApartmentList extends StatefulWidget {
  const ApartmentList({super.key});

  @override
  State<ApartmentList> createState() => _ApartmentListState();
}

class _ApartmentListState extends State<ApartmentList> {
  TextEditingController searchFieldController = new TextEditingController();

  late Future<List<Apartment>> apartmentList;

  String searchString = '';

  // get all apartments
 Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  // get all apartments
Future<List<Apartment>> _getAllApartments() async {
    var sharedPrefs = await prefs;
    http.Response response = await http.get(
        Uri.parse(apiUrl + '/get-all-apartments'),
        headers: {'Authorization': await sharedPrefs.getString('token')!});

    if (response.statusCode == 200) {
      List jsonResponse = await json.decode(response.body)['data'];

      return jsonResponse
          .map((apartment) => Apartment.fromJson(apartment))
          .toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }
  // Delete apartment
  _deleteApartment({id}) async {
    var sharedPrefs = await prefs;

    http.Response response = await http.delete(
        Uri.parse(apiUrl + "/delete-apartment/${id}"),
        headers: {'Authorization': await sharedPrefs.getString('token')!});
    return response;
  }

  @override
  void initState() {
    apartmentList = _getAllApartments();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Apartments"),
        ),
        body: SafeArea(
          child: Center(
            child: FutureBuilder(
              future: apartmentList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Apartment> apartments = snapshot.data!;

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
                              labelText: 'Search apartment by name',
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
                          itemCount: apartments.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: apartments[index]
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
                                              apartments[index].name.toString(),
                                            ),
                                            content: Row(
                                              children: [
                                                Text(
                                                  apartments[index]
                                                      .address
                                                      .toString(),
                                                ),
                                                Text(
                                                  apartments[index]
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
                                        child: apartments[index].status ==
                                                'available'
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
                                      apartments[index].name.toString(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    subtitle: Text(
                                      apartments[index].address.toString(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    // trailing:
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              print(apartments[index].id);
                                              print(apartments[index].name);
                                              print(
                                                  apartments[index].noOfFloors);
                                              print(apartments[index].address);
                                              print(apartments[index].status);

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: ((context) =>
                                                      UpdateApartmentScreen(
                                                        id: apartments[index]
                                                            .id,
                                                        apartmentName:
                                                            apartments[index]
                                                                .name,
                                                        noOfFloors:
                                                            apartments[index]
                                                                .noOfFloors
                                                                .toString(),
                                                        address:
                                                            apartments[index]
                                                                .address,
                                                        status:
                                                            apartments[index]
                                                                .status,
                                                      )),
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
                                            var response =
                                                await _deleteApartment(
                                                    id: apartments[index].id);

                                            if (response.statusCode == 200) {
                                              setState(() {
                                                apartmentList =
                                                    _getAllApartments();
                                              });
                                              Navigator.pop(context);
                                            } else {
                                              Navigator.pop(context);

                                              _showError(
                                                  error:
                                                      'Something went wrong!');
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
                  return Text('No apartment found!');
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, 'add_apartment');
          },
          label: Row(
            children: [
              Icon(Icons.add),
              Text('Add Apartment'),
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
