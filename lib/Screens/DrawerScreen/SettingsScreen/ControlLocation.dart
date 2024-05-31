import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Screens/DrawerScreen/SettingsScreen/AssignVehicle.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/constants.dart';

class ControlLocation extends StatefulWidget {
  const ControlLocation({Key? key}) : super(key: key);

  @override
  State<ControlLocation> createState() => _ControlLocationState();
}

class _ControlLocationState extends State<ControlLocation> {
  final key = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> data = [];
  TextEditingController locationCtrl = TextEditingController();

  bool isVisible = false;
  bool isTransparent = false;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    SmartDialog.showLoading(msg: "Loading...");
    data = await ApiService.getControlLocations();
    SmartDialog.dismiss();
    setState(() {});
  }

  void onSubmit() async {
    if (locationCtrl.text == "") {
      SmartDialog.showToast("Please input Location.");
      return;
    }
    SmartDialog.showLoading(msg: "Loading...");
    var res = await ApiService.saveControlLocation(locationCtrl.text);
    SmartDialog.dismiss();
    if (res) {
      SmartDialog.showToast("Success!!!");
      setState(() {
        isVisible = false;
        locationCtrl.text = "";
      });
      fetchData();
    } else {
      SmartDialog.showToast("Something went wrong.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  "Control Location",
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
            children: [
              Center(
                child: GestureDetector(
                  onTap: () => setState(() => isVisible = !isVisible),
                  child: Container(
                    width: Get.size.width * 0.47,
                    height: Get.size.height * 0.11,
                    decoration: BoxDecoration(color: Color(0xffd6d7d7)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/locationcar-removebg-preview.png",
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            "ADD CONTROL LOCATION",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Visibility(
                  visible: isVisible,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child:
                        buildBox(text: 'Visibilty', color: Color(0xffcbd5d5)),
                  ),
                ),
              ),
              Column(
                children: data
                    .map(
                      (e) => Material(
                        elevation: 5,
                        child: Container(
                          height: Get.size.height * 0.15,
                          width: Get.size.width * 0.95,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() =>
                                        AssignVehicle(locationId: e["id"]));
                                  },
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width: Get.size.width * 0.32,
                                      height: Get.size.height * 0.05,
                                      decoration: BoxDecoration(
                                          color: Color(0xffd6d7d7)),
                                      child: Center(
                                          child: Text(
                                        "ASSIGN VEHICLE",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Container(
                                    height: Get.size.height * 0.06,
                                    width: Get.size.width * 0.92,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1.0, color: Colors.black)),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: Get.size.height * 0.12,
                                          width: Get.size.width * 0.20,
                                          child: Center(
                                            child: Text(
                                              "ID:${e["id"]}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        VerticalDivider(
                                          thickness: 1,
                                          width: 1,
                                          color: Colors.black,
                                        ),
                                        Container(
                                          height: Get.size.height * 0.06,
                                          width: Get.size.width * 0.36,
                                          child: Center(
                                            child: Text(
                                              "Created On:${e["created_date"]}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        VerticalDivider(
                                          thickness: 1,
                                          width: 1,
                                          color: Colors.black,
                                        ),
                                        Container(
                                          height: Get.size.height * 0.06,
                                          width: Get.size.width * 0.31,
                                          child: Center(
                                            child: Text(
                                              "${e["location"]}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ));
  }

  Widget buildBox({
    required String text,
    required Color color,
  }) =>
      GestureDetector(
        onTap: () {
          final snackBar = SnackBar(
            padding: EdgeInsets.symmetric(vertical: 8),
            backgroundColor: color,
            content: Text(
              '$text is clickable!!',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          );
        },
        child: Container(
          width: Get.size.width * 0.95,
          height: Get.size.height * 0.17,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: color,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  controller: locationCtrl,
                  decoration: InputDecoration(
                    hintText: "Enter Control Location",
                    hintStyle: TextStyle(fontSize: 15),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black54,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: Get.size.height * 0.05,
                    width: Get.size.width * 0.95,
                    child: MaterialButton(
                      color: ThemeColor.darkblue,
                      onPressed: () {
                        onSubmit();
                      },
                      child: Center(
                          child: Text(
                        "ADD",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
