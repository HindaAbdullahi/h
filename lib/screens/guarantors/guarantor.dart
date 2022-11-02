import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:pmsmbileapp/models/gurantorModel.dart';
import 'package:pmsmbileapp/screens/guarantors/update-guarantor-scree.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utilis/constants.dart';
import '../../utilis/colors.dart';
import 'package:pmsmbileapp/service/services.dart';
import 'package:pmsmbileapp/widgets/shimmer_list.dart';
class GuarantorList extends StatefulWidget {
  const GuarantorList({super.key});

  @override
  State<GuarantorList> createState() => _GuarantorListState();
}

class _GuarantorListState extends State<GuarantorList> {
  TextEditingController searchFieldController = new TextEditingController();

  late Future<List<Guarantor>> guarantList;

  String searchString = '';


  @override
  void initState() {

    guarantList =GuarantorService.getAllGuarantors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Guarantor"),
        ),
        body: SafeArea(
          child: Center(
            child: FutureBuilder(
              future: guarantList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Guarantor> guarantors = snapshot.data!;

                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Material(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          elevation: 1,
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              labelText: 'Search guarant by name',
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
                          itemCount: guarantors.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: guarantors[index]
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
                                              guarantors[index].name.toString(),
                                            ),
                                            content: Row(
                                              children: [
                                                Text(
                                                  guarantors[index]
                                                      .phone
                                                      .toString(),
                                                ),
                                                Text(
                                                  guarantors[index]
                                                      .address
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
                                        child: guarantors[index].gender ==
                                                'female'
                                            ? Icon(
                                                Icons.person_add,
                                                color: Colors.green,
                                              )
                                            : Icon(
                                                Icons.house,
                                                color: Colors.blueGrey,
                                              ),
                                      ),
                                    ),
                                    title: Text(
                                      guarantors[index].name.toString(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    subtitle: Text(
                                      guarantors[index].address.toString(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    // trailing:
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              print(guarantors[index].id);
                                              print(guarantors[index].name);
                                              print(guarantors[index].phone);
                                              print(guarantors[index].address);
                                              print(guarantors[index].gender);
                                              print(guarantors[index].title);

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: ((context) =>
                                                      UpdateGuarantorScreen(
                                                        id: guarantors[index]
                                                            .id,
                                                        guarantorName:
                                                            guarantors[index]
                                                                .name,
                                                        phone:
                                                            guarantors[index]
                                                                .phone
                                                                .toString(),
                                                        address:
                                                            guarantors[index]
                                                                .address,
                                                        status:
                                                            guarantors[index]
                                                                .gender,
                                                                title:
                                                            guarantors[index]
                                                                .title,
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
                                                await     GuarantorService
                                                    .deleteGuarantor(
                                                    id: guarantors[index].id);

                                            if (response.statusCode == 200) {
                                              setState(() {
                                                guarantList =GuarantorService.getAllGuarantors();
                                                    
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
                  return Text('No guarantor found!');
                }
                return CircularProgressIndicator();
                 return LoadingList();
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, 'add_guarantor');
          },
          label: Row(
            children: [
              Icon(Icons.add),
              Text('Add Guarantor'),
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