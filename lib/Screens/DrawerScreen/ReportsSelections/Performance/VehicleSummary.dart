import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/widgets.dart';
import 'package:trackofyapp/constants.dart';

class VehicleSummary extends StatefulWidget {
  const VehicleSummary({Key? key}) : super(key: key);

  @override
  State<VehicleSummary> createState() => _VehicleSummaryState();
}

class _VehicleSummaryState extends State<VehicleSummary> {
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> vehicles = [];
  List<String> selectedVehicle = [];
  List<String> selectedVehicleIds = [];
  List<String> selectedGroups = [];
  String startDate = "";
  String endDate = "";
  bool isApply = false;

  @override
  void initState() {
    super.initState();

    startDate = DateFormat('yyyy-MM-dd 00:00').format(DateTime.now());
    endDate = DateFormat('yyyy-MM-dd 23:59').format(DateTime.now());
    fetchData();
  }

  void fetchData() async {
    SmartDialog.showLoading(msg: 'Loading...');
    vehicles = await ApiService.vehiclesByGroup();
    SmartDialog.dismiss();
  }

  void fetchVehicleSummary() async {
    if (selectedVehicleIds.isEmpty) {
      SmartDialog.showToast("Please select Vehicles.");
      return;
    }
    SmartDialog.showLoading(msg: "Loading...");
    data = await ApiService.vehicleSummaryReport(
        selectedVehicleIds.join(","), startDate, endDate);
    SmartDialog.dismiss();
    print(data);
    setState(() {
      this.isApply = true;
    });
  }

  // void search(String query) {
  //   setState(
  //     () {
  //       data = data
  //           .where(
  //             (item) => item['veh_name'].toLowerCase().contains(
  //                   query.toLowerCase(),
  //                 ),
  //           )
  //           .toList();
  //     },
  //   );
  // }

  // void fetchData() async {
  //   data = await ApiService.vehicleSummaryReport(startDate, endDate);

  //   setState(() {
  //     this.isApply = true;
  //   });
  // }

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
                "Vehicle Summary",
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
                height: Get.size.height * 0.06,
                width: Get.size.width * 1.00,
                color: Color(0xffe2e2e2),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: InkWell(
                    onTap: () {
                      onSelectVehicleDialog();
                    },
                    child: Center(
                        child: Container(
                      // height: h,
                      width: Get.size.width * 0.9,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
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
                    )),
                  ))
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
                    fetchVehicleSummary();
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
              width: double.infinity,
              color: Colors.white,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: !isApply
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/bluecar-removebg-preview.png",
                          height: 30,
                        ),
                        Text(
                          "Please apply to see vehicle Summary",
                          style: TextStyle(
                              color: Color(
                                0xff757575,
                              ),
                              fontSize: 15),
                        )
                      ],
                    )
                  : SingleChildScrollView(
                      child: Container(
                          color: Colors.white,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            data[index]["vehiclename"],
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                      fontSize: 13,
                                                      color: Colors.green),
                                                ),
                                                Text(
                                                  "${data[index]["totalrunningtime"]}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  "Distance",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.blue),
                                                ),
                                                Text(
                                                  "${data[index]["total_distance"]}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
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
                                                      fontSize: 13,
                                                      color: Colors.orange),
                                                ),
                                                Text(
                                                  "${data[index]["totalidletime"]}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  "Avg Speed",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.blue),
                                                ),
                                                Text(
                                                  "${data[index]["avg_speed"]}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
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
                                                      fontSize: 13,
                                                      color: Colors.red),
                                                ),
                                                Text(
                                                  "${data[index]["totalhalttime"]}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  "Max Speed",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.blue),
                                                ),
                                                Text(
                                                  "${data[index]["max_speed"]}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              })),
                    ),
            ),
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
