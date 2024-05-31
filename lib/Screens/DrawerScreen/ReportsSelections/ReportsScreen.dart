import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Screens/DrawerScreen/ReportsSelections/Movement/IdleSummary.dart';
import 'package:trackofyapp/Screens/DrawerScreen/ReportsSelections/Movement/MaximumSpeedChart.dart';
import 'package:trackofyapp/Screens/DrawerScreen/ReportsSelections/Movement/RunningSummary.dart';
import 'package:trackofyapp/Screens/DrawerScreen/ReportsSelections/Movement/StoppageSummary.dart';
import 'package:trackofyapp/Screens/DrawerScreen/ReportsSelections/Performance/DistanceChart.dart';
import 'package:trackofyapp/Screens/DrawerScreen/ReportsSelections/Performance/DriverPerformance.dart';
import 'package:trackofyapp/Screens/DrawerScreen/ReportsSelections/Performance/DriverSummary.dart';
import 'package:trackofyapp/Screens/DrawerScreen/ReportsSelections/Performance/FleetSummary.dart';
import 'package:trackofyapp/Screens/DrawerScreen/ReportsSelections/Performance/TripReport.dart';
import 'package:trackofyapp/Screens/DrawerScreen/ReportsSelections/Performance/VehicleSummary.dart';
import 'package:trackofyapp/Screens/DrawerScreen/ReportsSelections/Sensor/Alert%20Report.dart';
import 'package:trackofyapp/Screens/DrawerScreen/ReportsSelections/Sensor/Humidity.dart';
import 'package:trackofyapp/Screens/DrawerScreen/ReportsSelections/Sensor/Temperature.dart';
import 'package:trackofyapp/Screens/HomeScreen/HomeScreen.dart';
import 'package:trackofyapp/Widgets/drawer.dart';
import 'package:trackofyapp/constants.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var colors = [
    Colors.white,
    Color(0xffcacaca),
    Colors.white,
    Color(0xffcacaca),
    Colors.white,
    Color(0xffcacaca),
  ];
  var colors2 = [
    Color(0xffcacaca),
    Colors.white,
    Color(0xffcacaca),
    Colors.white,
  ];
  var colors3 = [
    Colors.white,
    Color(0xffcacaca),
    // Colors.white,
  ];
  var images = [
    "assets/images/Untitled_design__1_-removebg-preview.png",
    "assets/images/Untitled_design__12_-removebg-preview.png",
    "assets/images/Untitled_design__2_-removebg-preview.png",
    "assets/images/Untitled_design__2_-removebg-preview.png",
    "assets/images/Untitled_design__4_-removebg-preview.png",
    "assets/images/Untitled_design__2_-removebg-preview.png",
  ];
  var images2 = [
    "assets/images/Untitled_design__7_-removebg-preview.png",
    "assets/images/Untitled_design__6_-removebg-preview.png",
    "assets/images/Untitled_design__9_-removebg-preview.png",
    "assets/images/Untitled_design__8_-removebg-preview.png",
  ];
  var images3 = [
    "assets/images/Untitled_design__10_-removebg-preview.png",
    "assets/images/Untitled_design__10_-removebg-preview.png",
    // "assets/images/Untitled_design__11_-removebg-preview.png",
  ];
  var title = [
    "Fleet Summary",
    "Distance Chart",
    "Vehicle Summary",
    "Driver Summary",
    "Driver Performance",
    "Trip Report",
  ];
  var title2 = [
    "MaxSpeed Chart",
    "Stoppage Summary",
    "Running Summary",
    "Idle Summary",
  ];
  var title3 = [
    "Humidity",
    "Temperature",
    // "Alert Report",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: DrawerClass(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reports Selections",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: ThemeColor.primarycolor,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Get.offAll(() => HomeScreen());
                      },
                      child: Icon(
                        Icons.home,
                        color: ThemeColor.primarycolor,
                        size: 27,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
          child: Column(
            children: [
              Column(
                children: [
                  Material(
                    elevation: 2,
                    child: Container(
                      height: Get.size.height * 0.48,
                      width: Get.size.width * 0.95,
                      child: Column(
                        children: [
                          Container(
                            height: Get.size.height * 0.06,
                            width: Get.size.width * 0.95,
                            color: Color(0xff0973a3),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "Performance",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: colors.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  if (index == 0) {
                                    Get.to(() => FleetSummary());
                                  } else if (index == 1) {
                                    Get.to(() => DistanceChart());
                                  } else if (index == 2) {
                                    Get.to(() => VehicleSummary());
                                  } else if (index == 3) {
                                    Get.to(() => DriverSummary());
                                  } else if (index == 4) {
                                    Get.to(() => DriverPerformance());
                                  } else if (index == 5) {
                                    Get.to(() => TripReport());
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: Get.size.height * 0.07,
                                      width: Get.size.width * 0.95,
                                      color: colors[index],
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Row(
                                          children: [
                                            Container(
                                                child: Image.asset(
                                              images[index],
                                              height: 20,
                                            )),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    title[index],
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: ThemeColor
                                                            .primarycolor),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: Get.size.height * 0.05),
                  Material(
                    elevation: 2,
                    child: Container(
                      height: Get.size.height * 0.35,
                      width: Get.size.width * 0.95,
                      child: Column(
                        children: [
                          Container(
                            height: Get.size.height * 0.06,
                            width: Get.size.width * 0.95,
                            color: Color(0xff0973a3),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "Movement",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: colors2.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  if (index == 0) {
                                    Get.to(() => MaximumSpeedChart());
                                  } else if (index == 1) {
                                    Get.to(() => StoppageSummary());
                                  } else if (index == 2) {
                                    Get.to(() => RunningSummary());
                                  } else if (index == 3) {
                                    Get.to(() => IdleSummary());
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: Get.size.height * 0.07,
                                      width: Get.size.width * 0.95,
                                      color: colors2[index],
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Row(
                                          children: [
                                            Container(
                                                child: Image.asset(
                                              images2[index],
                                              height: 20,
                                            )),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    title2[index],
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: ThemeColor
                                                            .primarycolor),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: Get.size.height * 0.05),
                  Material(
                    elevation: 2,
                    child: Container(
                      height: Get.size.height * 0.2,
                      width: Get.size.width * 0.95,
                      child: Column(
                        children: [
                          Container(
                            height: Get.size.height * 0.06,
                            width: Get.size.width * 0.95,
                            color: Color(0xff0973a3),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "Sensor",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: colors3.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  if (index == 0) {
                                    Get.to(() => HumidityReport());
                                  } else if (index == 1) {
                                    Get.to(() => TemperatureReport());
                                  } else if (index == 2) {
                                    Get.to(() => AlertReport());
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: Get.size.height * 0.07,
                                      width: Get.size.width * 0.95,
                                      color: colors3[index],
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Row(
                                          children: [
                                            Container(
                                                child: Image.asset(
                                              images3[index],
                                              height: 20,
                                            )),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    title3[index],
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: ThemeColor
                                                            .primarycolor),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
