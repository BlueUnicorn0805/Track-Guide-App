import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:trackofyapp/Screens/DrawerScreen/SettingsScreen/ControlLocation.dart';
import 'package:trackofyapp/Screens/DrawerScreen/SettingsScreen/DriverManagement.dart';
import 'package:trackofyapp/Screens/DrawerScreen/SettingsScreen/VehiclePerformanceManagement.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/constants.dart';

class ConfigureDriver extends StatefulWidget {
  const ConfigureDriver({Key? key}) : super(key: key);

  @override
  State<ConfigureDriver> createState() => _ConfigureDriverState();
}

class _ConfigureDriverState extends State<ConfigureDriver> {
  String dropdownname = 'Select Category Type';
  List<Map<String, dynamic>> categoryTypes = [];
  List<Map<String, dynamic>> criterionTypes = [];
  List<String> selectedCriterion = [];
  List<String> selectedIds = [];
  var selectedType;
  var selectedTypeId;

  TextEditingController overspeedMinCtrl = TextEditingController();
  TextEditingController overspeedMaxCtrl = TextEditingController();
  TextEditingController distanceMinCtrl = TextEditingController();
  TextEditingController distanceMaxCtrl = TextEditingController();
  TextEditingController haltTimeMinCtrl = TextEditingController();
  TextEditingController haltTimeMaxCtrl = TextEditingController();
  TextEditingController runningTimeMinCtrl = TextEditingController();
  TextEditingController runningTimeMaxCtrl = TextEditingController();
  TextEditingController idletimeMinCtrl = TextEditingController();
  TextEditingController idletimeMaxCtrl = TextEditingController();
  TextEditingController harshaccelerationCountCtrl = TextEditingController();
  TextEditingController harshbreakingMinCountCtrl = TextEditingController();

  @override
  void initState() {
    getPerformance();
    super.initState();
  }

  void getPerformance() async {
    SmartDialog.showLoading(msg: "Loading...");
    categoryTypes = await ApiService.getPerformanceCategory();
    SmartDialog.dismiss();
  }

  onSubmit() async {
    List<Map<String, dynamic>> group = [];
    if (selectedType == null) {
      SmartDialog.showToast("Please select the Category.");
      return;
    }
    if (selectedCriterion.isEmpty) {
      SmartDialog.showToast("Please select the Criterion.");
      return;
    }
    bool isValid = true;
    for (var i = 0; i < selectedIds.length; i++) {
      if (selectedCriterion[i] == "Running Time Range") {
        group.add({
          "position_id": selectedIds[i].toString(),
          "min": runningTimeMinCtrl.text.toString(),
          "max": runningTimeMaxCtrl.text.toString(),
        });
        if (runningTimeMinCtrl.text.isEmpty ||
            runningTimeMaxCtrl.text.isEmpty) {
          isValid = false;
        }
      } else if (selectedCriterion[i] == "Overspeed Limit") {
        group.add({
          "position_id": selectedIds[i].toString(),
          "min": overspeedMinCtrl.text.toString(),
          "max": overspeedMaxCtrl.text.toString(),
        });
        if (overspeedMinCtrl.text.isEmpty || overspeedMaxCtrl.text.isEmpty) {
          isValid = false;
        }
      } else if (selectedCriterion[i] == "Distance Range") {
        group.add({
          "position_id": selectedIds[i].toString(),
          "min": distanceMinCtrl.text.toString(),
          "max": distanceMaxCtrl.text.toString(),
        });
        if (distanceMinCtrl.text.isEmpty || distanceMaxCtrl.text.isEmpty) {
          isValid = false;
        }
      } else if (selectedCriterion[i] == "Halt Time Range") {
        group.add({
          "position_id": selectedIds[i].toString(),
          "min": haltTimeMinCtrl.text.toString(),
          "max": haltTimeMaxCtrl.text.toString(),
        });
        if (haltTimeMinCtrl.text.isEmpty || haltTimeMaxCtrl.text.isEmpty) {
          isValid = false;
        }
      } else if (selectedCriterion[i] == "Idle Time Range") {
        group.add({
          "position_id": selectedIds[i].toString(),
          "min": idletimeMinCtrl.text.toString(),
          "max": idletimeMaxCtrl.text.toString(),
        });
        if (idletimeMinCtrl.text.isEmpty || idletimeMaxCtrl.text.isEmpty) {
          isValid = false;
        }
      } else if (selectedCriterion[i] == "Harsh Acceleration") {
        group.add({
          "position_id": selectedIds[i].toString(),
          "count": harshaccelerationCountCtrl.text.toString(),
        });
        if (harshaccelerationCountCtrl.text.isEmpty) {
          isValid = false;
        }
      } else if (selectedCriterion[i] == "Harsh Braking") {
        group.add({
          "position_id": selectedIds[i].toString(),
          "count": harshbreakingMinCountCtrl.text.toString(),
        });
        if (harshbreakingMinCountCtrl.text.isEmpty) {
          isValid = false;
        }
      }
    }
    if (!isValid) {
      SmartDialog.showToast("Please Enter complete details.");
      return;
    }
    var jsonString = jsonEncode(group);
    SmartDialog.showLoading(msg: "Loading...");
    var res = await ApiService.addDriverPerformance(
        jsonString, selectedType["performance_id"]);
    SmartDialog.dismiss();
    if (res) {
      SmartDialog.showToast("Success!!!");
    } else {
      SmartDialog.showToast("Something went wrong.");
    }
  }

