
import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pmsmbileapp/providers/selected_floor_provider.dart';
import 'package:pmsmbileapp/utilis/colors.dart';
import 'package:pmsmbileapp/utilis/constants.dart';
import 'package:pmsmbileapp/widgets/shimmer_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/apartmrnt.dart';
import '../../models/unit.dart';
import '../../service/unit_service.dart';
import '../screens.dart';

class FloorUnitListScreen extends StatefulWidget {
  String? id;

  FloorUnitListScreen({super.key, this.id});

  @override
  State<FloorUnitListScreen> createState() => _FloorUnitListScreenState();
}

class _FloorUnitListScreenState extends State<FloorUnitListScreen> {
  TextEditingController searchFieldController = new TextEditingController();

  String searchString = '';

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
              future: UnitService.getFloorUnits(id: widget.id),
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
                              prefixIcon: Icon(
                                Icons.search,
                                color: AppColors.iconColor,
                              ),
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
                                                    color: AppColors.primary,
                                                  )
                                                : Icon(
                                                    Icons.house,
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
                                                  .setFLoor(
                                                      units[index].floor!);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: ((context) {
                                                    return UpdateUnitScreen(
                                                      id: units[index].id,
                                                      name: units[index].name,
                                                      noOfRooms: units[index]
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
                                              color: AppColors.primary,
                                            )),
                                        IconButton(
                                          onPressed: () async {
                                            _showSpinner();
                                            // sending delete request
                                            var response =
                                                await UnitService.deleteUnit(
                                                    id: units[index].id);

                                            if (response.statusCode == 200) {
                                              setState(() {});
                                              Navigator.pop(context);
                                            } else {
                                              Navigator.pop(context);

                                              CoolAlert.show(
                                                  context: context,
                                                  backgroundColor: AppColors
                                                      .backgroundColor1,
                                                  confirmBtnColor:
                                                      AppColors.primary,
                                                  type: CoolAlertType.error,
                                                  title: 'Error',
                                                  text: json.decode(
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
                return LoadingList();
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, '/add_unit');
          },
          backgroundColor: AppColors.primary,
          label: Row(
            children: [
              Icon(Icons.add),
              Text('Add Unit'),
            ],
          ),
        ),
      ),
      onWillPop: () {
        Navigator.pushNamed(context, '/home');

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