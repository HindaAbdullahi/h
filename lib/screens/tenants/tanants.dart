// import 'dart:convert';

// import 'package:flutter/material.dart';

// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:http/http.dart' as http;
// import 'package:pmsmbileapp/models/gurantorModel.dart';

// import 'package:pmsmbileapp/screens/apartments/update_apartment_screen.dart';
// import 'package:pmsmbileapp/utilis/constants.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../models/tenants.dart';
// import '../screens.dart';

// class TenantListScreen extends StatefulWidget {
//   const TenantListScreen({super.key});

//   @override
//   State<TenantListScreen> createState() => _TenantListScreenState();
// }

// class _TenantListScreenState extends State<TenantListScreen> {
//   TextEditingController searchFieldController = new TextEditingController();

//   late Future<List<Tenant>> tenantList;

//   String searchString = '';
//   Future<SharedPreferences> prefs = SharedPreferences.getInstance();

// // get all apartments

//   Future<List<Guarantor>> _getAllGuarantors() async {
//     var sharedPrefs = await prefs;

//     http.Response response = await http
//         .get(Uri.parse(apiUrl + '/get-all-guarantors'), headers: {
//       "Authorization": await sharedPrefs.getString('token').toString()
//     });

//     if (response.statusCode == 200) {
//       List jsonResponse = await json.decode(response.body)['data'];

//       return jsonResponse
//           .map((guarantor) => Guarantor.fromJson(guarantor))
//           .toList();
//     } else {
//       throw Exception('Unexpected error occured!');
//     }
//   }

//   // get all floors
//   Future<List<Tenant>> _getAllTenants() async {
//     var sharedPrefs = await prefs;
//     http.Response response = await http.get(
//         Uri.parse(apiUrl + '/get-all-tenants'),
//         headers: {'Authorization': await sharedPrefs.getString('token')!});

//     if (response.statusCode == 200) {
//       List jsonResponse = await json.decode(response.body)['data'];

//       return jsonResponse
//           .map((guarantor) => Tenant.fromJson(guarantor))
//           .toList();
//     } else {
//       throw Exception('Unexpected error occured!');
//     }
//   }

//   // Delete floor
//   _deleteFloor({id}) async {
//     var sharedPrefs = await prefs;

//     http.Response response = await http.delete(
//         Uri.parse(apiUrl + "/delete-tenant/${id}"),
//         headers: {'Authorization': await sharedPrefs.getString('token')!});
//     return response;
//   }

//   @override
//   void initState() {
//     tenantList = _getAllTenants();

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Tenants"),
//         ),
//         body: SafeArea(
//           child: Center(
//             child: FutureBuilder(
//               future: tenantList,
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   List<Tenant> tenants = snapshot.data!;

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
//                               labelText: 'Search tenant by name',
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
//                           itemCount: tenants.length,
//                           itemBuilder: (context, index) => Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: tenants[index]
//                                     .fullname!
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
//                                               tenants[index].fullname.toString(),
//                                             ),
//                                             content: Row(
//                                               children: [
//                                                 Text(
//                                                   floors[index]
//                                                       .apartment!
//                                                       .name
//                                                       .toString(),
//                                                 ),
//                                                 Text(
//                                                   floors[index]
//                                                       .status
//                                                       .toString(),
//                                                 ),
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
//                                       child: CircleAvatar(
//                                         backgroundColor: Colors.blueGrey[200],
//                                         child:
//                                             floors[index].status == 'available'
//                                                 ? Icon(
//                                                     Icons.house,
//                                                     color: Colors.green,
//                                                   )
//                                                 : Icon(
//                                                     Icons.house,
//                                                     color: Colors.blueGrey,
//                                                   ),
//                                       ),
//                                     ),
//                                     title: Text(
//                                       floors[index].name.toString(),
//                                       style: TextStyle(color: Colors.black),
//                                     ),
//                                     subtitle: Text(
//                                       floors[index].noOfUnits.toString(),
//                                       style: TextStyle(color: Colors.black),
//                                     ),
//                                     // trailing:
//                                     trailing: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         IconButton(
//                                             onPressed: ()  {
                                             
//                                               print(floors[index].id);
//                                               print(floors[index].name);
//                                               print(floors[index].apartment);
//                                               print(floors[index].createdAt);
//                                               print(floors[index].status);

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
//                                                       apartment: floors[index]
//                                                           .apartment,
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
