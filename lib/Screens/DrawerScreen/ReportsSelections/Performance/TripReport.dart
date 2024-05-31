import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/constants.dart';

class TripReport extends StatefulWidget {
  const TripReport({Key? key}) : super(key: key);

  @override
  State<TripReport> createState() => _TripReportState();
}

class _TripReportState extends State<TripReport> {
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> vehicles = [];
  List<String> selectedVehicle = [];
  List<String> selectedVehicleIds = [];
  String startDate = "";
  String endDate = "";
  bool isApply = false;
  @override
  void initState() {
    super.initState();

    startDate = endDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    fetchVehicle();
  }

  void fetchVehicle() async {
    vehicles = await ApiService.vehicles();
  }

  void fetchData() async {
    if (selectedVehicleIds.isEmpty) {
      SmartDialog.showToast("Please select Vehicles.");
      return;
    }
    data = await ApiService.tripReport(
        selectedVehicleIds.join(","), startDate, endDate);

    setState(() {
      this.isApply = true;
    });
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
                "Trip Report",
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
          Stack(
            children: [
              Container(
                color: Color(0xffe2e2e2),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Select Vehicle"),
                              content: Container(
                                width: 300,
                                height: 400,
                                child: StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter alertState) {
                                  return ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: vehicles.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return CheckboxListTile(
                                            value: selectedVehicle.contains(
                                                vehicles[index]["vehReg"]),
                                            title:
                                                Text(vehicles[index]["vehReg"]),
                                            onChanged: (bool? value) {
                                              if (value == true) {
                                                selectedVehicle.clear();
                                                selectedVehicle.add(
                                                    vehicles[index]["vehReg"]);
                                                selectedVehicleIds.clear();
                                                selectedVehicleIds.add(
                                                    "${vehicles[index]["serviceId"]}");
                                              } else {
                                                selectedVehicle.removeWhere(
                                                    (element) =>
                                                        element ==
                                                        vehicles[index]
                                                            ["vehReg"]);
                                                selectedVehicleIds.removeWhere(
                                                    (element) =>
                                                        element ==
                                                        "${vehicles[index]["serviceId"]}");
                                              }
                                              alertState(() {
                                                vehicles[index]["is_selected"] =
                                                    value;
                                              });
                                            });
                                      });
                                }),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancel")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: Text("Confirm")),
                              ],
                            );
                          });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              selectedVehicle.isEmpty
                                  ? "Select Vehicle"
                                  : selectedVehicle.join(","),
                              style: TextStyle(color: Color(0xffadadad))),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Expanded(
            child: !isApply
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/bluecar-removebg-preview.png",
                        height: 30,
                      ),
                      Text(
                        "Please apply to see Trip Report",
                        style: TextStyle(
                            color: Color(
                              0xff757575,
                            ),
                            fontSize: 15),
                      )
                    ],
                  )
                : SingleChildScrollView(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: Get.width,
                                padding: EdgeInsets.all(10),
                                color: Colors.blue[900],
                                child: Center(
                                  child: Text(
                                    data[index]["tripName"],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_pin,
                                                color: Colors.green,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: Text(
                                                    data[index]
                                                        ["start_address"],
                                                    style: TextStyle(
                                                        color: Colors.green)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_pin,
                                                color: Colors.red,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: Text(
                                                    data[index]["end_address"],
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                        "${data[index]["start_time"]} to ${data[index]["tripEndTime"]}"),
                                    Text("${data[index]["avg_speed"]} Km/Hr"),
                                    Text("${data[index]["distance"]} KM"),
                                    Text("${data[index]["idle"]}"),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
          )
        ],
      ),
    );
  }
}
