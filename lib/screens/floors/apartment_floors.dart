import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:pmsmbileapp/models/floor.dart';
import 'package:pmsmbileapp/providers/selected_apartment_provider.dart';
import 'package:pmsmbileapp/utilis/colors.dart';
import 'package:pmsmbileapp/widgets/shimmer_list.dart';
import '../screens.dart';
import '../../service/services.dart';
import '../units/floor_units.dart';

class ApartmentFloorListScreen extends StatefulWidget {
  String? id;

  ApartmentFloorListScreen({super.key, this.id});

  @override
  State<ApartmentFloorListScreen> createState() =>
      _ApartmentFloorListScreenState();
}

class _ApartmentFloorListScreenState extends State<ApartmentFloorListScreen> {
  TextEditingController searchFieldController = new TextEditingController();

  String searchString = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Floors"),
        ),
        body: SafeArea(
          child: Center(
            child: FutureBuilder(
              future: FloorService.getApartmentFloors(id: widget.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Floor> floors = snapshot.data!;
                  print('Snapshot of apar floors: ${floors}');

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
                              labelText: 'Search floor by name',
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
                          itemCount: floors.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(
                                bottom: 4, top: 4, right: 16, left: 16),
                            child: floors[index]
                                    .name!
                                    .toLowerCase()
                                    .contains(searchString.toLowerCase())
                                ? ListTile(
                                    dense: true,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FloorUnitListScreen(
                                                      id: floors[index].id)));
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
                                            floors[index].status == 'available'
                                                ? Icon(
                                                    Icons.ad_units,
                                                    color: AppColors.primary,
                                                  )
                                                : Icon(
                                                    Icons.ad_units,
                                                    color: AppColors.iconColor,
                                                  ),
                                      ),
                                    ),
                                    title: Text(
                                      floors[index].name.toString(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    subtitle: Text(
                                      floors[index].noOfUnits.toString() +
                                          " units",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    // trailing:
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              print(floors[index].id);
                                              print(floors[index].name);
                                              print(floors[index].apartment);
                                              print(floors[index].createdAt);
                                              print(floors[index].status);
                                              Provider.of<SelectedApartment>(
                                                      context,
                                                      listen: false)
                                                  .setApartment(
                                                      floors[index].apartment!);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: ((context) {
                                                    return UpdateFloorScreen(
                                                      id: floors[index].id,
                                                      name: floors[index].name,
                                                      noOfUnits: floors[index]
                                                          .noOfUnits
                                                          .toString(),
                                                      status:
                                                          floors[index].status,
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
                                                await FloorService.deleteFloor(
                                                    id: floors[index].id);

                                            if (response.statusCode == 200) {
                                              setState(() {});
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
                  return Text('No floor found!');
                }
                return LoadingList();
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          onPressed: () {
            Navigator.pushNamed(context, '/add_floor');
          },
          label: Row(
            children: [
              Icon(Icons.add),
              Text('Add Floor'),
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