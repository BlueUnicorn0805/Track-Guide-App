import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/widgets.dart';
import 'package:trackofyapp/constants.dart';
import 'package:http/http.dart' as http;

class DistanceGraph extends StatefulWidget {
  const DistanceGraph({Key? key}) : super(key: key);

  @override
  State<DistanceGraph> createState() => _DistanceGraphState();
}

class _DistanceGraphState extends State<DistanceGraph> {
  List<Map<String, dynamic>> vehiclesData = [];
  String startDate = "";
  String endDate = "";
  var distanceDetail;
  List<_ChartData> data = [];
  TooltipBehavior _tooltip = TooltipBehavior();
  double maxDist = 20;
  double interv = 4;

  @override
  void initState() {
    super.initState();

    // Call the API when the widget is first created
    startDate = endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    fetchData();
  }

  void fetchData() async {
    SmartDialog.showLoading(msg: "Loading...");
    vehiclesData = await ApiService.getDistanceRange(startDate, endDate);
    vehiclesData
        .sort((a, b) => a["TotalDistance"] < b["TotalDistance"] ? 1 : 0);
    maxDist = double.parse(vehiclesData[0]["TotalDistance"].toString());
    interv = 4;

    for (var vInfo in vehiclesData) {
      data.add(_ChartData(vInfo["Vehiclename"],
          double.parse(vInfo["TotalDistance"].toString())));
    }
    _tooltip = TooltipBehavior(enable: true);
    SmartDialog.dismiss();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                "Distance Graph",
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
      body: Column(
        children: [
          Container(
            color: Color(0xffc0c0c0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () async {
                    DateTimeRange? pickedDate = await showDateRangePicker(
                      context: context,
                      initialDateRange: DateTimeRange(
                        start: DateTime.now(),
                        end: DateTime.now(),
                      ),
                      firstDate: DateTime(
                          2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101),
                      builder: (context, child) {
                        return Column(
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 400.0,
                              ),
                              child: child,
                            ),
                          ],
                        );
                      },
                    );

                    if (pickedDate != null) {
                      print(pickedDate.start);
                      print(pickedDate.end);

                      setState(() {
                        // dateinput.text =
                        //     formattedDate; //set output date to TextField value.
                        startDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate.start);
                        endDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate.end);
                      });
                    } else {
                      print("Date is not selected");
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Icon(
                              Icons.calendar_month_sharp,
                              size: 22,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            startDate,
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(width: 24),
                      Text(
                        "to",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      SizedBox(width: 24),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Icon(
                              Icons.calendar_month_sharp,
                              size: 22,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            endDate,
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  color: Color(0xffd6d7d7),
                  onPressed: () {
                    fetchData();
                  },
                  child: Text(
                    "APPLY",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis:
                      NumericAxis(minimum: 0, maximum: maxDist, interval: interv),
                  tooltipBehavior: _tooltip,
                  series: <CartesianSeries<_ChartData, String>>[
                    BarSeries<_ChartData, String>(
                        dataSource: data,
                        xValueMapper: (_ChartData data, _) => data.x,
                        yValueMapper: (_ChartData data, _) => data.y,
                        name: 'Distance Summary',
                        color: Colors.green)
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
