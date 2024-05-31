import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trackofyapp/Screens/DashboardScreen/Vehicle.dart';
import 'package:trackofyapp/Screens/DrawerScreen/NotificationsScreen.dart';
import 'package:trackofyapp/Screens/HomeScreen/HomeScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/drawer.dart';
import 'package:trackofyapp/constants.dart';

import 'package:charts_flutter_new/flutter.dart' as charts;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class NewDashboardScreen extends StatefulWidget {
  const NewDashboardScreen({Key? key}) : super(key: key);

  @override
  State<NewDashboardScreen> createState() => _NewDashboardScreenState();
}

class _NewDashboardScreenState extends State<NewDashboardScreen> {
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

  var vehicleStatusCount;
  var vehicleStatusCountTotal;
  var haltDuration;
  var runningDuration;
  var idleDuration;
  var engineHour;
  var alertData;
  var alertDetailData;
  var overSpeed;
  var maintenance;
  var deviceRenewal;
  var geoFenceAlert;
  var serviceLimitCount;
  var vehiclePerformance;
  var haltStatus;
  var distanceDetail;
  var locations;
  var locationMaxDist = 0;
  double maxVPerformance = 10;
  List<_ChartData> locationData = [];
  TooltipBehavior _tooltip = TooltipBehavior();

  String startDate = "";
  String endDate = "";

  @override
  void initState() {
    super.initState();
    startDate = DateFormat('yyyy-MM-dd').format(DateTime.now()) + " 00:00:00";
    endDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    print(startDate);
    print(endDate);
    fetchData(startDate, endDate);
  }

  void haltDurationfunc(String s, String e) async {
    haltDuration = await ApiService.haltDuration(s, e);
    print(haltDuration["max_halt_duration"] == null);
    setState(() {});
  }

  void vehiclePerformanceDurationFunc(String s) async {
    vehiclePerformance = await ApiService.getVehiclePerformance(s);
    if (maxVPerformance <
        double.parse(vehiclePerformance["Excellent"].toString())) {
      maxVPerformance =
          double.parse(vehiclePerformance["Excellent"].toString());
    }
    if (maxVPerformance < double.parse(vehiclePerformance["Good"].toString())) {
      maxVPerformance = double.parse(vehiclePerformance["Good"].toString());
    }
    if (maxVPerformance <
        double.parse(vehiclePerformance["Average"].toString())) {
      maxVPerformance = double.parse(vehiclePerformance["Average"].toString());
    }
    if (maxVPerformance < double.parse(vehiclePerformance["Poor"].toString())) {
      maxVPerformance = double.parse(vehiclePerformance["Poor"].toString());
    }
    setState(() {});
  }

  void engineHourfunc(String s, String e) async {
    engineHour = await ApiService.engineHour(s, e);
    setState(() {});
  }

  void runningDurationfunc(String s, String e) async {
    runningDuration = await ApiService.runningDuration(s, e);
    setState(() {});
  }

  void idleDurationfunc(String s, String e) async {
    idleDuration = await ApiService.idleDuration(s, e);
    setState(() {});
  }

  void alertDatafunc(String s, String e) async {
    alertData = await ApiService.alertData(s, e);
    setState(() {});
  }

  void overSpeedfunc(String s, String e) async {
    overSpeed = await ApiService.overSpeed(s, e);
    setState(() {});
  }

  void maintenancefunc() async {
    maintenance = await ApiService.maintenance();
    setState(() {});
  }

  void deviceRenewalfunc() async {
    deviceRenewal = await ApiService.deviceRenewal();
    setState(() {});
  }

  fetchData(String s, String e) async {
    s = startDate;
    e = endDate;
    SmartDialog.showLoading(msg: "Loading...");
    vehicleStatusCount = await ApiService.vehicleSummaryStatus();
    vehicleStatusCountTotal = vehicleStatusCount["running"]["total"] +
        vehicleStatusCount["stop"]["total"] +
        vehicleStatusCount["idle"]["total"] +
        vehicleStatusCount["nodata"]["total"];

    haltDuration = await ApiService.haltDuration(s, e);
    runningDuration = await ApiService.runningDuration(s, e);
    idleDuration = await ApiService.idleDuration(s, e);
    engineHour = await ApiService.engineHour(s, e);
    alertData = await ApiService.alertData(s, e);
    alertDetailData = await ApiService.alertDetailData(s, e);
    overSpeed = await ApiService.overSpeed(s, e);
    maintenance = await ApiService.maintenance();
    deviceRenewal = await ApiService.deviceRenewal();
    geoFenceAlert = await ApiService.geoFenceAlert();
    serviceLimitCount = await ApiService.getServiceLimitCount();

    vehiclePerformance = await ApiService.getVehiclePerformance("Yesterday");
    if (maxVPerformance <
        double.parse(vehiclePerformance["Excellent"].toString())) {
      maxVPerformance =
          double.parse(vehiclePerformance["Excellent"].toString());
    }
    if (maxVPerformance < double.parse(vehiclePerformance["Good"].toString())) {
      maxVPerformance = double.parse(vehiclePerformance["Good"].toString());
    }
    if (maxVPerformance <
        double.parse(vehiclePerformance["Average"].toString())) {
      maxVPerformance = double.parse(vehiclePerformance["Average"].toString());
    }
    if (maxVPerformance < double.parse(vehiclePerformance["Poor"].toString())) {
      maxVPerformance = double.parse(vehiclePerformance["Poor"].toString());
    }
    haltStatus = await ApiService.getHaltStatus();
    distanceDetail = await ApiService.getDistanceDetail();
    locations = await ApiService.getControlLocation();
    for (var location in locations) {
      locationData.add(_ChartData(location["location"],
          double.parse(location["location_count"].toString())));
      if (locationMaxDist < int.parse(location["location_count"].toString())) {
        locationMaxDist = location["location_count"];
      }
    }
    SmartDialog.dismiss();

    setState(() {});
  }

