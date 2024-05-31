import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackofyapp/Screens/HomeScreen/HomeScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/drawer.dart';
import 'package:trackofyapp/constants.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> vehicles = [];
  List<Map<String, dynamic>> reportData = [];
  List<String> selectedVehicle = [];
  List<String> selectedVehicleIds = [];
  String tillDate = "";
  String scheduleTime = "";
  TextEditingController email1Ctrl = TextEditingController();
  TextEditingController email2Ctrl = TextEditingController();
  TextEditingController email3Ctrl = TextEditingController();

  //text editing controller for text field

  @override
  void initState() {
    tillDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    scheduleTime = DateFormat('HH:mm').format(DateTime.now());
    fetchVehicles();
    fetchReportData();
    super.initState();
  }

  void fetchVehicles() async {
    SmartDialog.showLoading(msg: "Loading...");
    vehicles = await ApiService.vehicles();
    SmartDialog.dismiss();
    setState(() {});
  }

  void fetchReportData() async {
    reportData = await ApiService.getScheduleReportType();
    print(selectedReport);
    setState(() {});
  }

  void scheduleReport() async {
    SmartDialog.showLoading(msg: "Loading...");
    var emails = [];
    if (email1Ctrl.text != "") {
      emails.add(email1Ctrl.text);
    }
    if (email2Ctrl.text != "") {
      emails.add(email2Ctrl.text);
    }
    if (email3Ctrl.text != "") {
      emails.add(email3Ctrl.text);
    }
    await ApiService.saveScheduleReport(
        selectedVehicleIds.join(","),
        dropdownname,
        selectedReport["id"].toString(),
        tillDate,
        scheduleTime,
        emails.join(","));
    SmartDialog.dismiss();
    SmartDialog.showToast("Schedule Report is sent.");
  }

  String dropdownname = 'Select Frequency';
  var selectedReport;

  // List of items in our dropdown menu
  var names = [
    'Select Frequency',
    "Daily",
    "Weekly",
    "Monthly",
    "Custom",
  ];

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
                "Schedule Report",
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
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  height: Get.size.height * 0.07,
                  width: Get.size.width * 0.95,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.5), //(x,y)
                        blurRadius: 3.0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Select Vehicle"),
                                content: Container(
                                  width: 300,
                                  height: 400,
                                  child: StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter alertState) {
                                    return ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: vehicles.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return CheckboxListTile(
                                              value: selectedVehicle.contains(
                                                  vehicles[index]["vehReg"]),
                                              title: Text(
                                                  vehicles[index]["vehReg"]),
                                              onChanged: (bool? value) {
                                                if (value == true) {
                                                  selectedVehicle.add(
                                                      vehicles[index]
                                                          ["vehReg"]);
                                                  selectedVehicleIds.add(
                                                      "${vehicles[index]["serviceId"]}");
                                                } else {
                                                  selectedVehicle.removeWhere(
                                                      (element) =>
                                                          element ==
                                                          vehicles[index]
                                                              ["vehReg"]);
                                                  selectedVehicleIds
                                                      .removeWhere((element) =>
                                                          element ==
                                                          "${vehicles[index]["serviceId"]}");
                                                }
                                                alertState(() {
                                                  vehicles[index]
                                                      ["is_selected"] = value;
                                                });
                                              });
                                        });
                                  }),
                                ),
                                actions: [
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
                              );
                            });
                      },
                      child: Text(
                        selectedVehicle.isEmpty
                            ? "Select vehicle Below*"
                            : selectedVehicle.join(","),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  height: Get.size.height * 0.07,
                  width: Get.size.width * 0.95,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.5), //(x,y)
                        blurRadius: 3.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PopupMenuButton(
                      onSelected: (item) {
                        setState(() {
                          print(item);
                          selectedReport = item;
                        });
                      },
                      itemBuilder: (BuildContext context) => reportData
                          .map((e) => PopupMenuItem(
                                value: e,
                                child: Text(e["menu_name"] ?? ""),
                              ))
                          .toList(),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                            selectedReport == null
                                ? "Select Report Type"
                                : selectedReport["menu_name"],
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  height: Get.size.height * 0.07,
                  width: Get.size.width * 0.95,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.5), //(x,y)
                        blurRadius: 3.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton(
                      isExpanded: true,
                      underline: SizedBox(),
                      value: dropdownname,
                      icon: const Icon(Icons.arrow_drop_down_sharp),
                      items: names.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownname = newValue!;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 22.0),
                child: InkWell(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
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
                      setState(() {
                        tillDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  },
                  child: Container(
                    height: Get.size.height * 0.07,
                    width: Get.size.width * 0.95,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.5), //(x,y)
                          blurRadius: 3.0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("$tillDate"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 22.0),
                child: InkWell(
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                        context: Get.context!,
                        initialTime: TimeOfDay.now(),
                        builder: (context, child) {
                          return Theme(
                              data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                      primary: const Color(0xfff42a41))),
                              child: child!);
                        },
                        initialEntryMode: TimePickerEntryMode.dial,
                        helpText: 'Select Time',
                        cancelText: 'Close',
                        confirmText: 'Confirm',
                        errorInvalidText: 'Provide valid time',
                        hourLabelText: 'Select Hour',
                        minuteLabelText: 'Select Minute');
                    if (pickedTime != null) {
                      scheduleTime =
                          "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                    }
                  },
                  child: Container(
                    height: Get.size.height * 0.07,
                    width: Get.size.width * 0.95,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.5), //(x,y)
                          blurRadius: 3.0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("$scheduleTime"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  height: Get.size.height * 0.07,
                  width: Get.size.width * 0.95,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.5), //(x,y)
                        blurRadius: 3.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: email1Ctrl,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Email 1*',
                          hintStyle: TextStyle(color: Colors.grey[500])),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  height: Get.size.height * 0.07,
                  width: Get.size.width * 0.95,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.5), //(x,y)
                        blurRadius: 3.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: email2Ctrl,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Email 2*',
                          hintStyle: TextStyle(color: Colors.grey[500])),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  height: Get.size.height * 0.07,
                  width: Get.size.width * 0.95,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.5), //(x,y)
                        blurRadius: 3.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: email3Ctrl,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Email 3*',
                          hintStyle: TextStyle(color: Colors.grey[500])),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                    height: Get.size.height * 0.09,
                    width: Get.size.width * 0.95,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.5), //(x,y)
                          blurRadius: 3.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: MaterialButton(
                        color: ThemeColor.darkblue,
                        onPressed: () {
                          scheduleReport();
                        },
                        child: Center(
                            child: Text(
                          "SCHEDULE REPORT",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimeController extends GetxController {
  var selectedTime = TimeOfDay.now().obs;
  @override
  void onClose() {}
  chooseTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
        context: Get.context!,
        initialTime: selectedTime.value,
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                      primary: const Color(0xfff42a41))),
              child: child!);
        },
        initialEntryMode: TimePickerEntryMode.dial,
        helpText: 'Select Time',
        cancelText: 'Close',
        confirmText: 'Confirm',
        errorInvalidText: 'Provide valid time',
        hourLabelText: 'Select Hour',
        minuteLabelText: 'Select Minute');
    if (pickedTime != null && pickedTime != selectedTime.value) {
      selectedTime.value = pickedTime;
    }
  }
}

class TimePicker extends StatelessWidget {
  TimePicker({Key? key}) : super(key: key);
  final controller = Get.put(TimeController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.chooseTime();
        },
        child: Container(
          width: Get.size.width * 0.95,
          child: Text(
            "${controller.selectedTime.value.hour}:${controller.selectedTime.value.minute}",
            style: TextStyle(fontSize: 15, color: ThemeColor.greycolor),
          ),
        ),
      ),
    );
  }
}
