import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:pmsmbileapp/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pmsmbileapp/style/constants.dart';
import 'package:pmsmbileapp/style/responsive.dart';
import 'package:pmsmbileapp/screens/analytic_cards.dart';
import 'package:pmsmbileapp/screens/bar_chart_users.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          try {
            _showSpinner();
            final result = await InternetAddress.lookup('google.com');

            if (!result.isNotEmpty && !result[0].rawAddress.isNotEmpty) {
              Navigator.pop(context);
              showDialogBox();
              setState(() => isAlertSet = true);
            } else {
              Navigator.pop(context);
            }
          } catch (e) {
            Navigator.pop(context);

            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

  @override
  void dispose() {
    // subscription.cancel();
    super.dispose();
  }

  // Map<String, double> dataMap = {'Vacants': 5, 'Occupied': 4};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: Text(
          'Dashboard'
        ),
        actions: [
          IconButton(
            onPressed: () {
              print('Hello');
            },
            color: Colors.black,
            icon: Icon(Icons.notifications_sharp),
          ),
          PopupMenuButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            onSelected: (value) {
              print(value);
            },
            itemBuilder: ((context) {
              return [
                PopupMenuItem(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();
                    Navigator.pushNamed(context, 'login_screen');
                  },
                  child: ListTile(
                    title: Text('Logout'),
                    trailing: Icon(Icons.logout),
                  ),
                  value: 3,
                ),
              ];
            }),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
 Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          AnalyticCards(),
                          SizedBox(
                            height: appPadding,
                          ),
                          // Users(),
                          if (Responsive.isMobile(context))
                            SizedBox(
                              height: appPadding,
                            ),
                          // if (Responsive.isMobile(context)) BarChartSample2(),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      SizedBox(
                        width: appPadding,
                      ),
                    // if (!Responsive.isMobile(context))
                    //   Expanded(
                    //     flex: 2,
                    //     child: BarChartSample2(),
                    //   ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          SizedBox(
                            height: appPadding,
                          ),
                          Row(
                            children: [
                              if(!Responsive.isMobile(context))
                                Expanded(
                                  child: PieChartSample2(),
                                  flex: 2,
                                ),
                              // if(!Responsive.isMobile(context))
                              //   SizedBox(width: appPadding,),
                              // Expanded(
                              //   flex: 3,
                              //   child: Viewers(),
                              // ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          
                          if (Responsive.isMobile(context))
                            SizedBox(
                              height: appPadding,
                            ),
                          if (Responsive.isMobile(context)) PieChartSample2(),
                          if (Responsive.isMobile(context))
                            SizedBox(
                              height: appPadding,
                            ),
                          // if (Responsive.isMobile(context)) UsersByDevice(),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      SizedBox(
                        width: appPadding,
                      ),
                    if (!Responsive.isMobile(context))
                      Expanded(
                        flex: 2,
                        child: PieChartSample2(),
                      ),
                  ],
                ),



                          // Expanded(
                          //   flex: 1,
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(bottom: 6.0),
                          //     child: Container(
                          //       decoration: BoxDecoration(
                          //           color: Colors.white,
                          //           borderRadius: BorderRadius.circular(12),
                          //           boxShadow: [
                          //             BoxShadow(
                          //               color: Colors.grey.withOpacity(0.25),
                          //               spreadRadius: 1,
                          //               blurRadius: 5,
                          //               offset: Offset(
                          //                   0, 3), // changes position of shadow
                          //             )
                          //           ]),
                                // child: Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     Padding(
                                //       padding: const EdgeInsets.all(8.0),
                                //       child: FaIcon(
                                //         FontAwesomeIcons.users,
                                //         color: Colors.blueGrey,
                                //         size: 50,
                                //       ),
                                //     ),
                                    // Expanded(
                                    //   child: Column(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.center,
                                    //     children: [
                                    //       Text(
                                    //         'Total tenants',
                                    //         textAlign: TextAlign.center,
                                    //       ),
                                    //       Text(
                                    //         '50',
                                    //         style: TextStyle(fontSize: 40),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Expanded(
                          //   flex: 1,
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(top: 6.0),
                          //     child: Container(
                          //       decoration: BoxDecoration(
                          //         color: Color.fromARGB(255, 255, 255, 255),
                          //         borderRadius: BorderRadius.circular(12),
                          //         boxShadow: [
                          //           BoxShadow(
                          //             color: Colors.grey.withOpacity(0.25),
                          //             spreadRadius: 1,
                          //             blurRadius: 5,
                          //             offset: Offset(
                          //                 0, 3), // changes position of shadow
                          //           )
                          //         ],
                          //       ),
                                // child: Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: FaIcon(
                                    //     FontAwesomeIcons.peopleGroup,
                                    //     color: Colors.blueGrey,
                                    //     size: 50,
                                    //   ),
                                    // ),
                      //               Expanded(flex: 5,
                      // child: Column(
                      //   children: [
                      //     AnalyticCards(),
                      //     SizedBox(
                      //       height: appPadding,
                      //     ),
                      //   ],
                      // ),
                      //  )  , 
                      //  if (Responsive.isMobile(context))
                      //       SizedBox(
                      //         height: appPadding,
                      //       ),
                       
