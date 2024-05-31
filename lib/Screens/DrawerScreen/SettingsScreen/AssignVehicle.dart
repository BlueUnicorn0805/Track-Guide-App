import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/constants.dart';

class AssignVehicle extends StatefulWidget {
  int locationId;
  AssignVehicle({Key? key, required this.locationId}) : super(key: key);

  @override
  State<AssignVehicle> createState() => _AssignVehicleState();
}

class _AssignVehicleState extends State<AssignVehicle> {
  List<Map<String, dynamic>> vehicles = [];
  List<String> selectedVehicleIds = [];

  @override
  void initState() {
    super.initState();

    fetchVehicle();
  }

  void fetchVehicle() async {
    SmartDialog.showLoading(msg: "Loading...");
    vehicles = await ApiService.vehicles();
    SmartDialog.dismiss();
    setState(() {});
  }

  void onSubmit() async {
    SmartDialog.showLoading(msg: "Loading...");
    var res = await ApiService.assignLocationToVehicle(
        widget.locationId.toString(), selectedVehicleIds.join(","));
    SmartDialog.dismiss();
    if (res) {
      Navigator.pop(context);
    } else {
      SmartDialog.showToast("Something went wrong.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
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
                "Assign Vehicle",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    onSubmit();
                  },
                  child: Container(
                    width: Get.size.width * 0.28,
                    height: Get.size.height * 0.05,
                    decoration: BoxDecoration(color: Color(0xffd6d7d7)),
                    child: Center(
                        child: Text(
                      "Submit",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ),
            ),
            Container(
                width: Get.size.width * 0.99,
                height: Get.size.height * 0.04,
                color: Color(0xffc0c0c0),
                child: Center(
                  child: Text(
                    "Vehicle below*",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                )),
            Container(
              height: Get.size.height,
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: vehicles
                    .map(
                      (item) => CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          if (value == true) {
                            selectedVehicleIds.add("${item["serviceId"]}");
                          } else {
                            selectedVehicleIds.removeWhere(
                                (element) => element == "${item["serviceId"]}");
                          }
                          setState(() {});
                        },
                        value:
                            selectedVehicleIds.contains("${item["serviceId"]}"),
                        title: Text(
                          item["vehReg"],
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VehiclenoModel {
  String title;
  bool isChecked;

  VehiclenoModel(this.title, this.isChecked);
}