  var items = ["Today", "Yesterday", "Last Week", "This Month"];
  String dropdownvalue = '';

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
          backgroundColor: Color.fromRGBO(34, 37, 46, 1),
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () {
                scaffoldKey.currentState!.openDrawer();
              },
              child: Icon(
                Icons.menu,
                color: Colors.white70,
              )),
          centerTitle: true,
          title: Image.asset(
            "assets/images/logo.png",
            color: Colors.white70,
            height: 50,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Get.offAll(() => HomeScreen());
                      },
                      child: Icon(
                        Icons.home,
                        color: Colors.white70,
                        size: 30,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        Get.to(() => Vehicle(ids: ""));
                      },
                      child: Image.asset(
                        "assets/images/globe-512.png",
                        height: 30,
                        width: 30,
                        color: Colors.white70,
                      )),
                ],
              ),
            )
          ],
        ),
      ),
      body: Scaffold(
        //  backgroundColor: Color.fromRGBO(46, 46, 72, 1),
        body: RefreshIndicator(
          onRefresh: () async {
            startDate =
                DateFormat('yyyy-MM-dd').format(DateTime.now()) + " 00:00:00";
            endDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
            await fetchData(startDate, endDate);
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(46, 46, 80, 1),
                  Color.fromRGBO(66, 70, 120, 1),
                ],
                tileMode: TileMode.mirror,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [
                  0.6,
                  0.9,
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (vehicleStatusCount != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                    color: Colors.blueGrey[400],
                                    value: vehicleStatusCount["nodata"]
                                            ["total"] *
                                        1.0,
                                    radius: 40,
                                    title:
                                        "${double.parse((vehicleStatusCount["nodata"]["total"] / vehicleStatusCountTotal * 100).toString()).toStringAsFixed(1)}%",
                                    titleStyle: TextStyle(color: Colors.white)),
                                PieChartSectionData(
                                    color: Colors.green[400],
                                    value: vehicleStatusCount["running"]
                                            ["total"] *
                                        1.0,
                                    radius: 40,
                                    title:
                                        "${double.parse((vehicleStatusCount["running"]["total"] / vehicleStatusCountTotal * 100).toString()).toStringAsFixed(1)}%",
                                    titleStyle: TextStyle(color: Colors.white)),
                                PieChartSectionData(
                                    color: Colors.red[400],
                                    value: vehicleStatusCount["stop"]["total"] *
                                        1.0,
                                    radius: 40,
                                    title:
                                        "${double.parse((vehicleStatusCount["stop"]["total"] / vehicleStatusCountTotal * 100).toString()).toStringAsFixed(1)}%",
                                    titleStyle: TextStyle(color: Colors.white)),
                                PieChartSectionData(
                                    color: Colors.yellow[400],
                                    value: vehicleStatusCount["idle"]["total"] *
                                        1.0,
                                    radius: 40,
                                    title:
                                        "${double.parse((vehicleStatusCount["idle"]["total"] / vehicleStatusCountTotal * 100).toString()).toStringAsFixed(1)}%",
                                    titleStyle: TextStyle(color: Colors.white)),
                              ],
                              centerSpaceRadius: 48,
                              sectionsSpace: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  if (vehicleStatusCount != null)
                    Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.to(() => Vehicle(
                                    ids: vehicleStatusCount["running"]
                                            ["total_vehicle_ids"]
                                        .toString(),
                                  ));
                            },
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green,
                                    blurRadius: 20,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                                color: Colors.green.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.directions_walk,
                                      color: Colors.green[100], size: 24),
                                  SizedBox(height: 8),
                                  Text(
                                    "Running",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "${vehicleStatusCount["running"]["total"]}",
                                    style: TextStyle(
                                      color: Colors.green[100],
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.to(() => Vehicle(
                                    ids: vehicleStatusCount["stop"]
                                            ["total_vehicle_ids"]
                                        .toString(),
                                  ));
                            },
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red,
                                    blurRadius: 20,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                                color: Colors.red.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.directions_walk,
                                      color: Colors.red[100], size: 24),
                                  SizedBox(height: 8),
                                  Text(
                                    "Stopped",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "${vehicleStatusCount["stop"]["total"]}",
                                    style: TextStyle(
                                      color: Colors.red[100],
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.to(() => Vehicle(
                                    ids: vehicleStatusCount["idle"]
                                            ["total_vehicle_ids"]
                                        .toString(),
                                  ));
                            },
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.yellow,
                                    blurRadius: 20,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                                color: Colors.yellow[800]?.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.directions_walk,
                                      color: Colors.yellow[100], size: 24),
                                  SizedBox(height: 8),
                                  Text(
                                    "Idle",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "${vehicleStatusCount["idle"]["total"]}",
                                    style: TextStyle(
                                      color: Colors.yellow[100],
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.to(() => Vehicle(
                                    ids: vehicleStatusCount["nodata"]
                                            ["total_vehicle_ids"]
                                        .toString(),
                                  ));
                            },
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 20,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                                color: Colors.grey[800]?.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.wifi_off,
                                      color: Colors.grey[300], size: 24),
                                  SizedBox(height: 8),
                                  Text(
                                    "No Data",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "${vehicleStatusCount["nodata"]["total"]}",
                                    style: TextStyle(
                                      color: Colors.grey[300],
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(width: 8),
                        Container(
                          width: 160,
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            //  color: Color.fromRGBO(51, 57, 95, 1),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(49, 55, 95, 1),
                                Color.fromRGBO(66, 70, 120, 1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomCenter,
                              stops: [
                                0.6,
                                0.9,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Text(
                                    "Halt",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 3),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      isExpanded: true,
                                      isDense: true,
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color: Colors.white,
                                      ),
                                      // Array list of items
                                      items: items.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                          onTap: () {
                                            if (items == "Today") {
                                              startDate = DateFormat(
                                                          'yyyy-MM-dd')
                                                      .format(DateTime.now()) +
                                                  " 00:00:00";
                                              endDate = DateFormat(
                                                      'yyyy-MM-dd HH:mm:ss')
                                                  .format(DateTime.now());
                                              // startDate = "2023-10-12 00:00:00";
                                              // endDate = "2023-10-12 12:00:00";
                                              print(startDate);
                                              print(endDate);
                                              haltDurationfunc(
                                                  startDate, endDate);
                                            } else if (items == "Yesterday") {
                                              startDate = DateFormat(
                                                          'yyyy-MM-dd')
                                                      .format(DateTime.now()
                                                          .subtract(Duration(
                                                              days: 1))) +
                                                  " 00:00:00";
                                              endDate = DateFormat(
                                                      'yyyy-MM-dd HH:mm:ss')
                                                  .format(DateTime.now()
                                                      .subtract(
                                                          Duration(days: 1)));
                                              // startDate = "2023-10-12 00:00:00";
                                              // endDate = "2023-10-12 12:00:00";
                                              print(startDate);
                                              print(endDate);
                                              haltDurationfunc(
                                                  startDate, endDate);
                                            } else if (items == "Last Week") {
                                              startDate = DateFormat(
                                                          'yyyy-MM-dd')
                                                      .format(DateTime.now()
                                                          .subtract(Duration(
                                                              days: DateTime
                                                                          .now()
                                                                      .weekday -
                                                                  1 +
                                                                  7))) +
                                                  " 00:00:00";
                                              endDate = DateFormat('yyyy-MM-dd')
                                                      .format(DateTime.now()
                                                          .subtract(Duration(
                                                              days: DateTime
                                                                      .now()
                                                                  .weekday))) +
                                                  " 23:59:59";
                                              // startDate = "2023-10-12 00:00:00";
                                              // endDate = "2023-10-12 12:00:00";
                                              print(startDate);
                                              print(endDate);
                                              haltDurationfunc(
                                                  startDate, endDate);
                                            } else if (items == "This Month") {
                                              final now = DateTime.now();

                                              var date = DateTime(
                                                      now.year, now.month, 1)
                                                  .toString();

                                              var startDate = DateFormat(
                                                      'yyyy-MM-dd 00:00:00')
                                                  .format(DateTime.parse(date));
                                              var eDate = DateTime(now.year,
                                                      now.month + 1, 0)
                                                  .toString();
                                              endDate = DateFormat(
                                                      'yyyy-MM-dd 23:59:59')
                                                  .format(
                                                      DateTime.parse(eDate));
                                              print(startDate);
                                              print(endDate);
                                              // startDate = "2023-10-12 00:00:00";
                                              // endDate = "2023-10-12 12:00:00";
                                              haltDurationfunc(
                                                  startDate, endDate);
                                            }
                                          },
                                        );
                                      }).toList(),
                                      // After selecting the desired option,it will
                                      // change button value to selected value
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownvalue = newValue!;
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color.fromRGBO(76, 84, 122, 1),
                                    ),
                                    child: Icon(Icons.time_to_leave,
                                        color: Colors.blueGrey[300], size: 24),
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Max",
                                          style: TextStyle(color: Colors.grey)),
                                      Text(
                                          haltDuration == null ||
                                                  haltDuration[
                                                          "max_halt_duration"] ==
                                                      null
                                              ? "0h 0m"
                                              : haltDuration[
                                                      "max_halt_duration"]
                                                  .toString(),
                                          style: TextStyle(
                                              color: Colors.grey[300])),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color.fromRGBO(76, 84, 122, 1),
                                    ),
                                    child: Icon(Icons.timer_outlined,
                                        color: Colors.blueGrey[300], size: 24),
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Duration",
                                          style: TextStyle(color: Colors.grey)),
                                      Text(
                                          haltDuration == null ||
                                                  haltDuration[
                                                          "total_halt_duration"] ==
                                                      null
                                              ? "0"
                                              : haltDuration[
                                                      "total_halt_duration"]
                                                  .toString(),
                                          style: TextStyle(
                                              color: Colors.grey[300])),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: 160,
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(49, 55, 95, 0.8),
                                Color.fromRGBO(66, 70, 120, 1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomCenter,
                              stops: [
                                0.6,
                                0.9,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Text(
                                    "Running",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      top: 3,
                                    ),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      isExpanded: true,
                                      isDense: true,
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color: Colors.white,
                                      ),
                                      // Array list of items
                                      items: items.map((String items) {
                                        return DropdownMenuItem(
                                          //  alignment: Alignment.centerRight,
                                          value: items,
                                          child: Container(
                                            width: 100,
                                            child: Text(items),
                                          ),
                                          onTap: () {
                                            if (items == "Today") {
                                              startDate = DateFormat(
                                                          'yyyy-MM-dd')
                                                      .format(DateTime.now()) +
                                                  " 00:00:00";
                                              endDate = DateFormat(
                                                      'yyyy-MM-dd HH:mm:ss')
                                                  .format(DateTime.now());
                                              // startDate = "2023-10-12 00:00:00";
                                              // endDate = "2023-10-17 12:00:00";
                                              print(startDate);
                                              print(endDate);
                                              runningDurationfunc(
                                                  startDate, endDate);
                                            } else if (items == "Yesterday") {
                                              startDate = DateFormat(
                                                          'yyyy-MM-dd')
                                                      .format(DateTime.now()
                                                          .subtract(Duration(
                                                              days: 1))) +
                                                  " 00:00:00";
                                              endDate = DateFormat(
                                                      'yyyy-MM-dd HH:mm:ss')
                                                  .format(DateTime.now()
                                                      .subtract(
                                                          Duration(days: 1)));
                                              // startDate = "2023-10-12 00:00:00";
                                              // endDate = "2023-10-12 12:00:00";
                                              print(startDate);
                                              print(endDate);
                                              runningDurationfunc(
                                                  startDate, endDate);
                                            } else if (items == "Last Week") {
                                              startDate = DateFormat(
                                                          'yyyy-MM-dd')
                                                      .format(DateTime.now()
                                                          .subtract(Duration(
                                                              days: DateTime
                                                                          .now()
                                                                      .weekday -
                                                                  1 +
                                                                  7))) +
                                                  " 00:00:00";
                                              endDate = DateFormat('yyyy-MM-dd')
                                                      .format(DateTime.now()
                                                          .subtract(Duration(
                                                              days: DateTime
                                                                      .now()
                                                                  .weekday))) +
                                                  " 23:59:59";
                                              // startDate = "2023-10-12 00:00:00";
                                              // endDate = "2023-10-12 12:00:00";
                                              print(startDate);
                                              print(endDate);
                                              runningDurationfunc(
                                                  startDate, endDate);
                                            } else if (items == "This Month") {
                                              final now = DateTime.now();

                                              var date = DateTime(
                                                      now.year, now.month, 1)
                                                  .toString();

                                              var startDate = DateFormat(
                                                      'yyyy-MM-dd 00:00:00')
                                                  .format(DateTime.parse(date));
                                              var eDate = DateTime(now.year,
                                                      now.month + 1, 0)
                                                  .toString();
                                              endDate = DateFormat(
                                                      'yyyy-MM-dd 23:59:59')
                                                  .format(
                                                      DateTime.parse(eDate));
                                              print(startDate);
                                              print(endDate);
                                              // startDate = "2023-10-12 00:00:00";
                                              // endDate = "2023-10-12 12:00:00";
                                              runningDurationfunc(
                                                  startDate, endDate);
                                            }
                                          },
                                        );
                                      }).toList(),
                                      // After selecting the desired option,it will
                                      // change button value to selected value
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownvalue = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color.fromRGBO(76, 84, 122, 1),
                                    ),
                                    child: Icon(Icons.time_to_leave,
                                        color: Colors.blueGrey[300], size: 24),
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Max",
                                          style: TextStyle(color: Colors.grey)),
                                      Text(
                                          runningDuration == null ||
                                                  runningDuration[
                                                          "max_halt_duration"] ==
                                                      null
                                              ? "0h 0m"
                                              : runningDuration[
                                                      "max_halt_duration"]
                                                  .toString(),
                                          style: TextStyle(
                                              color: Colors.grey[300])),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color.fromRGBO(76, 84, 122, 1),
                                    ),
                                    child: Icon(Icons.timer_outlined,
                                        color: Colors.blueGrey[300], size: 24),
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Duration",
                                          style: TextStyle(color: Colors.grey)),
                                      Text(
                                          runningDuration == null ||
                                                  runningDuration[
                                                          "total_halt_duration"] ==
                                                      null
                                              ? "0"
                                              : runningDuration[
                                                      "total_halt_duration"]
                                                  .toString(),
                                          style: TextStyle(
                                              color: Colors.grey[300])),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: 160,
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(49, 55, 95, 0.8),
                                Color.fromRGBO(66, 70, 120, 1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomCenter,
                              stops: [
                                0.6,
                                0.9,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Text(
                                    "Idle",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(top: 3),
                                      child: DropdownButton(
                                        underline: SizedBox(),
                                        isExpanded: true,
                                        isDense: true,
                                        // Initial Value
                                        //  value: dropdownvalue,
                                        // Down Arrow Icon
                                        icon: const Icon(
                                          Icons.more_vert,
                                          color: Colors.white,
                                        ),
                                        // Array list of items
                                        items: items.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                            onTap: () {
                                              if (items == "Today") {
                                                startDate = DateFormat(
                                                            'yyyy-MM-dd')
                                                        .format(
                                                            DateTime.now()) +
                                                    " 00:00:00";
                                                endDate = DateFormat(
                                                        'yyyy-MM-dd HH:mm:ss')
                                                    .format(DateTime.now());
                                                // startDate = "2023-10-12 00:00:00";
                                                // endDate = "2023-10-12 12:00:00";
                                                idleDurationfunc(
                                                    startDate, endDate);
                                              } else if (items == "Yesterday") {
                                                startDate = DateFormat(
                                                            'yyyy-MM-dd')
                                                        .format(DateTime.now()
                                                            .subtract(Duration(
                                                                days: 1))) +
                                                    " 00:00:00";
                                                endDate = DateFormat(
                                                        'yyyy-MM-dd HH:mm:ss')
                                                    .format(DateTime.now()
                                                        .subtract(
                                                            Duration(days: 1)));
                                                // startDate = "2023-10-12 00:00:00";
                                                // endDate = "2023-10-12 12:00:00";
                                                idleDurationfunc(
                                                    startDate, endDate);
                                              } else if (items == "Last Week") {
                                                startDate = DateFormat(
                                                            'yyyy-MM-dd')
                                                        .format(DateTime.now()
                                                            .subtract(Duration(
                                                                days: DateTime
                                                                            .now()
                                                                        .weekday -
                                                                    1 +
                                                                    7))) +
                                                    " 00:00:00";
                                                endDate = DateFormat(
                                                            'yyyy-MM-dd')
                                                        .format(DateTime.now()
                                                            .subtract(Duration(
                                                                days: DateTime
                                                                        .now()
                                                                    .weekday))) +
                                                    " 23:59:59";
                                                // startDate = "2023-10-12 00:00:00";
                                                // endDate = "2023-10-12 12:00:00";
                                                print(startDate);
                                                print(endDate);
                                                idleDurationfunc(
                                                    startDate, endDate);
                                              } else if (items ==
                                                  "This Month") {
                                                final now = DateTime.now();

                                                var date = DateTime(
                                                        now.year, now.month, 1)
                                                    .toString();

                                                var startDate = DateFormat(
                                                        'yyyy-MM-dd 00:00:00')
                                                    .format(
                                                        DateTime.parse(date));
                                                var eDate = DateTime(now.year,
                                                        now.month + 1, 0)
                                                    .toString();
                                                endDate = DateFormat(
                                                        'yyyy-MM-dd 23:59:59')
                                                    .format(
                                                        DateTime.parse(eDate));
                                                print(startDate);
                                                print(endDate);
                                                // startDate = "2023-10-12 00:00:00";
                                                // endDate = "2023-10-12 12:00:00";
                                                idleDurationfunc(
                                                    startDate, endDate);
                                              }
                                            },
                                          );
                                        }).toList(),
                                        // After selecting the desired option,it will
                                        // change button value to selected value
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownvalue = newValue!;
                                          });
                                        },
                                      ))
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color.fromRGBO(76, 84, 122, 1),
                                    ),
                                    child: Icon(Icons.time_to_leave,
                                        color: Colors.blueGrey[300], size: 24),
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Max",
                                          style: TextStyle(color: Colors.grey)),
                                      Text(
                                          idleDuration == null ||
                                                  idleDuration[
                                                          "max_idle_duration"] ==
                                                      null
                                              ? "0h 0m"
                                              : idleDuration[
                                                      "max_idle_duration"]
                                                  .toString(),
                                          style: TextStyle(
                                              color: Colors.grey[300])),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color.fromRGBO(76, 84, 122, 1),
                                    ),
                                    child: Icon(Icons.timer_outlined,
                                        color: Colors.blueGrey[300], size: 24),
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Duration",
                                          style: TextStyle(color: Colors.grey)),
                                      Text(
                                          idleDuration == null ||
                                                  idleDuration[
                                                          "total_idle_duration"] ==
                                                      null
                                              ? "0"
                                              : idleDuration[
                                                      "total_idle_duration"]
                                                  .toString(),
                                          style: TextStyle(
                                              color: Colors.grey[300])),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: 160,
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            //  color: Color.fromRGBO(51, 57, 95, 1),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(49, 55, 95, 1),
                                Color.fromRGBO(66, 70, 120, 1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomCenter,
                              stops: [
                                0.6,
                                0.9,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Text(
                                    "Engine",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 3),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      isExpanded: true,
                                      isDense: true,
                                      // Initial Value
                                      //  value: dropdownvalue,
                                      // Down Arrow Icon
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color: Colors.white,
                                      ),
                                      // Array list of items
                                      items: items.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                          onTap: () {
                                            if (items == "Today") {
                                              startDate = DateFormat(
                                                          'yyyy-MM-dd')
                                                      .format(DateTime.now()) +
                                                  " 00:00:00";
                                              endDate = DateFormat(
                                                      'yyyy-MM-dd HH:mm:ss')
                                                  .format(DateTime.now());
                                              // startDate = "2023-10-12 00:00:00";
                                              // endDate = "2023-10-12 12:00:00";
                                              print(startDate);
                                              print(endDate);
                                              engineHourfunc(
                                                  startDate, endDate);
                                            } else if (items == "Yesterday") {
                                              startDate = DateFormat(
                                                          'yyyy-MM-dd')
                                                      .format(DateTime.now()
                                                          .subtract(Duration(
                                                              days: 1))) +
                                                  " 00:00:00";
                                              endDate = DateFormat(
                                                      'yyyy-MM-dd HH:mm:ss')
                                                  .format(DateTime.now()
                                                      .subtract(
                                                          Duration(days: 1)));
                                              // startDate = "2023-10-12 00:00:00";
                                              // endDate = "2023-10-12 12:00:00";
                                              print(startDate);
                                              print(endDate);
                                              engineHourfunc(
                                                  startDate, endDate);
                                            } else if (items == "Last Week") {
                                              startDate = DateFormat(
                                                          'yyyy-MM-dd')
                                                      .format(DateTime.now()
                                                          .subtract(Duration(
                                                              days: DateTime
                                                                          .now()
                                                                      .weekday -
                                                                  1 +
                                                                  7))) +
                                                  " 00:00:00";
                                              endDate = DateFormat('yyyy-MM-dd')
                                                      .format(DateTime.now()
                                                          .subtract(Duration(
                                                              days: DateTime
                                                                      .now()
                                                                  .weekday))) +
                                                  " 23:59:59";
                                              // startDate = "2023-10-12 00:00:00";
                                              // endDate = "2023-10-12 12:00:00";
                                              print(startDate);
                                              print(endDate);
                                              engineHourfunc(
                                                  startDate, endDate);
                                            } else if (items == "This Month") {
                                              final now = DateTime.now();

                                              var date = DateTime(
                                                      now.year, now.month, 1)
                                                  .toString();

                                              var startDate = DateFormat(
                                                      'yyyy-MM-dd 00:00:00')
                                                  .format(DateTime.parse(date));
                                              var eDate = DateTime(now.year,
                                                      now.month + 1, 0)
                                                  .toString();
                                              endDate = DateFormat(
                                                      'yyyy-MM-dd 23:59:59')
                                                  .format(
                                                      DateTime.parse(eDate));
                                              print(startDate);
                                              print(endDate);
                                              // startDate = "2023-10-12 00:00:00";
                                              // endDate = "2023-10-12 12:00:00";
                                              engineHourfunc(
                                                  startDate, endDate);
                                            }
                                          },
                                        );
                                      }).toList(),
                                      // After selecting the desired option,it will
                                      // change button value to selected value
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownvalue = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color.fromRGBO(76, 84, 122, 1),
                                    ),
                                    child: Icon(Icons.time_to_leave,
                                        color: Colors.blueGrey[300], size: 24),
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Max",
                                          style: TextStyle(color: Colors.grey)),
                                      Text(
                                          engineHour == null ||
                                                  engineHour[
                                                          "max_engine_duration"] ==
                                                      null
                                              ? "0h 0m"
                                              : engineHour[
                                                      "max_engine_duration"]
                                                  .toString(),
                                          style: TextStyle(
                                              color: Colors.grey[300])),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color.fromRGBO(76, 84, 122, 1),
                                    ),
                                    child: Icon(Icons.timer_outlined,
                                        color: Colors.blueGrey[300], size: 24),
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Duration",
                                          style: TextStyle(color: Colors.grey)),
                                      Text(
                                          engineHour == null ||
                                                  engineHour[
                                                          "total_engine_duration"] ==
                                                      null
                                              ? "0"
                                              : engineHour[
                                                      "total_engine_duration"]
                                                  .toString(),
                                          style: TextStyle(
                                              color: Colors.grey[300])),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            showAlertDetail();
                          },
                          child: Container(
                            width: 220,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(49, 55, 95, 0.8),
                                  Color.fromRGBO(66, 70, 120, 1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomCenter,
                                stops: [
                                  0.6,
                                  0.9,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Alert",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Color.fromRGBO(
                                                      76, 84, 122, 1),
                                                ),
                                                child: Icon(Icons.time_to_leave,
                                                    color: Colors.blueGrey[300],
                                                    size: 24),
                                              ),
                                              SizedBox(width: 8),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Max",
                                                      style: TextStyle(
                                                          color: Colors.grey)),
                                                  Text(
                                                      alertData != null
                                                          ? "${alertData["max_alert_count"]}"
                                                          : "N/A",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey[300])),
                                                ],
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Color.fromRGBO(
                                                      76, 84, 122, 1),
                                                ),
                                                child: Icon(Icons.bar_chart,
                                                    color: Colors.blueGrey[300],
                                                    size: 24),
                                              ),
                                              SizedBox(width: 8),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Count",
                                                      style: TextStyle(
                                                          color: Colors.grey)),
                                                  Text(
                                                      alertData != null
                                                          ? "${alertData["notification_count"]}"
                                                          : "N/A",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey[300])),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Image.asset("assets/images/new-message.png",
                                        width: 80),
                                  ],
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: 160,
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(49, 55, 95, 0.8),
                                Color.fromRGBO(66, 70, 120, 1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomCenter,
                              stops: [
                                0.6,
                                0.9,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "OverSpeed",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color.fromRGBO(76, 84, 122, 1),
                                    ),
                                    child: Icon(Icons.speed,
                                        color: Colors.blueGrey[300], size: 24),
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Max",
                                          style: TextStyle(color: Colors.grey)),
                                      Text(
                                          "${overSpeed != null ? overSpeed["max_overspeed"] : "N/A"}",
                                          style: TextStyle(
                                              color: Colors.grey[300])),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color.fromRGBO(76, 84, 122, 1),
                                    ),
                                    child: Icon(Icons.speed,
                                        color: Colors.blueGrey[300], size: 24),
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Count",
                                          style: TextStyle(color: Colors.grey)),
                                      Text(
                                          "${overSpeed != null ? overSpeed["overspeed_count"] : "N/A"}",
                                          style: TextStyle(
                                              color: Colors.grey[300])),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: 180,
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(49, 55, 95, 0.8),
                                Color.fromRGBO(66, 70, 120, 1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomCenter,
                              stops: [
                                0.6,
                                0.9,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Maintenance",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color.fromRGBO(76, 84, 122, 1),
                                    ),
                                    child: Icon(Icons.time_to_leave,
                                        color: Colors.blueGrey[300], size: 24),
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Expired",
                                          style: TextStyle(color: Colors.grey)),
                                      Text(
                                          "${maintenance != null ? maintenance["expired_maintainence_count"] : "N/A"}",
                                          style: TextStyle(
                                              color: Colors.grey[300])),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color.fromRGBO(76, 84, 122, 1),
                                    ),
                                    child: Icon(Icons.speed,
                                        color: Colors.blueGrey[300], size: 24),
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Count",
                                          style: TextStyle(color: Colors.grey)),
                                      Text(
                                          "${maintenance != null ? maintenance["maintainence_count"] : "N/A"}",
                                          style: TextStyle(
                                              color: Colors.grey[300])),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: 160,
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(49, 55, 95, 0.8),
                                Color.fromRGBO(66, 70, 120, 1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomCenter,
                              stops: [
                                0.6,
                                0.9,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Renewal",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color.fromRGBO(76, 84, 122, 1),
                                    ),
                                    child: Icon(Icons.time_to_leave,
                                        color: Colors.blueGrey[300], size: 24),
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Expired",
                                          style: TextStyle(color: Colors.grey)),
                                      Text(
                                          "${deviceRenewal != null ? deviceRenewal["expired_count"] : "N/A"}",
                                          style: TextStyle(
                                              color: Colors.grey[300])),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color.fromRGBO(76, 84, 122, 1),
                                    ),
                                    child: Icon(Icons.timer_outlined,
                                        color: Colors.blueGrey[300], size: 24),
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Expiring",
                                          style: TextStyle(color: Colors.grey)),
                                      Text(
                                          "${deviceRenewal != null ? deviceRenewal["expiry_count"] : "N/A"}",
                                          style: TextStyle(
                                              color: Colors.grey[300])),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(49, 55, 95, 0.8),
                          Color.fromRGBO(66, 70, 120, 1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter,
                        stops: [
                          0.6,
                          0.9,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Geofence",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "Inside",
                                    style: TextStyle(
                                      color: Colors.blueGrey[300],
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "${geoFenceAlert != null ? geoFenceAlert["inside_count"] : "0"}",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                width: 1, height: 50, color: Colors.orange),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "Outside",
                                    style: TextStyle(
                                      color: Colors.blueGrey[300],
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "${geoFenceAlert != null ? geoFenceAlert["outside_count"] : "0"}",
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                width: 1, height: 50, color: Colors.orange),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "Count",
                                    style: TextStyle(
                                      color: Colors.blueGrey[300],
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "${geoFenceAlert != null ? geoFenceAlert["notification_count"] : "0"}",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(49, 55, 95, 0.8),
                          Color.fromRGBO(66, 70, 120, 1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter,
                        stops: [
                          0.6,
                          0.9,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Service Limit",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 10),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromRGBO(46, 60, 100, 1),
                                          Color.fromRGBO(66, 80, 120, 1),
                                        ],
                                        tileMode: TileMode.mirror,
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [
                                          0.6,
                                          0.9,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color:
                                                Color.fromRGBO(76, 84, 122, 1),
                                          ),
                                          child: Icon(Icons.settings,
                                              color: Colors.blueGrey[300],
                                              size: 24),
                                        ),
                                        SizedBox(height: 10),
                                        Text("Device",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16)),
                                        SizedBox(height: 8),
                                        Text(
                                            "${serviceLimitCount != null ? serviceLimitCount["device_limit_left"] + "/" + serviceLimitCount["device_limit"] : "N/A"}",
                                            style: TextStyle(
                                                color: Colors.grey[300])),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 10),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromRGBO(46, 60, 100, 1),
                                          Color.fromRGBO(66, 80, 120, 1),
                                        ],
                                        tileMode: TileMode.mirror,
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [
                                          0.6,
                                          0.9,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color:
                                                Color.fromRGBO(76, 84, 122, 1),
                                          ),
                                          child: Icon(Icons.group,
                                              color: Colors.blueGrey[300],
                                              size: 24),
                                        ),
                                        SizedBox(height: 10),
                                        Text("Subuser",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16)),
                                        SizedBox(height: 8),
                                        Text(
                                            "${serviceLimitCount != null ? serviceLimitCount["user_limit_left"] + "/" + serviceLimitCount["user_limit"] : "N/A"}",
                                            style: TextStyle(
                                                color: Colors.grey[300])),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 10),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromRGBO(46, 60, 100, 1),
                                          Color.fromRGBO(66, 80, 120, 1),
                                        ],
                                        tileMode: TileMode.mirror,
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [
                                          0.6,
                                          0.9,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color:
                                                Color.fromRGBO(76, 84, 122, 1),
                                          ),
                                          child: Icon(Icons.sms,
                                              color: Colors.blueGrey[300],
                                              size: 24),
                                        ),
                                        SizedBox(height: 10),
                                        Text("SMS",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16)),
                                        SizedBox(height: 8),
                                        Text(
                                            "${serviceLimitCount != null ? serviceLimitCount["message_limit_left"] + "/" + serviceLimitCount["message_limit"] : "N/A"}",
                                            style: TextStyle(
                                                color: Colors.grey[300])),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 10),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromRGBO(46, 60, 100, 1),
                                          Color.fromRGBO(66, 80, 120, 1),
                                        ],
                                        tileMode: TileMode.mirror,
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [
                                          0.6,
                                          0.9,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color:
                                                Color.fromRGBO(76, 84, 122, 1),
                                          ),
                                          child: Icon(Icons.email,
                                              color: Colors.blueGrey[300],
                                              size: 24),
                                        ),
                                        SizedBox(height: 10),
                                        Text("Email",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16)),
                                        SizedBox(height: 8),
                                        Text(
                                            "${serviceLimitCount != null ? serviceLimitCount["email_limit_left"] + "/" + serviceLimitCount["email_limit"] : "N/A"}",
                                            style: TextStyle(
                                                color: Colors.grey[300])),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Halt Status",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(height: 300, child: LineChart(mainData()))
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Control Location",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          height: 300,
                          child: SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              primaryYAxis: NumericAxis(
                                  minimum: 0,
                                  maximum: locationMaxDist.toDouble(),
                                  interval: 1),
                              tooltipBehavior: _tooltip,
                              series: <ColumnSeries<_ChartData, String>>[
                                ColumnSeries<_ChartData, String>(
                                    dataSource: locationData,
                                    yValueMapper: (_ChartData data, _) =>
                                        data.y,
                                    xValueMapper: (_ChartData data, _) =>
                                        data.x,
                                    name: 'Control Location',
                                    color: ThemeColor.primarycolor)
                              ]),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Vehicle Performance",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            DropdownButton(
                              underline: SizedBox(),
                              isExpanded: false,
                              isDense: true,
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.black,
                              ),
                              // Array list of items
                              items: ["Yesterday", "Last Week", "This Month"]
                                  .map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                  onTap: () {
                                    vehiclePerformanceDurationFunc(items);
                                  },
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {},
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 150,
                                      child: FAProgressBar(
                                        direction: Axis.vertical,
                                        verticalDirection: VerticalDirection.up,
                                        currentValue: vehiclePerformance != null
                                            ? vehiclePerformance["Excellent"] *
                                                1.0
                                            : 0,
                                        displayText: '',
                                        border: Border.all(color: Colors.blue),
                                        maxValue: maxVPerformance.toDouble(),
                                        progressColor: Colors.blue,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text("Excellent")
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 150,
                                      child: FAProgressBar(
                                        direction: Axis.vertical,
                                        verticalDirection: VerticalDirection.up,
                                        currentValue: vehiclePerformance != null
                                            ? vehiclePerformance["Good"] * 1.0
                                            : 0,
                                        displayText: '',
                                        border: Border.all(color: Colors.blue),
                                        progressColor: Colors.blue,
                                        maxValue: maxVPerformance.toDouble(),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text("Good")
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 150,
                                      child: FAProgressBar(
                                        direction: Axis.vertical,
                                        verticalDirection: VerticalDirection.up,
                                        currentValue: vehiclePerformance != null
                                            ? vehiclePerformance["Average"] *
                                                1.0
                                            : 0,
                                        displayText: '',
                                        border: Border.all(color: Colors.blue),
                                        progressColor: Colors.blue,
                                        maxValue: maxVPerformance.toDouble(),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text("Average")
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 150,
                                      child: FAProgressBar(
                                        direction: Axis.vertical,
                                        verticalDirection: VerticalDirection.up,
                                        currentValue: vehiclePerformance != null
                                            ? vehiclePerformance["Poor"] * 1.0
                                            : 0,
                                        displayText: '',
                                        border: Border.all(color: Colors.blue),
                                        progressColor: Colors.blue,
                                        maxValue: maxVPerformance.toDouble(),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text("Poor")
                                  ],
                                ),
                              ]),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Distance Analysis",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                            height: 300,
                            child: LineChart(mainDataForDistance())),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  showDistanceDetail("below_100");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: ThemeColor.primarycolor)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.chevron_left,
                                        color: ThemeColor.primarycolor,
                                        size: 16,
                                      ),
                                      Text("100",
                                          style: TextStyle(
                                              color: ThemeColor.primarycolor,
                                              fontSize: 12))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  showDistanceDetail("below_200");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: ThemeColor.primarycolor)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.chevron_left,
                                        color: ThemeColor.primarycolor,
                                        size: 16,
                                      ),
                                      Text("200",
                                          style: TextStyle(
                                              color: ThemeColor.primarycolor,
                                              fontSize: 12))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  showDistanceDetail("below_300");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: ThemeColor.primarycolor)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.chevron_left,
                                        color: ThemeColor.primarycolor,
                                        size: 16,
                                      ),
                                      Text("300",
                                          style: TextStyle(
                                              color: ThemeColor.primarycolor,
                                              fontSize: 12))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  showDistanceDetail("below_400");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: ThemeColor.primarycolor)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.chevron_left,
                                        color: ThemeColor.primarycolor,
                                        size: 16,
                                      ),
                                      Text("400",
                                          style: TextStyle(
                                              color: ThemeColor.primarycolor,
                                              fontSize: 12))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  showDistanceDetail("below_500");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: ThemeColor.primarycolor)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.chevron_left,
                                        color: ThemeColor.primarycolor,
                                        size: 16,
                                      ),
                                      Text("500",
                                          style: TextStyle(
                                              color: ThemeColor.primarycolor,
                                              fontSize: 12))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  showDistanceDetail("above_500");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: ThemeColor.primarycolor)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("500",
                                          style: TextStyle(
                                              color: ThemeColor.primarycolor,
                                              fontSize: 12)),
                                      Icon(
                                        Icons.chevron_right,
                                        color: ThemeColor.primarycolor,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('0-3', style: style);
        break;
      case 1:
        text = const Text('3-6', style: style);
        break;
      case 2:
        text = const Text('6-12', style: style);
        break;
      case 3:
        text = const Text('12-24', style: style);
        break;
      case 4:
        text = const Text('>24', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, haltStatus != null ? haltStatus["0-3"] * 1.0 : 0),
            FlSpot(1.0, haltStatus != null ? haltStatus["3-6"] * 1.0 : 0),
            FlSpot(2.0, haltStatus != null ? haltStatus["6-12"] * 1.0 : 0),
            FlSpot(3.0, haltStatus != null ? haltStatus["12-24"] * 1.0 : 0),
            FlSpot(4.0, haltStatus != null ? haltStatus[">24"] * 1.0 : 0),
          ],
          color: Colors.blue,
          isCurved: false,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgetsForDistance(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('0-100', style: style);
        break;
      case 1:
        text = const Text('100-200', style: style);
        break;
      case 2:
        text = const Text('200-300', style: style);
        break;
      case 3:
        text = const Text('300-400', style: style);
        break;
      case 4:
        text = const Text('400-500', style: style);
        break;
      case 5:
        text = const Text('>500', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  LineChartData mainDataForDistance() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgetsForDistance,
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(
                0,
                distanceDetail != null
                    ? distanceDetail["below_100_count"] * 1.0
                    : 0),
            FlSpot(
                1.0,
                distanceDetail != null
                    ? distanceDetail["below_200_count"] * 1.0
                    : 0),
            FlSpot(
                2.0,
                distanceDetail != null
                    ? distanceDetail["below_300_count"] * 1.0
                    : 0),
            FlSpot(
                3.0,
                distanceDetail != null
                    ? distanceDetail["below_400_count"] * 1.0
                    : 0),
            FlSpot(
                4.0,
                distanceDetail != null
                    ? distanceDetail["below_500_count"] * 1.0
                    : 0),
            FlSpot(
                5.0,
                distanceDetail != null
                    ? distanceDetail["above_500_count"] * 1.0
                    : 0),
          ],
          color: Colors.blue,
          isCurved: false,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
          ),
        ),
      ],
    );
  }

  showDistanceDetail(dist) {
    String title = "";
    if (dist == "below_100") {
      title = "100 kms Detail";
    } else if (dist == "below_200") {
      title = "200 kms Detail";
    } else if (dist == "below_300") {
      title = "300 kms Detail";
    } else if (dist == "below_400") {
      title = "400 kms Detail";
    } else if (dist == "below_500") {
      title = "500 kms Detail";
    } else if (dist == "above_500") {
      title = "Above 500 kms Detail";
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: Border(bottom: BorderSide.none, top: BorderSide.none),
            backgroundColor: Colors.white,
            child: Container(
              padding: EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 16),
                    for (var distDetail in distanceDetail[dist])
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Vehicle ID : ${distDetail["vehicleid"]}",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Average : ${distDetail["average"].toString()}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Totaldistance : ${distDetail["totaldistance"]}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          SizedBox(height: 24),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  showAlertDetail() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: Border(bottom: BorderSide.none, top: BorderSide.none),
            backgroundColor: Colors.white,
            child: Container(
              padding: EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Alert Details",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 16),
                    for (var distDetail in alertDetailData)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Vehicle Name : ${distDetail["veh_reg"]}",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Sent on : ${distDetail["sent_on"]}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          SizedBox(height: 24),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        });
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

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
