import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Screens/HomeScreen/HomeScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/drawer.dart';
import 'package:trackofyapp/Widgets/widgets.dart';
import 'package:trackofyapp/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({Key? key}) : super(key: key);

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> vehicles = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchVehicles();
  }

  Future<void> fetchVehicles() async {
    vehicles = await ApiService.getVehicleParkingMode();
    print(vehicles);
    setState(() {
      isLoading = false;
    });
  }

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
                "Parking Mode",
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
                  InkWell(
                    onTap: () {
                      Get.offAll(() => HomeScreen());
                    },
                    child: Icon(
                      Icons.home,
                      color: ThemeColor.primarycolor,
                      size: 27,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: isLoading // check isLoading value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: vehicles.length,
                      itemBuilder: (BuildContext context, int index) {
                        final vehicle = vehicles[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            // height: Get.size.height * 0.08,
                            width: Get.size.width * 0.95,
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            decoration: BoxDecoration(
                                color: Color(0xffCde3f7),
                                borderRadius: BorderRadius.circular(05)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Image.asset(
                                          "assets/images/parking_ev.png",
                                          color: ThemeColor.primarycolor,
                                          height: 20,
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
                                              vehicle['veh_reg'],
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            // Padding(
                                            //   padding: const EdgeInsets.only(top: 10.0),
                                            //   child: Text(vehicle['veh_reg'],style: TextStyle(fontSize: 10,color: Colors.black54),),
                                            // )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SwitchScreen(
                                        isSwitched:
                                            vehicle["parking_mode"],
                                        onSwitch: (value) {
                                          onUpdateParking(vehicle["service_id"], value);
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  onUpdateParking(sId, val)async {
    SmartDialog.showLoading(msg: "Loading...");
    var res = await ApiService.updateParking(sId.toString(), val);
    SmartDialog.dismiss();
    SmartDialog.showToast(res ? "Success!!!" : "Something went wrong");
  }
}
