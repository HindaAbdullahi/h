// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class BarChartSample2 extends StatefulWidget {
//   const BarChartSample2({super.key});

//   @override
//   State<StatefulWidget> createState() => BarChartSample2State();
// }

// class BarChartSample2State extends State<BarChartSample2> {
//   final Color leftBarColor = const Color(0xff53fdd7);
//   final Color rightBarColor = const Color(0xffff5182);
//   final double width = 7;

//   late List<BarChartGroupData> rawBarGroups;
//   late List<BarChartGroupData> showingBarGroups;

//   int touchedGroupIndex = -1;

//   @override
//   void initState() {
//     super.initState();
//     final barGroup1 = makeGroupData(0, 5, 12);
//     final barGroup2 = makeGroupData(1, 16, 12);
//     final barGroup3 = makeGroupData(2, 18, 5);
//     final barGroup4 = makeGroupData(3, 20, 16);
//     final barGroup5 = makeGroupData(4, 17, 6);
//     final barGroup6 = makeGroupData(5, 19, 1.5);
//     final barGroup7 = makeGroupData(6, 10, 1.5);

//     final items = [
//       barGroup1,
//       barGroup2,
//       barGroup3,
//       barGroup4,
//       barGroup5,
//       barGroup6,
//       barGroup7,
//     ];

//     rawBarGroups = items;

//     showingBarGroups = rawBarGroups;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1,
//       child: Card(
//         elevation: 0,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//         color: const Color(255),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   makeTransactionsIcon(),
//                   const SizedBox(
//                     width: 38,
//                   ),
//                   const Text(
//                     'Transactions',
//                     style: TextStyle(color: Colors.white, fontSize: 22),
//                   ),
//                   const SizedBox(
//                     width: 4,
//                   ),
//                   const Text(
//                     'state',
//                     style: TextStyle(color: Color(0xff77839a), fontSize: 16),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 38,
//               ),
//               Expanded(
//                 child: BarChart(
//                   BarChartData(
//                     maxY: 20,
//                     barTouchData: BarTouchData(
//                       touchTooltipData: BarTouchTooltipData(
//                         tooltipBgColor: Colors.grey,
//                         getTooltipItem: (a, b, c, d) => null,
//                       ),
//                       touchCallback: (FlTouchEvent event, response) {
//                         if (response == null || response.spot == null) {
//                           setState(() {
//                             touchedGroupIndex = -1;
//                             showingBarGroups = List.of(rawBarGroups);
//                           });
//                           return;
//                         }

//                         touchedGroupIndex = response.spot!.touchedBarGroupIndex;

//                         setState(() {
//                           if (!event.isInterestedForInteractions) {
//                             touchedGroupIndex = -1;
//                             showingBarGroups = List.of(rawBarGroups);
//                             return;
//                           }
//                           showingBarGroups = List.of(rawBarGroups);
//                           if (touchedGroupIndex != -1) {
//                             var sum = 0.0;
//                             for (final rod
//                                 in showingBarGroups[touchedGroupIndex]
//                                     .barRods) {
//                               sum += rod.toY;
//                             }
//                             final avg = sum /
//                                 showingBarGroups[touchedGroupIndex]
//                                     .barRods
//                                     .length;

//                             showingBarGroups[touchedGroupIndex] =
//                                 showingBarGroups[touchedGroupIndex].copyWith(
//                               barRods: showingBarGroups[touchedGroupIndex]
//                                   .barRods
//                                   .map((rod) {
//                                 return rod.copyWith(toY: avg);
//                               }).toList(),
//                             );
//                           }
//                         });
//                       },
//                     ),
//                     titlesData: FlTitlesData(
//                       show: true,
//                       rightTitles: AxisTitles(
//                         sideTitles: SideTitles(showTitles: false),
//                       ),
//                       topTitles: AxisTitles(
//                         sideTitles: SideTitles(showTitles: false),
//                       ),
//                       bottomTitles: AxisTitles(
//                         sideTitles: SideTitles(
//                           showTitles: true,
//                           getTitlesWidget: bottomTitles,
//                           reservedSize: 42,
//                         ),
//                       ),
//                       leftTitles: AxisTitles(
//                         sideTitles: SideTitles(
//                           showTitles: true,
//                           reservedSize: 28,
//                           interval: 1,
//                           getTitlesWidget: leftTitles,
//                         ),
//                       ),
//                     ),
//                     borderData: FlBorderData(
//                       show: false,
//                     ),
//                     barGroups: showingBarGroups,
//                     gridData: FlGridData(show: false),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 12,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget leftTitles(double value, TitleMeta meta) {
//     const style = TextStyle(
//       color: Color(0xff7589a2),
//       fontWeight: FontWeight.bold,
//       fontSize: 14,
//     );
//     String text;
//     if (value == 0) {
//       text = '1K';
//     } else if (value == 10) {
//       text = '5K';
//     } else if (value == 19) {
//       text = '10K';
//     } else {
//       return Container();
//     }
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       space: 0,
//       child: Text(text, style: style),
//     );
//   }

//   Widget bottomTitles(double value, TitleMeta meta) {
//     final titles = <String>['Mn', 'Te', 'Wd', 'Tu', 'Fr', 'St', 'Su'];

//     final Widget text = Text(
//       titles[value.toInt()],
//       style: const TextStyle(
//         color: Color(0xff7589a2),
//         fontWeight: FontWeight.bold,
//         fontSize: 14,
//       ),
//     );

//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       space: 16, //margin top
//       child: text,
//     );
//   }

//   BarChartGroupData makeGroupData(int x, double y1, double y2) {
//     return BarChartGroupData(
//       barsSpace: 4,
//       x: x,
//       barRods: [
//         BarChartRodData(
//           toY: y1,
//           color: leftBarColor,
//           width: width,
//         ),
//         BarChartRodData(
//           toY: y2,
//           color: rightBarColor,
//           width: width,
//         ),
//       ],
//     );
//   }

//   Widget makeTransactionsIcon() {
//     const width = 4.5;
//     const space = 3.5;
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         Container(
//           width: width,
//           height: 10,
//           color: Colors.white.withOpacity(0.4),
//         ),
//         const SizedBox(
//           width: space,
//         ),
//         Container(
//           width: width,
//           height: 28,
//           color: Colors.white.withOpacity(0.8),
//         ),
//         const SizedBox(
//           width: space,
//         ),
//         Container(
//           width: width,
//           height: 42,
//           color: Colors.white.withOpacity(1),
//         ),
//         const SizedBox(
//           width: space,
//         ),
//         Container(
//           width: width,
//           height: 28,
//           color: Colors.white.withOpacity(0.8),
//         ),
//         const SizedBox(
//           width: space,
//         ),
//         Container(
//           width: width,
//           height: 10,
//           color: Colors.white.withOpacity(0.4),
//         ),
//       ],
//     );
//   }
// }

import 'package:pmsmbileapp/screens/samples/indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: showingSections(),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Indicator(
                  color: Color(0xff0293ee),
                  text: 'First',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xfff8b250),
                  text: 'Second',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xff845bef),
                  text: 'Third',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xff13d38e),
                  text: 'Fourth',
                  isSquare: true,
                ),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        default:
          throw Error();
      }
    });
  }
}