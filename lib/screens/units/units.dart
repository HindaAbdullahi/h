// import 'dart:convert';

// import 'package:flutter/material.dart';

// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:http/http.dart' as http;
// import 'package:pmsmbileapp/models/floor.dart';
// import 'package:provider/provider.dart';
// import 'package:pmsmbileapp/models/unit.dart';
// import 'package:pmsmbileapp/providers/selected_floor_provider.dart';
// import 'package:pmsmbileapp/utilis/constants.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../models/apartmrnt.dart';
// import '../screens.dart';

// class UnitListScreen extends StatefulWidget {
//   const UnitListScreen({super.key});

//   @override
//   State<UnitListScreen> createState() => _UnitListScreenState();
// }

// class _UnitListScreenState extends State<UnitListScreen> {
//   TextEditingController searchFieldController = new TextEditingController();

//   late Future<List<Unit>> unitList;

//   String searchString = '';
//   Future<SharedPreferences> prefs = SharedPreferences.getInstance();

//   // get all apartments
//   Future<List<Floor>> _getAllFloors() async {
//     var sharedPrefs = await prefs;

//     http.Response response = await http
//         .get(Uri.parse(apiUrl + '/get-all-floors'), headers: {
//       "Authorization": await sharedPrefs.getString('token').toString()
//     });

//     if (response.statusCode == 200) {
//       List jsonResponse = await json.decode(response.body)['data'];

//       return jsonResponse
//           .map((floor) => Floor.fromJson(floor))
//           .toList();
//     } else {
//       throw Exception('Unexpected error occured!');
//     }
//   }

//   // get all floors
//   Future<List<Unit>> _getAllUnits() async {
//     var sharedPrefs = await prefs;
//     http.Response response = await http.get(
//         Uri.parse(apiUrl + '/get-all-units'),
//         headers: {'Authorization': await sharedPrefs.getString('token')!});

//     if (response.statusCode == 200) {
//       List jsonResponse = await json.decode(response.body)['data'];

//       return jsonResponse
//           .map((unit) => Unit.fromJson(unit))
//           .toList();
//     } else {
//       throw Exception('Unexpected error occured!');
//     }
//   }

//   // Delete floor
//   _deleteFloor({id}) async {
//     var sharedPrefs = await prefs;

//     http.Response response = await http.delete(
//         Uri.parse(apiUrl + "/delete-unit/${id}"),
//         headers: {'Authorization': await sharedPrefs.getString('token')!});
//     return response;
//   }

//   @override
//   void initState() {
//     unitList = _getAllUnits();

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("units"),
//         ),
//         body: SafeArea(
//           child: Center(
//             child: FutureBuilder(
//               future: unitList,
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   List<Unit> units = snapshot.data!;

