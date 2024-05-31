import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/constants.dart';

class DriverPerformance extends StatefulWidget {
  const DriverPerformance({Key? key}) : super(key: key);

  @override
  State<DriverPerformance> createState() => _DriverPerformanceState();
}

class _DriverPerformanceState extends State<DriverPerformance> {
  List<Map<String, dynamic>> data = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    SmartDialog.showLoading(msg: "Loading...");
    data = await ApiService.driverPerformance();
    SmartDialog.dismiss();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(55.0),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back_outlined,
                  color: Color(0xff1574a4),
                )),
            centerTitle: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Driver Perfomance",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    color: ThemeColor.primarycolor,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: data
                .map(
                  (e) => Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 1,
                            blurRadius: 3)
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(e["name"],
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        Text("(${e["id"]})",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        Text("Fuel Consumption (Litre) = 0",
                            style: TextStyle(fontSize: 15)),
                        Text("Mileage (KM/L) = 0",
                            style: TextStyle(fontSize: 15)),
                        SizedBox(height: 8),
                        Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.top,
                          textDirection: TextDirection.ltr,
                          border:
                              TableBorder.all(width: 1, color: Colors.black),
                          children: [
                            TableRow(children: [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Harsh Breaking",
                                    ),
                                    Text(
                                      "${e["harsh_breaking"]}",
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Harsh Acceleration",
                                    ),
                                    Text(
                                      "${e["harsh_acceleration"]}",
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Maximum Speed",
                                    ),
                                    Text(
                                      "${e["max_speed"]}",
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Total Distance",
                                    ),
                                    Text(
                                      "${e["total_distance"]}",
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Average Speed",
                                    ),
                                    Text(
                                      "${e["avg_speed"]}",
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Rating",
                                    ),
                                    Text(
                                      "${e["category"]}",
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ));
  }
}