  bool ol = false;
  bool dr = false;
  bool htr = false;
  bool rtr = false;
  bool itr = false;
  bool ha = false;
  bool hb = false;

  List<String> userChecked = [];

//  String dropdownname = 'Select Frequency';

  // List of items in our dropdown menu
  var names = [
    'Select Frequency',
    "Daily",
    "Weekly",
    "Monthly",
    "Custom",
  ];
  bool isVisible = false;

  bool checkBoxValue = false;
  bool checkBoxValue2 = false;
  bool checkBoxValue3 = false;
  bool checkBoxValue4 = false;
  bool checkBoxValue5 = false;
  bool checkBoxValue6 = false;
  bool checkBoxValue7 = false;

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
                "Configure Driver Performance",
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
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                height: Get.size.height * 0.07,
                width: Get.size.width * 0.95,
                decoration: BoxDecoration(
                  color: Color(0xffcbd5d5),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 0.5), //(x,y)
                      blurRadius: 3.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: PopupMenuButton(
                    onSelected: (item) async {
                      criterionTypes = await ApiService.getPerformanceCriterion(
                          item["performance_id"].toString());
                      setState(() {
                        print(item);
                        selectedType = item;
                      });
                    },
                    itemBuilder: (BuildContext context) => categoryTypes
                        .map((e) => PopupMenuItem(
                              value: e,
                              child: Text(e["name"] ?? ""),
                            ))
                        .toList(),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                          selectedType == null
                              ? "Select Category Type"
                              : selectedType["name"],
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                height: Get.size.height * 0.07,
                width: Get.size.width * 0.95,
                decoration: BoxDecoration(
                  color: Color(0xffcbd5d5),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 0.5), //(x,y)
                      blurRadius: 3.0,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Select Criterion Below*",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Container(
              height: Get.size.height * 0.24,
              child: ListView.builder(
                  itemCount: criterionTypes.length,
                  itemBuilder: (BuildContext context, int index) {
                    final criterion = criterionTypes[index];
                    return CheckboxListTile(
                      checkColor: Colors.yellow,
                      value: selectedCriterion
                          .contains(criterionTypes[index]["name"]),
                      title: Text(criterion["name"]),
                      controlAffinity: ListTileControlAffinity.leading,
                      tileColor: Colors.white,
                      onChanged: (bool? value) {
                        if (value == true) {
                          selectedCriterion.add(criterionTypes[index]["name"]);
                          selectedIds
                              .add(criterionTypes[index]["id"].toString());
                          print(selectedCriterion);
                        } else {
                          for (var i = 0; i < selectedCriterion.length; i++) {
                            String checkcriterion = selectedCriterion[i];
                            if (checkcriterion == 'Overspeed Limit') {
                              checkBoxValue = false;
                            }
                            if (checkcriterion == 'Distance Range') {
                              checkBoxValue2 = false;
                            }
                            if (checkcriterion == 'Halt Time Range') {
                              checkBoxValue3 = false;
                            }
                            if (checkcriterion == 'Running Time Range') {
                              checkBoxValue4 = false;
                            }
                            if (checkcriterion == 'Idle Time Range') {
                              checkBoxValue5 = false;
                            }
                            if (checkcriterion == 'Harsh Acceleration') {
                              checkBoxValue6 = false;
                            }
                            if (checkcriterion == 'Harsh Braking') {
                              checkBoxValue7 = false;
                            }
                          }
                          selectedCriterion.removeWhere((element) =>
                              element == criterionTypes[index]["name"]);
                          selectedIds.removeWhere((element) =>
                              element ==
                              criterionTypes[index]["id"].toString());
                          print(selectedCriterion);
                        }
                        for (var i = 0; i < selectedCriterion.length; i++) {
                          String checkcriterion = selectedCriterion[i];
                          if (checkcriterion == 'Overspeed Limit') {
                            checkBoxValue = true;
                          }
                          if (checkcriterion == 'Distance Range') {
                            checkBoxValue2 = true;
                          }
                          if (checkcriterion == 'Halt Time Range') {
                            checkBoxValue3 = true;
                          }
                          if (checkcriterion == 'Running Time Range') {
                            checkBoxValue4 = true;
                          }
                          if (checkcriterion == 'Idle Time Range') {
                            checkBoxValue5 = true;
                          }
                          if (checkcriterion == 'Harsh Acceleration') {
                            checkBoxValue6 = true;
                          }
                          if (checkcriterion == 'Harsh Braking') {
                            checkBoxValue7 = true;
                          }
                        }
                        setState(() {});
                      },
                    );
                  }),
            ),
            Visibility(
              visible: checkBoxValue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      "OverSpeed Limit(In KM/H)*",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: Get.size.width * 0.75,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          minmaxtextfield(context, "Mini", overspeedMinCtrl),
                          minmaxtextfield(context, "Max", overspeedMaxCtrl),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: checkBoxValue2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      "Distance Range(In KM)*",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: Get.size.width * 0.75,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          minmaxtextfield(context, "Mini", distanceMinCtrl),
                          minmaxtextfield(context, "Max", distanceMaxCtrl),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: checkBoxValue3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      "Halt Time Range(In Hr)*",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: Get.size.width * 0.75,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          minmaxtextfield(context, "Mini", haltTimeMinCtrl),
                          minmaxtextfield(context, "Max", haltTimeMaxCtrl),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: checkBoxValue4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      "Running Time Range(In Hr)*",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: Get.size.width * 0.75,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          minmaxtextfield(context, "Mini", runningTimeMinCtrl),
                          minmaxtextfield(context, "Max", runningTimeMaxCtrl),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: checkBoxValue5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      "Idle Time Range(In Hr)*",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: Get.size.width * 0.75,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          minmaxtextfield(context, "Mini", idletimeMinCtrl),
                          minmaxtextfield(context, "Max", idletimeMaxCtrl),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: checkBoxValue6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      "Harsh Acceleration(In Count)*",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: Get.size.width * 0.75,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          minmaxtextfield(
                              context, "Count", harshaccelerationCountCtrl),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: checkBoxValue7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      "Harsh Breaking(In Count)*",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: Get.size.width * 0.75,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          minmaxtextfield(
                              context, "Count", harshbreakingMinCountCtrl),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20),
              child: Container(
                height: Get.size.height * 0.06,
                width: Get.size.width * 0.75,
                child: MaterialButton(
                  color: ThemeColor.darkblue,
                  onPressed: () {
                    onSubmit();
                  },
                  child: Center(
                      child: Text(
                    "CREATE DRIVER PERFORMANCE",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  )),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
// void _onSelected(bool selected, String dataName) {
//     if (criterionTypes["name"].map((String) => null)) {
//       setState(() {
//         userChecked.add(dataName);
//       });
//     } else {
//       setState(() {
//         userChecked.remove(dataName);
//       });
//     }
//   }
// }

class CheckboxModel {
  String title;
  bool value;
  bool shouldToggle = true;
  VoidCallback? onToggle;
  CheckboxModel({
    required this.title,
    required this.value,
    this.onToggle,
    this.shouldToggle = true,
  }) {
    onToggle = this.toggle;
  }
  void toggle() {
    if (shouldToggle) value = !value;
  }

  void enable(bool state) => shouldToggle = state;
  bool get isEnabled => shouldToggle;
  VoidCallback? handler() {
    if (shouldToggle) {
      return onToggle;
    } else {
      return null;
    }
  }
}

minmaxfield(context, txt) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(
          txt,
          style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        width: Get.size.width * 0.75,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // minmaxtextfield(context, "Mini"),
              // minmaxtextfield(context, "Max"),
            ],
          ),
        ),
      ),
    ],
  );
}

harshfield(context, txt) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(
          txt,
          style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.bold),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: Get.size.height * 0.05,
              width: Get.size.width * 0.28,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      isDense: true,
                      hintText: "Count",
                      hintStyle:
                          TextStyle(fontSize: 18, color: Colors.grey.shade500)),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
