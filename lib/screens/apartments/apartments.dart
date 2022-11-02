import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pmsmbileapp/models/apartmrnt.dart';
import 'package:pmsmbileapp/models/floor.dart';
import 'package:pmsmbileapp/screens/apartments/update_apartment_screen.dart';
import 'package:pmsmbileapp/screens/floors/apartment_floors.dart';
import 'package:pmsmbileapp/utilis/colors.dart';
import 'package:pmsmbileapp/widgets/shimmer_list.dart';

import '../../service/services.dart';

class ApartmentList extends StatefulWidget {
  const ApartmentList({super.key});

  @override
  State<ApartmentList> createState() => _ApartmentListState();
}

class _ApartmentListState extends State<ApartmentList> {
  TextEditingController searchFieldController = new TextEditingController();

  late Future<List<Apartment>> apartmentList;

  String searchString = '';

  @override
  void initState() {
    apartmentList = ApartmentService.getAllApartments();

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
                                    tileColor: AppColors.backgroundColor2,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ApartmentFloorListScreen(
                                                      id: apartments[index]
                                                          .id)));
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
                                        child: apartments[index].status ==
                                                'available'
                                            ? Icon(
                                                Icons.house,
                                                color: AppColors.primary,
                                              )
                                            : Icon(
                                                Icons.house,
                                                color: AppColors.iconColor,
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
                                              color: AppColors.primary,
                                            )),
                                        IconButton(
                                          onPressed: () async {
                                            _showSpinner();
                                            // sending delete request
                                            var response =
                                                await ApartmentService
                                                    .deleteApartment(
                                                        id: apartments[index]
                                                            .id);

                                            if (response.statusCode == 200) {
                                              setState(() {
                                                apartmentList = ApartmentService
                                                    .getAllApartments();
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
                return LoadingList();
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
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