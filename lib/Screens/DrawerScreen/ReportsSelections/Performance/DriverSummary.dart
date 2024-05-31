import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/constants.dart';

class DriverSummary extends StatefulWidget {
  const DriverSummary({Key? key}) : super(key: key);

  @override
  State<DriverSummary> createState() => _DriverSummaryState();
}

class _DriverSummaryState extends State<DriverSummary> {
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> drivers = [];
  String startDate = "";
  String endDate = "";
  bool isApply = false;
  var selectedDriver;

  @override
  void initState() {
    super.initState();

    startDate = endDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    getDrivers();
  }

  void fetchData() async {
    if (selectedDriver == null) {
      SmartDialog.showToast("Please select Driver");
      return;
    }
    data =
        await ApiService.driverReport(selectedDriver["id"], startDate, endDate);

    setState(() {
      this.isApply = true;
    });
  }

  getDrivers() async {
    SmartDialog.showLoading(msg: "Loading...");
    drivers = await ApiService.getDrivers();
    setState(() {});
    SmartDialog.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe2e2e2),
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
                "Driver Summary",
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
                      TimeOfDay? startPickedTime = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      TimeOfDay? endPickedTime = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      print(pickedDate.start);
                      print(pickedDate.end);
                      print(startPickedTime.toString().padLeft(2, '0'));
                      setState(() {
                        startDate = DateFormat('yyyy-MM-dd')
                                .format(pickedDate.start) +
                            " " +
                            (startPickedTime == null
                                ? "00:00"
                                : '${startPickedTime.hour.toString().padLeft(2, '0')}:${startPickedTime.minute.toString().padLeft(2, '0')}');
                        endDate = DateFormat('yyyy-MM-dd')
                                .format(pickedDate.end) +
                            " " +
                            (endPickedTime == null
                                ? "00:00"
                                : '${endPickedTime.hour.toString().padLeft(2, '0')}:${endPickedTime.minute.toString().padLeft(2, '0')}');
                      });
                    } else {
                      print("Date is not selected");
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          startDate,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 15),
                      Text(
                        "to",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      SizedBox(width: 15),
                      SizedBox(
                        width: 100,
                        child: Text(
                          endDate,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
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
          Container(
            height: Get.size.height * 0.07,
            width: Get.size.width * 0.99,
            color: Color(0xffeeeeee),
            child: Center(
              child: PopupMenuButton(
                position: PopupMenuPosition.under,
                onSelected: (item) {
                  selectedDriver = item;
                },
                itemBuilder: (BuildContext context) => drivers
                    .map((e) => PopupMenuItem(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.size.width * 0.1),
                          value: e,
                          child: Text(e["name"]),
                        ))
                    .toList(),
                child: Container(
                  alignment: Alignment.center,
                  child:
                      new Stack(alignment: Alignment.center, children: <Widget>[
                    Image(
                      image: AssetImage('assets/images/search.png'),
                      width: 300,
                    ),
                    Text(selectedDriver == null
                        ? "Select Driver"
                        : selectedDriver["name"]),
                  ]),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 03.0),
            child: Container(
              height: Get.size.height * 0.71,
              width: Get.size.width * 0.92,
              color: Colors.white,
              child: !isApply
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/bluecar-removebg-preview.png",
                          height: 30,
                        ),
                        Text(
                          "Please apply to see Driver Summary",
                          style: TextStyle(
                              color: Color(
                                0xff757575,
                              ),
                              fontSize: 15),
                        )
                      ],
                    )
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    data[index]["vehiclename"],
                                    style: TextStyle(
                                      color: Colors.grey[300],
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Run Time",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.green),
                                        ),
                                        Text(
                                          "${data[index]["totalrunningtime"]}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[300]),
                                        ),
                                        Text(
                                          "Distance",
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.blue),
                                        ),
                                        Text(
                                          "${data[index]["total_distance"]}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[300]),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Idle Time",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.orange),
                                        ),
                                        Text(
                                          "${data[index]["totalidletime"]}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[300]),
                                        ),
                                        Text(
                                          "Avg Speed",
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.blue),
                                        ),
                                        Text(
                                          "${data[index]["avg_speed"]}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[300]),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Stop Time",
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.red),
                                        ),
                                        Text(
                                          "${data[index]["totalhalttime"]}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[300]),
                                        ),
                                        Text(
                                          "Max Speed",
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.blue),
                                        ),
                                        Text(
                                          "${data[index]["max_speed"]}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[300]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
