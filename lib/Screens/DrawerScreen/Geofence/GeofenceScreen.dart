import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Screens/DrawerScreen/Geofence/AddGeofence.dart';
import 'package:trackofyapp/Screens/HomeScreen/HomeScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/drawer.dart';
import 'package:trackofyapp/constants.dart';

class GeofenceScreen extends StatefulWidget {
  const GeofenceScreen({Key? key}) : super(key: key);

  @override
  State<GeofenceScreen> createState() => _GeofenceScreenState();
}

class _GeofenceScreenState extends State<GeofenceScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> parkingData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    SmartDialog.showLoading(msg: "Loading...");
    parkingData = await ApiService.getGeofences();
    SmartDialog.dismiss();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.add),
          backgroundColor: new Color(0xFFE57373),
          onPressed: () async {
            var addGeoRes = await Get.to(() => AddGeofence());
            if (addGeoRes != null) {
              fetchData();
            }
          }),
      key: scaffoldKey,
      drawer: DrawerClass(),
      backgroundColor: Colors.white,
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
                "GeoFence",
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
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              ListView.builder(
                  itemCount: parkingData.length,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    final vehicleReg = parkingData[index]['veh_reg'];
                    final radius = parkingData[index]['radius'];
                    final vehicle = parkingData[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Material(
                        elevation: 1,
                        child: Container(
                          height: Get.size.height * 0.10,
                          width: Get.size.width * 0.95,
                          decoration: BoxDecoration(
                              color: Color(0xffEaf1f7),
                              borderRadius: BorderRadius.circular(05)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Image.asset(
                                        "assets/images/Screenshot_2022-09-17_153904-removebg-preview.png",
                                        height: 25,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            vehicleReg,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: Text(
                                              radius.toString(),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black54),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 17.0),
                                      child: InkWell(
                                        onTap: () async {
                                          SmartDialog.showLoading(
                                              msg: "Loading...");

                                          await ApiService.deleteFenceAlert(
                                              parkingData[index]
                                                  ["geofence_type"],
                                              parkingData[index]
                                                  ["alert_setting_id"]);
                                          await SmartDialog.dismiss();
                                          fetchData();
                                        },
                                        child: Image.asset(
                                          "assets/images/trash-alt-delete-bin-pngrepo-com.png",
                                          height: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
