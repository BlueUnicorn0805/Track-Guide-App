import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/constants.dart';

class VehiclePerformanceManagement extends StatefulWidget {
  const VehiclePerformanceManagement({Key? key}) : super(key: key);

  @override
  State<VehiclePerformanceManagement> createState() =>
      _VehiclePerformanceManagementState();
}

class _VehiclePerformanceManagementState
    extends State<VehiclePerformanceManagement> {
  String dropdownname = 'Select Category Type';
  List<Map<String, dynamic>> categoryTypes = [];
  var selectedType;
  TextEditingController distanceMinCtrl = TextEditingController();
  TextEditingController distanceMaxCtrl = TextEditingController();
  TextEditingController idleTimeMinCtrl = TextEditingController();
  TextEditingController idleTimeMaxCtrl = TextEditingController();
  TextEditingController haltTimeMinCtrl = TextEditingController();
  TextEditingController haltTimeMaxCtrl = TextEditingController();
  TextEditingController runningTimeMinCtrl = TextEditingController();
  TextEditingController runningTimeMaxCtrl = TextEditingController();

  @override
  void initState() {
    getPerformanceCategory();
    super.initState();
  }

  void getPerformanceCategory() async {
    SmartDialog.showLoading(msg: "Loading...");
    categoryTypes = await ApiService.getPerformanceCategory();
    SmartDialog.dismiss();
  }

  onSubmit() async {
    if (selectedType == null ||
        distanceMinCtrl.text == "" ||
        distanceMaxCtrl.text == "" ||
        idleTimeMinCtrl.text == "" ||
        idleTimeMaxCtrl.text == "" ||
        haltTimeMinCtrl.text == "" ||
        haltTimeMaxCtrl.text == "" ||
        runningTimeMinCtrl.text == "" ||
        runningTimeMaxCtrl.text == "") {
      SmartDialog.showToast("Please input all information.");
      return;
    }
    SmartDialog.showLoading(msg: "Loading...");
    var res = await ApiService.saveVehiclePerformanceSetting(
        [distanceMinCtrl.text, distanceMaxCtrl.text].join(";"),
        [haltTimeMinCtrl.text, haltTimeMaxCtrl.text].join(";"),
        [runningTimeMinCtrl.text, runningTimeMaxCtrl.text].join(";"),
        [idleTimeMinCtrl.text, idleTimeMaxCtrl.text].join(";"),
        selectedType["performance_id"].toString());
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
                  "Vehicle Performance Setting",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        onSelected: (item) {
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
                Column(
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
                        padding: const EdgeInsets.only(left: 20.0, top: 20),
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
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
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
                          padding: const EdgeInsets.only(left: 20.0, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              minmaxtextfield(context, "Mini", idleTimeMinCtrl),
                              minmaxtextfield(context, "Max", idleTimeMaxCtrl),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
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
                          padding: const EdgeInsets.only(left: 20.0, top: 20),
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
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
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
                          padding: const EdgeInsets.only(left: 20.0, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              minmaxtextfield(
                                  context, "Mini", runningTimeMinCtrl),
                              minmaxtextfield(
                                  context, "Max", runningTimeMaxCtrl),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 10),
                  child: Center(
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
                          "CREATE VEHICLE PERFORMANCE",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

minmaxtextfield(context, txt, ctrl) {
  return Container(
    // height: Get.size.height * 0.04,
    width: Get.size.width * 0.30,
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.black,
        width: 1,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        controller: ctrl,
        style: TextStyle(fontSize: 15),
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
            hintText: txt,
            hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade500)),
      ),
    ),
  );
}
