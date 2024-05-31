import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/widgets.dart';
import 'package:trackofyapp/constants.dart';

class HumidityReport extends StatefulWidget {
  const HumidityReport({Key? key}) : super(key: key);

  @override
  State<HumidityReport> createState() => _HumidityReportState();
}

class _HumidityReportState extends State<HumidityReport> {
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> drivers = [];
  String startDate = "";
  String endDate = "";
  bool isApply = false;
  var selectedVehicle;
  @override
  void initState() {
    super.initState();
    startDate = endDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    // Call the API when the widget is first created
    fetchData();
  }

  void fetchData() async {
    if (selectedVehicle == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please select Driver")));
      return;
    }
    // data = await ApiService.vehicleSummaryReport(selectedVehicle[id],);
    // data.add({"name": "a"});
    // data.add({"name": "b"});
    // data.add({"name": "c"});
  }

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
                "Humidity Report",
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
            Container(
              height: Get.size.height * 0.07,
              width: Get.size.width * 0.99,
              color: Color(0xffeeeeee),
              child: Center(
                child: searchbox(
                  context,
                  () {},
                  "Search Vehicle",
                  Get.size.height * 0.08,
                  Get.size.width * 1.00,
                  Color(0xffe2e2e2),
                ),
              ),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 90,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                Text(
                                  startDate,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.white),
                                ),
                              ],
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
                            width: 90,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                Text(
                                  endDate,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  MaterialButton(
                    color: Color(0xffd6d7d7),
                    onPressed: () {
                      setState(() {
                        this.isApply = true;
                      });
                    },
                    child: Text(
                      "APPLY",
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
