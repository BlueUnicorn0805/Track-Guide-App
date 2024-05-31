import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/constants.dart';

class StoppageSummary extends StatefulWidget {
  const StoppageSummary({Key? key}) : super(key: key);

  @override
  State<StoppageSummary> createState() => _StoppageSummaryState();
}

class _StoppageSummaryState extends State<StoppageSummary> {
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> vehicles = [];
  List<String> selectedVehicle = [];
  List<String> selectedVehicleIds = [];
  List<String> selectedGroups = [];
  String startDate = "";
  String endDate = "";
  bool isApply = false;
  Map<String, dynamic> addresses = Map();
  @override
  void initState() {
    super.initState();

    startDate = DateFormat('yyyy-MM-dd 00:00').format(DateTime.now());
    endDate = DateFormat('yyyy-MM-dd 23:59').format(DateTime.now());
    fetchVehicle();
  }

  void fetchVehicle() async {
    SmartDialog.showLoading(msg: 'Loading...');
    vehicles = await ApiService.vehiclesByGroup();
    SmartDialog.dismiss();
  }

  void fetchData() async {
    if (selectedVehicleIds.isEmpty) {
      SmartDialog.showToast("Please select Vehicles");
      return;
    }
    SmartDialog.showLoading(msg: 'Loading...');
    data = await ApiService.stoppageSummaryReport(
        selectedVehicleIds.join(","), startDate, endDate);
    SmartDialog.dismiss();

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
                "Stoppage Summary",
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
                      onSelectVehicleDialog();
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
                          Expanded(
                            child: Text(
                                selectedVehicle.isEmpty
                                    ? "Select Vehicle"
                                    : selectedVehicle.join(","),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Color(0xffadadad))),
                          )
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 90,
                          child: Column(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                                size: 20,
                              ),
                              Text(
                                startDate,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white),
                              ),
                            ],
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
                          width: 90,
                          child: Column(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                                size: 20,
                              ),
                              Text(
                                endDate,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                        "Please apply to see Stoppage Summary",
                        style: TextStyle(
                            color: Color(
                              0xff757575,
                            ),
                            fontSize: 15),
                      )
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: data.map((e) => stoppageItem(e)).toList(),
                    ),
                  ),
          )
        ],
      ),
    );
  }

  Widget stoppageItem(e) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(1, 1),
              blurRadius: 2,
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            e["vehiclename"],
            style: TextStyle(
                fontSize: 15,
                color: Colors.blue[300],
                fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: () async {
              if (e["halt_latitude"] == "N/A" || e["halt_longitude"] == "N/A") {
                SmartDialog.showToast("Latitude or Longitutde is invalid.");
                return;
              }
              var resAddress = await ApiService.getAddress(
                  double.parse(e["halt_latitude"].toString()),
                  double.parse(e["halt_longitude"].toString()));
              print(resAddress);
              setState(() {
                addresses[e["sys_service_id"].toString()] = resAddress;
              });
            },
            child: Text(
              addresses[e["sys_service_id"]] != null
                  ? addresses[e["sys_service_id"].toString()]
                  : "Get Address",
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.top,
            border: TableBorder.all(width: 1, color: Colors.black),
            children: [
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Total Halt Time",
                          style:
                              TextStyle(fontSize: 12, color: Colors.black54)),
                      Text("${e["totalhalttime"] ?? "N/A"}",
                          style:
                              TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Max Halt",
                          style:
                              TextStyle(fontSize: 12, color: Colors.black54)),
                      Text("${e["maxhalt"] ?? "N/A"}",
                          style:
                              TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Halt Duration",
                          style:
                              TextStyle(fontSize: 12, color: Colors.black54)),
                      Text("${e["halt_start_time"] ?? "N/A"} - ",
                          style:
                              TextStyle(fontSize: 11, color: Colors.black54)),
                      Text("${e["halt_end_time"] ?? "N/A"}",
                          style:
                              TextStyle(fontSize: 11, color: Colors.black54)),
                    ],
                  ),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Total Distance",
                          style:
                              TextStyle(fontSize: 12, color: Colors.black54)),
                      Text("${e["total_distance"] ?? "N/A"}",
                          style:
                              TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Total Running Time",
                          style:
                              TextStyle(fontSize: 12, color: Colors.black54)),
                      Text("${e["totalrunningtime"] ?? "N/A"}",
                          style:
                              TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Total Idle Time",
                          style:
                              TextStyle(fontSize: 12, color: Colors.black54)),
                      Text("${e["totalidletime"] ?? "N/A"}",
                          style:
                              TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  onSelectVehicleDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: Border(bottom: BorderSide.none, top: BorderSide.none),
            backgroundColor: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  color: Color.fromARGB(255, 96, 125, 139),
                  alignment: Alignment.center,
                  width: Get.width,
                  child: Text("Select Vehicle",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontStyle: FontStyle.italic)),
                ),
                Expanded(
                  child: Container(
                    child: StatefulBuilder(builder:
                        (BuildContext context, StateSetter alertState) {
                      return SingleChildScrollView(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: vehicles.length,
                            itemBuilder: (BuildContext context, int index) {
                              var groupInfo = vehicles[index];
                              var groupVehicles =
                                  List<Map<String, dynamic>>.from(
                                      (groupInfo["result"]).map((item) => {
                                            'serviceId': item['service_id'],
                                            'vehReg': item['veh_reg'],
                                            'created': item['sys_created'],
                                            'renewalDue':
                                                item['sys_renewal_due'],
                                            'imei': item['imei'],
                                            'mobileNo': item['mobile_no'],
                                            'mobileNo1': item['mobile_no1'],
                                            'location': item['location'],
                                            'is_selected': false,
                                          }));
                              print(groupInfo);
                              return Column(
                                children: [
                                  CheckboxListTile(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      value: selectedGroups
                                          .contains(groupInfo["location"]),
                                      tileColor:
                                          Color.fromARGB(255, 150, 219, 250),
                                      title: Text(
                                        groupInfo["location"],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onChanged: (bool? value) {
                                        if (value == true) {
                                          selectedGroups
                                              .add(groupInfo["location"]);

                                          for (var vInfo in groupVehicles) {
                                            selectedVehicle
                                                .add(vInfo["vehReg"]);
                                            selectedVehicleIds
                                                .add("${vInfo["serviceId"]}");
                                          }
                                        } else {
                                          selectedGroups.removeWhere(
                                              (element) =>
                                                  element ==
                                                  groupInfo["location"]);
                                          for (var vInfo in groupVehicles) {
                                            selectedVehicle.removeWhere(
                                                (element) =>
                                                    element == vInfo["vehReg"]);
                                            selectedVehicleIds.removeWhere(
                                                (element) =>
                                                    element ==
                                                    "${vInfo["serviceId"]}");
                                          }
                                        }
                                        alertState(() {});
                                      }),
                                  ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: groupVehicles.length,
                                      itemBuilder:
                                          (BuildContext context, int vIndex) {
                                        var vehicleInfo = groupVehicles[vIndex];
                                        print(vehicleInfo);
                                        return Column(
                                          children: [
                                            CheckboxListTile(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                value: selectedVehicle.contains(
                                                    vehicleInfo["vehReg"]),
                                                title: Text(
                                                  vehicleInfo["vehReg"],
                                                ),
                                                onChanged: (bool? value) {
                                                  if (value == true) {
                                                    selectedVehicle.add(
                                                        vehicleInfo["vehReg"]);
                                                    selectedVehicleIds.add(
                                                        "${vehicleInfo["serviceId"]}");

                                                    bool isCheckedAll = true;
                                                    for (var gInfo
                                                        in groupVehicles) {
                                                      if (!selectedVehicle
                                                          .contains(gInfo[
                                                              "vehReg"])) {
                                                        isCheckedAll = false;
                                                      }
                                                    }
                                                    if (isCheckedAll) {
                                                      selectedGroups.add(
                                                          vehicleInfo[
                                                              "location"]);
                                                    }
                                                  } else {
                                                    selectedVehicle.removeWhere(
                                                        (element) =>
                                                            element ==
                                                            vehicleInfo[
                                                                "vehReg"]);
                                                    selectedVehicleIds
                                                        .removeWhere((element) =>
                                                            element ==
                                                            "${vehicleInfo["serviceId"]}");

                                                    bool isCheckedAll = true;
                                                    for (var gInfo
                                                        in groupVehicles) {
                                                      if (!selectedVehicle
                                                          .contains(gInfo[
                                                              "vehReg"])) {
                                                        isCheckedAll = false;
                                                      }
                                                    }
                                                    if (!isCheckedAll) {
                                                      selectedGroups.removeWhere(
                                                          (element) =>
                                                              element ==
                                                              vehicleInfo[
                                                                  "location"]);
                                                    }
                                                  }
                                                  alertState(() {});
                                                }),
                                          ],
                                        );
                                      })
                                ],
                              );
                            }),
                      );
                    }),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                  ),
                ),
              ],
            ),
          );
        });
  }
}
