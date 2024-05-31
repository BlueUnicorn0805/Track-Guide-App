import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Screens/DrawerScreen/SettingsScreen/AddDriverScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/SettingsScreen/ConfigureDriver.dart';
import 'package:trackofyapp/Screens/DrawerScreen/SettingsScreen/EditDriverScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/constants.dart';

class DriverManagement extends StatefulWidget {
  const DriverManagement({Key? key}) : super(key: key);

  @override
  State<DriverManagement> createState() => _DriverManagementState();
}

class _DriverManagementState extends State<DriverManagement> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    SmartDialog.showLoading(msg: "Loading...");
    data = await ApiService.getDrivers();
    SmartDialog.dismiss();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,

        // drawer: DrawerClass(),
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
                  "Driver Management",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: ThemeColor.primarycolor,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          var result = await Get.to(() => AddDriverScreen());
                          if (result == "success") {
                            fetchData();
                          }
                        },
                        child: Container(
                          height: Get.size.height * 0.08,
                          //           width: Get.size.width * 0.2,
                          decoration: BoxDecoration(
                              color: Color(0xffd6d7d7),
                              borderRadius: BorderRadius.circular(05)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/Untitled_design__4_-removebg-preview.png",
                                height: 23,
                              ),
                              Text(
                                "ADD DRIVER",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Get.size.width * 0.02,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => ConfigureDriver());
                      },
                      child: Container(
                        height: Get.size.height * 0.08,
                        // width: Get.size.width * 0.55,
                        decoration: BoxDecoration(
                            color: Color(0xffd6d7d7),
                            borderRadius: BorderRadius.circular(05)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/Untitled_design__4_-removebg-preview.png",
                                height: 23,
                              ),
                              Text(
                                "CONFIGURE DRIVER PERFORMANCE",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    var driverData = data[index];
                    return Container(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 3,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(driverData["name"],
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 14))
                                ],
                              ),
                              InkWell(
                                onTap: () async {
                                  var result =
                                      await Get.to(() => EditDriverScreen(
                                            driverData: driverData,
                                          ));
                                  if (result == "success") {
                                    fetchData();
                                  }
                                },
                                child: Text("Edit Details",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 14)),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              IntrinsicWidth(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("DateOfBirth"),
                                    Text("DL Issued dt"),
                                    Text("DL Expiry dt"),
                                    Text("DL No."),
                                    Text("Assigned Vehicle"),
                                    Text("Contact No."),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(":"),
                                  Text(":"),
                                  Text(":"),
                                  Text(":"),
                                  Text(":"),
                                  Text(":"),
                                ],
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("${driverData["dob"]}"),
                                    Text("${driverData["dl_issued"]}"),
                                    Text("${driverData["dl_expiry"]}"),
                                    Text("${driverData["dl_no"]}"),
                                    Text("${driverData["veh_reg"]}"),
                                    Text(
                                        "${driverData["emergency_contact_no"]}"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