//                   return Column(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(bottom: 12.0),
//                         child: Material(
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(8.0),
//                           ),
//                           elevation: 1,
//                           child: TextFormField(
//                             decoration: InputDecoration(
//                               prefixIcon: Icon(Icons.search),
//                               labelText: 'Search unit by name',
//                             ),
//                             onChanged: ((value) {
//                               setState(() {
//                                 searchString = value;
//                               });
//                             }),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: ListView.builder(
//                           itemCount: units.length,
//                           itemBuilder: (context, index) => Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: units[index]
//                                     .unitname!
//                                     .toLowerCase()
//                                     .contains(searchString.toLowerCase())
//                                 ? ListTile(
//                                     dense: true,
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(10))),
//                                     tileColor: Colors.blueGrey[100],
//                                     onTap: () {
//                                       showDialog(
//                                         context: context,
//                                         builder: ((context) {
//                                           return AlertDialog(
//                                             title: Text(
//                                               units[index].unitname.toString(),
//                                             ),
//                                             content: Row(
//                                               children: [
//                                                 Text(
//                                                   units[index]
//                                                       .floor!
//                                                       .name
//                                                       .toString(),
//                                                 ),
//                                                 // Text(
//                                                 //   unit[index]
//                                                 //       .status
//                                                 //       .toString(),
//                                                 // ),
//                                               ],
//                                             ),
//                                           );
//                                         }),
//                                       );
//                                     },
//                                     leading: GestureDetector(
//                                       onTap: () {
//                                         showDialog(
//                                           context: context,
//                                           builder: ((context) {
//                                             return AlertDialog(
//                                               backgroundColor:
//                                                   Colors.transparent,
//                                               content: ClipRRect(
//                                                 borderRadius: BorderRadius.all(
//                                                   Radius.circular(10),
//                                                 ),
//                                                 child: Image(
//                                                   fit: BoxFit.fill,
//                                                   image: AssetImage(
//                                                       'assets/bj1.jpg'),
//                                                 ),
//                                               ),
//                                             );
//                                           }),
//                                         );
//                                       },
//                                       // child: CircleAvatar(
//                                       //   backgroundColor: Colors.blueGrey[200],
//                                       //   child:
//                                       //       floors[index].status == 'available'
//                                       //           ? Icon(
//                                       //               Icons.house,
//                                       //               color: Colors.green,
//                                       //             )
//                                       //           : Icon(
//                                       //               Icons.house,
//                                       //               color: Colors.blueGrey,
//                                       //             ),
//                                       // ),
//                                     ),
//                                     title: Text(
//                                       units[index].unitname.toString(),
//                                       style: TextStyle(color: Colors.black),
//                                     ),
//                                     subtitle: Text(
//                                       units[index].noofrooms.toString(),
//                                       style: TextStyle(color: Colors.black),
//                                     ),
//                                     // trailing:
//                                     trailing: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         IconButton(
//                                             onPressed: () {
//                                               print(units[index].id);
//                                               print(units[index].unitname);
//                                               print(units[index].floor);
//                                               print(units[index].createdAt);

//                                               Provider.of<SelectedFloor>(
//                                                       context,
//                                                       listen: false)
//                                                   .setFloor(
//                                                       units[index].floor!);
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: ((context) {
//                                                     return UpdateFloorScreen(
//                                                       id: floors[index].id,
//                                                       name: floors[index].name,
//                                                       noOfUnits: floors[index]
//                                                           .noOfUnits
//                                                           .toString(),
//                                                       status:
//                                                           floors[index].status,
//                                                     );
//                                                   }),
//                                                 ),
//                                               );
//                                             },
//                                             icon: Icon(
//                                               Icons.edit,
//                                               color: Colors.blue,
//                                             )),
//                                         IconButton(
//                                           onPressed: () async {
//                                             _showSpinner();
//                                             // sending delete request
//                                             var response = await _deleteFloor(
//                                                 id: floors[index].id);

//                                             if (response.statusCode == 200) {
//                                               setState(() {
//                                                 floorList = _getAllFloors();
//                                               });
//                                               Navigator.pop(context);
//                                             } else {
//                                               Navigator.pop(context);

//                                               _showError(
//                                                   error: json.decode(
//                                                       response.body)['error']);
//                                             }
//                                           },
//                                           icon: Icon(
//                                             Icons.delete,
//                                             color: Colors.red,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 : Container(),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 } else if (snapshot.hasError) {
//                   return Text('No floor found!');
//                 }
//                 return CircularProgressIndicator();
//               },
//             ),
//           ),
//         ),
//         floatingActionButton: FloatingActionButton.extended(
//           onPressed: () {
//             Navigator.pushNamed(context, 'add_floor');
//           },
//           label: Row(
//             children: [
//               Icon(Icons.add),
//               Text('Add Floor'),
//             ],
//           ),
//         ),
//       ),
//       onWillPop: () {
//         Navigator.pushNamed(context, 'home');

//         //we need to return a future
//         return Future.value(false);
//       },
//     );
//   }

//   _showSpinner() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           child: Padding(
//             padding: const EdgeInsets.all(8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // CircularProgressIndicator(),
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                       child: Container(
//                         padding: EdgeInsets.all(8.0),
//                         color: Colors.white,
//                         child: SpinKitCircle(
//                           color: Colors.blueGrey[700],
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // show error in scaffold
//   _showError({error}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         duration: Duration(seconds: 3),
//         backgroundColor: Colors.red,
//         dismissDirection: DismissDirection.up,
//         content: Text(error),
//       ),
//     );
//   }
// }