//chart

// Expanded(flex: 5,
//                       child: Row(
//                         children: [
//                           BarChartSample2(),
//                           SizedBox(
//                             height: appPadding,
//                           ),
//                         ],
//                       ),
//                        )  , 
//                        if (Responsive.isMobile(context))
//                             SizedBox(
//                               height: appPadding,
//                             ),
                       




                       
                        // Expanded(
                                    //   child: Column(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.center,
                                    //     children: [
                                    //       Text(
                                    //         'Total employees',
                                    //         textAlign: TextAlign.center,
                                    //       ),
                                    //       Text(
                                    //         '8',
                                    //         style: TextStyle(fontSize: 40),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // )
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // )
                    //     ],
                    //   ),
                //     // ),
                //   ),
                // ),
                // Expanded(
                //   flex: 1,
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Container(
                //       child: Center(
                //         child: Padding(
                //           padding: const EdgeInsets.all(16.0),
                //           child: PieChart(
                //             dataMap: dataMap,
                //             animationDuration: Duration(milliseconds: 2000),
                //             chartLegendSpacing: 32,
                //             chartRadius:
                //                 MediaQuery.of(context).size.width / 0.3,
                //             initialAngleInDegree: 0,
                //             chartType: ChartType.ring,
                //             ringStrokeWidth: 32,
                //             colorList: [
                //               Color.fromARGB(255, 149, 153, 156),
                //               Colors.blueGrey
                //             ],
                //             legendOptions: LegendOptions(
                //               showLegendsInRow: false,
                //               legendPosition: LegendPosition.bottom,
                //               showLegends: true,
                //               legendTextStyle: TextStyle(fontSize: 15),
                //             ),
                //             chartValuesOptions: ChartValuesOptions(
                //               showChartValueBackground: false,
                //               showChartValues: true,
                //               showChartValuesInPercentage: false,
                //               showChartValuesOutside: false,
                //               decimalPlaces: 0,
                //             ),
                //           ),
                //         ),
                //       ),
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.circular(12),
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.grey.withOpacity(0.3),
                //             spreadRadius: 1,
                //             blurRadius: 5,
                //             offset: Offset(0, 3), // changes position of shadow
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Divider(),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //   child: Align(
          //     alignment: Alignment.centerLeft,
          //     child: Text('Maintenance requests'),
          //   ),
          // ),
          // ListTile(
          //   leading: CircleAvatar(
          //     child: Icon(Icons.email),
          //   ),
          //   title: Text('Tenant name'),
          //   subtitle: Text('Maintenance request body'),
          //   trailing: ElevatedButton(
          //     onPressed: null,
          //     child: Text(
          //       'Accept',
          //       style: TextStyle(color: Colors.white),
          //     ),
          //     style: ButtonStyle(
          //         backgroundColor:
          //             MaterialStatePropertyAll<Color>(Colors.green)),
          //   ),
          // ),
          Divider(),
          // Expanded(
          //     child:
                  // ListView.builder(
                  //     itemCount: 5,
                  //     itemBuilder: ((context, index) {
                  //       return ListTile(
                  //         title: Text('Item ${index}'),
                  //       );
                  //     })),
          //         Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: CarouselSlider(
          //     options: CarouselOptions(height: 400.0, autoPlay: true),
          //     items: [1, 2, 3, 4, 5].map((i) {
          //       return Builder(
          //         builder: (BuildContext context) {
          //           return ClipRRect(
          //             borderRadius: BorderRadius.circular(20),
          //             child: Container(
          //                 width: MediaQuery.of(context).size.width,
          //                 margin: EdgeInsets.symmetric(horizontal: 5.0),
          //                 decoration: BoxDecoration(color: Colors.blueGrey),
          //                 child: Center(
          //                   child: Text(
          //                     'text $i',
          //                     style: TextStyle(fontSize: 16.0),
          //                   ),
          //                 )),
          //           );
          //         },
          //       );
          //     }).toList(),
          //   ),
          // )
          // ),
        ],
      ),
    );
  }

  showDialogBox() => showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

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
}