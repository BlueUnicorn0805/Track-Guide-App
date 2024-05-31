import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Screens/DrawerScreen/POIScreens/AddPOI.dart';
import 'package:trackofyapp/Screens/HomeScreen/HomeScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/drawer.dart';
import 'package:trackofyapp/constants.dart';

class PoiScreen extends StatefulWidget {
  const PoiScreen({Key? key}) : super(key: key);

  @override
  State<PoiScreen> createState() => _PoiScreenState();
}

class _PoiScreenState extends State<PoiScreen> {
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  bool checkedValue = false;
  bool isVisible = false;
  bool isVisible2 = false;
  bool isVisible3 = false;
  List<String> notificationType = [];
  final List<VehiclenoModel3> _items2 = <VehiclenoModel3>[
    VehiclenoModel3('Application', false),
    VehiclenoModel3('Sms', false),
    VehiclenoModel3('Email', false),
  ];
  // bool isTransparent = false;

  List<Map<String, dynamic>> poiLocations = [];
  List<String> selectedPoiIds = [];
  List<Map<String, dynamic>> vehicles = [];
  List<String> selectedVehicleIds = [];
  TextEditingController email1Ctrl = TextEditingController();
  TextEditingController email2Ctrl = TextEditingController();
  TextEditingController email3Ctrl = TextEditingController();
  TextEditingController mobile1Ctrl = TextEditingController();
  TextEditingController mobile2Ctrl = TextEditingController();
  TextEditingController mobile3Ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchVehicle();
    fetchPoiLocations();
  }

  void fetchVehicle() async {
    SmartDialog.showLoading(msg: "Loading...");
    vehicles = await ApiService.vehicles();
    SmartDialog.dismiss();
    setState(() {});
  }

  void fetchPoiLocations() async {
    poiLocations = await ApiService.getPoiLocation();
    setState(() {});
  }

  onSubmit() async {
    SmartDialog.showLoading(msg: "Loading...");
    var res = await ApiService.savePoiAlert(
        selectedVehicleIds.join(","),
        selectedPoiIds.join(","),
        notificationType.map((e) {
          if (e == "Application") {
            return "app";
          } else if (e == "Sms") {
            return "sms";
          } else if (e == "Email") {
            return "email";
          }
        }).join(","),
        mobile1Ctrl.text,
        mobile2Ctrl.text,
        mobile3Ctrl.text,
        email1Ctrl.text,
        email2Ctrl.text,
        email3Ctrl.text);
    SmartDialog.dismiss();
    if (res) {
      SmartDialog.showToast("Success!!!");
    } else {
      SmartDialog.showToast("Something went wrong.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldkey,
      drawer: DrawerClass(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () {
                scaffoldkey.currentState!.openDrawer();
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
                "POI",
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => AddPOIScreen());
                },
                child: Container(
                  height: Get.size.height * 0.06,
                  width: Get.size.width * 0.25,
                  color: ThemeColor.darkblue,
                  child: Center(
                      child: Text(
                    "ADD POI",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  )),
                ),
              ),
            ),
            SizedBox(height: Get.size.height * 0.01),
            InkWell(
              onTap: () {
                setState(() {
                  isVisible3 = !isVisible3;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: Get.size.height * 0.04,
                  width: Get.size.width * 0.90,
                  color: ThemeColor.darkblue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text(
                          "Select Poi Location*",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: Get.size.height * 0.02),
            Visibility(
              visible: isVisible3,
              child: Container(
                height: Get.size.height * 0.24,
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: poiLocations
                      .map(
                        (item) => CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (bool? val) {
                            setState(() {
                              selectedPoiIds.clear();
                              if (val == true) {
                                selectedPoiIds.add(item["id"]);
                              }
                            });
                          },
                          value: selectedPoiIds.contains(item["id"]),
                          title: Text(
                            item["name"],
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 109, 71, 71)),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            SizedBox(height: Get.size.height * 0.02),
            GestureDetector(
              onTap: () => setState(() => isVisible = !isVisible),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: Get.size.height * 0.04,
                  width: Get.size.width * 0.90,
                  color: ThemeColor.darkblue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text(
                          "Select Vehicle below*",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isVisible,
              child: Container(
                height: Get.size.height * 0.24,
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
                              selectedVehicleIds.removeWhere((element) =>
                                  element == "${item["serviceId"]}");
                            }
                            setState(() {});
                          },
                          value: selectedVehicleIds
                              .contains("${item["serviceId"]}"),
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
            ),
            SizedBox(height: Get.size.height * 0.04),
            GestureDetector(
              onTap: () => setState(() => isVisible2 = !isVisible2),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: Get.size.height * 0.04,
                  width: Get.size.width * 0.90,
                  color: ThemeColor.darkblue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text(
                          "Receive Notification on*",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isVisible2,
              child: Container(
                height: Get.size.height * 0.3,
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  children: _items2
                      .map(
                        (VehiclenoModel3 item) => CheckboxListTile(
                          contentPadding: EdgeInsets.only(top: 0, bottom: 0),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (bool? val) {
                            setState(() {
                              item.isChecked = val!;
                              if (val == true) {
                                notificationType.add(item.title);
                              } else {
                                notificationType.removeWhere(
                                    (element) => element == item.title);
                              }
                            });
                          },
                          value: notificationType.contains(item.title),
                          title: Text(
                            item.title,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            Visibility(
              visible: notificationType.contains("Sms"),
              child: Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.5), //(x,y)
                              blurRadius: 3.0,
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: mobile1Ctrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            isDense: true,
                            hintText: "Mobile 1*",
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.5), //(x,y)
                              blurRadius: 3.0,
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: mobile2Ctrl,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            isDense: true,
                            hintText: "Mobile 2*",
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.5), //(x,y)
                              blurRadius: 3.0,
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: mobile3Ctrl,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            isDense: true,
                            hintText: "Mobile 3*",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: notificationType.contains("Email"),
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8)),
                    child: Container(
                      color: Colors.white,
                      child: TextFormField(
                        controller: email1Ctrl,
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          isDense: true,
                          hintText: "Email 1*",
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8)),
                    child: Container(
                      color: Colors.white,
                      child: TextFormField(
                        controller: email2Ctrl,
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          isDense: true,
                          hintText: "Email 2*",
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8)),
                    child: Container(
                      color: Colors.white,
                      child: TextFormField(
                        controller: email3Ctrl,
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          isDense: true,
                          hintText: "Email 3*",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Get.size.height * 0.07),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: InkWell(
                onTap: () {
                  onSubmit();
                },
                child: Container(
                  height: Get.size.height * 0.06,
                  width: Get.size.width * 0.90,
                  color: ThemeColor.darkblue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "SUBMIT",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VehiclenoModel2 {
  String title;
  bool isChecked;

  VehiclenoModel2(this.title, this.isChecked);
}

class VehiclenoModel3 {
  String title;
  bool isChecked;

  VehiclenoModel3(this.title, this.isChecked);
}
