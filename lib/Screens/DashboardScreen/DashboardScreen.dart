import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trackofyapp/Screens/HomeScreen/HomeScreen.dart';
import 'package:trackofyapp/Widgets/drawer.dart';
import 'package:trackofyapp/constants.dart';

import 'package:charts_flutter_new/flutter.dart' as charts;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  List<CircularStackEntry> data = <CircularStackEntry>[
    new CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(500.0, Colors.red[200], rankKey: 'Q1'),
        new CircularSegmentEntry(1000.0, Colors.green[200], rankKey: 'Q2'),
        new CircularSegmentEntry(2000.0, Colors.blue[200], rankKey: 'Q3'),
        new CircularSegmentEntry(1000.0, Colors.yellow[200], rankKey: 'Q4'),
      ],
      rankKey: 'Quarterly Profits',
    ),
  ];

  final List<NewBooks> data1 = [
    NewBooks(
      year: "> 500 kms",
      books: 12,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    NewBooks(
      year: "400-500 kms",
      books: 2,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    NewBooks(
      year: "300-400 kms",
      books: 4,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    NewBooks(
      year: "200-300 kms",
      books: 1,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    NewBooks(
      year: "100-200 kms",
      books: 6,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    NewBooks(
      year: "0-100 kms",
      books: 0,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
  ];

  List<SalesData> chartData = [
    SalesData(0, 30),
    SalesData(1, 7),
    SalesData(2, 2),
    SalesData(3, 1),
    SalesData(4, 12)
  ];

  List<SalesData> BVA = [
    SalesData(0 - 10, 78),
    // SalesData(1, 7),
    // SalesData(2, 2),
    // SalesData(3, 1),
    // SalesData(4, 12)
  ];

  @override
  Widget build(BuildContext context) {
    List<charts.Series<NewBooks, String>> series = [
      charts.Series(
        id: "Subscribers",
        data: data1,
        domainFn: (NewBooks series, _) => series.year,
        measureFn: (NewBooks series, _) => series.books,
        colorFn: (NewBooks series, _) => series.barColor,
      ),
    ];
    return Scaffold(
      key: scaffoldKey,
      drawer: DrawerClass(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () {
                scaffoldKey.currentState!.openDrawer();
              },
              child: Icon(
                Icons.menu,
                color: Color(0xff1574a4),
              )),
          centerTitle: false,
          title: Image.asset(
            "assets/images/logo.png",
            height: 40,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Get.to(() => HomeScreen());
                      },
                      child: Icon(
                        Icons.home,
                        color: ThemeColor.primarycolor,
                        size: 27,
                      )),
                  SizedBox(
                    width: Get.size.width * 0.04,
                  ),
                  Image.asset(
                    "assets/images/globe-512.png",
                    height: 27,
                    width: 27,
                    color: ThemeColor.primarycolor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Container(
              //   height: Get.size.height * 0.18,
              //
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: 1,
              //     itemBuilder: (BuildContext context, int index) {
              //       return Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 3.0),
              //         child: Row(
              //           children: [
              //             Container(
              //               height: Get.size.height * 0.13,
              //               width: Get.size.width * 0.23,
              //               decoration: BoxDecoration(
              //
              //                 color: Colors.grey,
              //                 borderRadius: BorderRadius.circular(10),
              //
              //               ),
              //               child:Padding(
              //                   padding: const EdgeInsets.all(20.0),
              //                   child: TweenAnimationBuilder<double>(
              //                     tween: Tween<double>(begin: 0.0, end: 1),
              //                     duration: const Duration(milliseconds: 3500),
              //                     builder: (context, value, _) => Transform.scale(
              //                       scale: 1.0,
              //                       child: CircularProgressIndicator(
              //                         value: 5/73,
              //                         backgroundColor: Colors.white,
              //                         strokeWidth: 15,
              //                         valueColor: AlwaysStoppedAnimation(Colors.green),
              //                       ),
              //                     ),
              //                   )
              //               ),
              //
              //             ),
              //             SizedBox(width: 10,),
              //             Container(
              //               height: Get.size.height * 0.13,
              //               width: Get.size.width * 0.23,
              //               decoration: BoxDecoration(
              //
              //                 color: Colors.grey,
              //                 borderRadius: BorderRadius.circular(10),
              //
              //               ),
              //               child:Padding(
              //                   padding: const EdgeInsets.all(20.0),
              //                   child: TweenAnimationBuilder<double>(
              //                     tween: Tween<double>(begin: 0.0, end: 1),
              //                     duration: const Duration(milliseconds: 3500),
              //                     builder: (context, value, _) => Transform.scale(
              //                       scale: 1.0,
              //                       child: CircularProgressIndicator(
              //                         value: 17/73,
              //                         backgroundColor: Colors.white,
              //                         strokeWidth: 15,
              //                         valueColor: AlwaysStoppedAnimation(Colors.red),
              //                       ),
              //                     ),
              //                   )
              //               ),
              //
              //             ),
              //             SizedBox(width: 10,),
              //             Container(
              //               height: Get.size.height * 0.13,
              //               width: Get.size.width * 0.23,
              //               decoration: BoxDecoration(
              //
              //                 color: Colors.grey,
              //                 borderRadius: BorderRadius.circular(10),
              //
              //               ),
              //               child:Padding(
              //                   padding: const EdgeInsets.all(20.0),
              //                   child: TweenAnimationBuilder<double>(
              //                     tween: Tween<double>(begin: 0.0, end: 1),
              //                     duration: const Duration(milliseconds: 3500),
              //                     builder: (context, value, _) => Transform.scale(
              //                       scale: 1.0,
              //                       child: CircularProgressIndicator(
              //                         value: 2/73,
              //                         backgroundColor: Colors.white,
              //                         strokeWidth: 15,
              //                         valueColor: AlwaysStoppedAnimation(Colors.yellow),
              //                       ),
              //                     ),
              //                   )
              //               ),
              //
              //             ),
              //             SizedBox(width: 10,),
              //             Container(
              //               height: Get.size.height * 0.13,
              //               width: Get.size.width * 0.23,
              //               decoration: BoxDecoration(
              //
              //                 color: Colors.grey,
              //                 borderRadius: BorderRadius.circular(10),
              //
              //               ),
              //               child:Padding(
              //                   padding: const EdgeInsets.all(20.0),
              //                   child: TweenAnimationBuilder<double>(
              //                     tween: Tween<double>(begin: 0.0, end: 1),
              //                     duration: const Duration(milliseconds: 3500),
              //                     builder: (context, value, _) => Transform.scale(
              //                       scale: 1.0,
              //                       child: CircularProgressIndicator(
              //                         value: 45/73,
              //                         backgroundColor: Colors.white,
              //                         strokeWidth: 15,
              //                         valueColor: AlwaysStoppedAnimation(Colors.black),
              //                       ),
              //                     ),
              //                   )
              //               ),
              //
              //             ),
              //           ],
              //         ),
              //       );
              //     }
              //
              //   ),
              // ),

              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    //color: Colors.white60,
                    height: 100,
                    width: 80,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.grey),
                    child: AnimatedCircularChart(
                      //key: _chartKey,
                      holeRadius: 5,
                      size: const Size(150.0, 0.0),
                      initialChartData: <CircularStackEntry>[
                        new CircularStackEntry(
                          <CircularSegmentEntry>[
                            new CircularSegmentEntry(
                              33.33,
                              Colors.blue[400],
                              rankKey: 'completed',
                            ),
                            new CircularSegmentEntry(
                              66.67,
                              Colors.blueGrey[600],
                              rankKey: 'remaining',
                            ),
                          ],
                          rankKey: 'progress',
                        ),
                      ],
                      duration: 2.seconds,
                      chartType: CircularChartType.Radial,
                      edgeStyle: SegmentEdgeStyle.round,
                      percentageValues: true,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    //color: Colors.white60,
                    height: 100,
                    width: 80,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.grey),
                    child: AnimatedCircularChart(
                      //key: _chartKey,
                      holeRadius: 5,
                      size: const Size(150.0, 0.0),
                      initialChartData: <CircularStackEntry>[
                        new CircularStackEntry(
                          <CircularSegmentEntry>[
                            new CircularSegmentEntry(
                              33.33,
                              Colors.blue[400],
                              rankKey: 'completed',
                            ),
                            new CircularSegmentEntry(
                              66.67,
                              Colors.blueGrey[600],
                              rankKey: 'remaining',
                            ),
                          ],
                          rankKey: 'progress',
                        ),
                      ],
                      duration: 2.seconds,
                      chartType: CircularChartType.Radial,
                      edgeStyle: SegmentEdgeStyle.round,
                      percentageValues: true,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    //color: Colors.white60,
                    height: 100,
                    width: 80,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.grey),
                    child: AnimatedCircularChart(
                      //key: _chartKey,
                      holeRadius: 5,
                      size: const Size(150.0, 0.0),
                      initialChartData: <CircularStackEntry>[
                        new CircularStackEntry(
                          <CircularSegmentEntry>[
                            new CircularSegmentEntry(
                              33.33,
                              Colors.blue[400],
                              rankKey: 'completed',
                            ),
                            new CircularSegmentEntry(
                              66.67,
                              Colors.blueGrey[600],
                              rankKey: 'remaining',
                            ),
                          ],
                          rankKey: 'progress',
                        ),
                      ],
                      duration: 2.seconds,
                      chartType: CircularChartType.Radial,
                      edgeStyle: SegmentEdgeStyle.round,
                      percentageValues: true,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    //color: Colors.white60,
                    height: 100,
                    width: 80,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.grey),
                    child: AnimatedCircularChart(
                      //key: _chartKey,
                      holeRadius: 5,
                      size: const Size(150.0, 0.0),
                      initialChartData: <CircularStackEntry>[
                        new CircularStackEntry(
                          <CircularSegmentEntry>[
                            new CircularSegmentEntry(
                              33.33,
                              Colors.blue[400],
                              rankKey: 'completed',
                            ),
                            new CircularSegmentEntry(
                              66.67,
                              Colors.blueGrey[600],
                              rankKey: 'remaining',
                            ),
                          ],
                          rankKey: 'progress',
                        ),
                      ],
                      duration: 2.seconds,
                      chartType: CircularChartType.Radial,
                      edgeStyle: SegmentEdgeStyle.round,
                      percentageValues: true,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 10,
              ),

              // backgroundColor: Colors.redAccent,
              // valueColor: AlwaysStoppedAnimation(Colors.green),
              // strokeWidth: 15,
              MaterialButton(
                minWidth: double.infinity,
                onPressed: () {},
                color: ThemeColor.bluecolor,
                child: Text(
                  "Total(73)",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 10,
                child: Container(
                  color: Colors.grey,
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  height: Get.size.height * 0.3,
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 70.0),
                    child: Column(
                      children: [
                        // Padding(
                        //   padding: EdgeInsets.only(left: 10),
                        //   child: Text("VECHILE STATUS"),
                        // ),
                        Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0.0, end: 1),
                              duration: const Duration(milliseconds: 3500),
                              builder: (context, value, _) => Transform.scale(
                                scale: 3.2,
                                child: CircularProgressIndicator(
                                  value: value,
                                  strokeWidth: 15,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.blue),
                                ),
                              ),
                            )
                            // Transform.scale(
                            //   scale: 2.2,
                            //   alignment: Alignment.topLeft,
                            //   child: CircularProgressIndicator(
                            //     value: 100/100,
                            //     backgroundColor: Colors.white,
                            //     valueColor: AlwaysStoppedAnimation(Colors.blue),
                            //     strokeWidth: 35,
                            //   ),
                            // ),
                            ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 10,
                child: Container(
                  color: Colors.grey,
                ),
              ),
              Container(
                height: 220,
                padding: EdgeInsets.all(5),
                child: Card(
                    child: Column(
                  children: <Widget>[
                    Text(
                      "DISTANCE ANALYSIS",
                      style: TextStyle(fontSize: 10.0),
                    ),
                    Expanded(
                      child: charts.BarChart(
                        series,
                        animate: true,
                        vertical: false,
                        flipVerticalAxis: false,
                      ),
                    ),
                    SizedBox(
                      height: 1,
                    )
                  ],
                )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 100,
                    width: 150,
                    color: Color(0xFFffd6f5),
                    child: Text("Halt Analysis"),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Container(
                    height: 100,
                    width: 150,
                    color: Color(0xFFffd6f5),
                    child: Text("Running Analysis"),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 100,
                    width: 150,
                    color: Color(0xFFffd6f5),
                    child: Text("Idle Analysis"),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Container(
                    height: 100,
                    width: 150,
                    color: Color(0xFFffd6f5),
                    child: Text("Engine Hour"),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: 10,
                child: Container(
                  color: Colors.grey,
                ),
              ),
              Container(
                height: 220,
                child: SfCartesianChart(
                    title: ChartTitle(text: "HALT STATUS"),
                    backgroundColor: Colors.white10,
                    series: <ChartSeries>[
                      AreaSeries<SalesData, double>(
                          color: Colors.lightBlue,
                          animationDuration: 5,
                          markerSettings: MarkerSettings(
                              shape: DataMarkerType.horizontalLine),
                          dataSource: chartData,
                          xValueMapper: (SalesData sales, _) => sales.year,
                          yValueMapper: (SalesData sales, _) => sales.sales)
                    ]),
              ),

              SizedBox(
                width: double.infinity,
                height: 10,
                child: Container(
                  color: Colors.grey,
                ),
              ),
              Container(
                height: 220,
                child: SfCartesianChart(
                    title: ChartTitle(text: "Battery Voltage Analysis"),
                    backgroundColor: Colors.white10,
                    series: <ChartSeries>[
                      AreaSeries<SalesData, double>(
                          color: Colors.lightBlue,
                          animationDuration: 5,
                          markerSettings: MarkerSettings(
                              shape: DataMarkerType.horizontalLine),
                          dataSource: BVA,
                          xValueMapper: (SalesData sales, _) => sales.year,
                          yValueMapper: (SalesData sales, _) => sales.sales)
                    ]),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 100,
                    width: 150,
                    color: Color(0xFFffd6f5),
                    child: Text("Halt Analysis"),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Container(
                    height: 100,
                    width: 150,
                    color: Color(0xFFffd6f5),
                    child: Text("Running Analysis"),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 100,
                    width: 150,
                    color: Color(0xFFffd6f5),
                    child: Text("Idle Analysis"),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Container(
                    height: 100,
                    width: 150,
                    color: Color(0xFFffd6f5),
                    child: Text("Engine Hour"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewBooks {
  late final String year;
  late final int books;
  late final charts.Color barColor;

  NewBooks({required this.year, required this.books, required this.barColor});
}

class SalesData {
  SalesData(this.year, this.sales);

  final double year;
  final double sales;
}



// Padding(
//   padding: const EdgeInsets.all(30.0),
//   child: Row(
//     children: [
//       CircularProgressIndicator(
//         backgroundColor: Colors.redAccent,
//         valueColor: AlwaysStoppedAnimation(Colors.green),
//         strokeWidth: 40,
//       ),
//       SizedBox(width: 50,),
//       CircularProgressIndicator(
//         backgroundColor: Colors.redAccent,
//         valueColor: AlwaysStoppedAnimation(Colors.green),
//         strokeWidth: 40,
//       ),
//       SizedBox(width: 50,),
//       CircularProgressIndicator(
//         backgroundColor: Colors.redAccent,
//         valueColor: AlwaysStoppedAnimation(Colors.green),
//         strokeWidth: 40,
//       ),
//       SizedBox(width: 50,),
//       CircularProgressIndicator(
//         backgroundColor: Colors.redAccent,
//         valueColor: AlwaysStoppedAnimation(Colors.green),
//         strokeWidth: 40,
//       ),
//     ],
//   ),
// ),
