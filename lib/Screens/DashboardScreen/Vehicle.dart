import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Screens/DrawerScreen/VehicleDetailScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/widgets.dart';
import 'package:trackofyapp/constants.dart';
import 'package:http/http.dart' as http;

class Vehicle extends StatefulWidget {
  String ids;
  Vehicle({Key? key, required this.ids}) : super(key: key);

  @override
  State<Vehicle> createState() => _VehicleState();
}

class _VehicleState extends State<Vehicle> {
  List<Map<String, dynamic>> vehiclesData = [];
  List<Map<String, dynamic>> filteredItems = [];
  TextEditingController searchCtrl = TextEditingController();
  String _query = '';
  bool isUpdating = true;

  @override
  void initState() {
    super.initState();
    searchCtrl.text = "";
    // Call the API when the widget is first created
    fetchData();
  }

  void search(String query) {
    setState(
      () {
        _query = query;
        filteredItems = vehiclesData
            .where(
              (item) => item['Name'].toLowerCase().contains(
                    _query.toLowerCase(),
                  ),
            )
            .toList();
      },
    );
  }

  void fetchData() async {
    SmartDialog.showLoading(msg: 'Loading...');
    if (!isUpdating) {
      return;
    }
    vehiclesData = await ApiService.getVehicles(widget.ids);
    filteredItems = vehiclesData;
    // filteredItems = vehiclesData.where((e) {
    //   return e[""];
    // }).toList();
    // print(filteredItems);
    setState(() {});
    SmartDialog.dismiss();
    Future.delayed(Duration(seconds: 30), () {
      fetchData();
    });
  }

  @override
  void dispose() {
    isUpdating = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () {
                setState(() {
                  isUpdating = false;
                });
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
                "Vehicles",
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
      body: Column(
        children: [
          Center(
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: new Stack(alignment: Alignment.center, children: <Widget>[
                Image(
                  image: AssetImage('assets/images/search.png'),
                  width: Get.width * 0.8,
                ),
                TextField(
                  textAlign: TextAlign.start,
                  autocorrect: false,
                  controller: searchCtrl,
                  onChanged: (e) {
                    print(e.toString());
                    search(e);
                  },
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: Get.width * 0.23),
                    hintText: 'Search Vehicle',
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ]),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              //  shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                final vehicle = filteredItems[index];
                return InkWell(
                  onTap: () {
                    Get.to(() => VehicleDetailScreen(
                          serviceId: vehicle["VehicleId"],
                        ));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 8.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 3,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          child: Column(
                            children: [
                              Image.network(
                                '${vehicle['icon_url']}',
                                width: 40,
                              ),
                              SizedBox(height: 5),
                              Text(
                                "${vehicle['TotalDistance'].toString()}km",
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      vehicle['Name'],
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 15),
                                    ),
                                  ),
                                  onIgnitionData(vehicle['Ignition']),
                                  SizedBox(width: 12),
                                  double.parse(vehicle['signal_percent']
                                              .toString()) !=
                                          0
                                      ? Image.asset(
                                          "assets/images/rsz_signal_tower_on.png",
                                          height: 20,
                                          width: 20,
                                        )
                                      : Image.asset(
                                          "assets/images/rsz_signal_tower_off.png",
                                          height: 20,
                                          width: 20,
                                        ),
                                  SizedBox(width: 12),
                                  onACData(vehicle['AC']),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${vehicle["LastContact"]}',
                                    style: TextStyle(
                                        color: Colors.yellow[800],
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              FutureBuilder(
                                  future: ApiService.getAddress(
                                      vehicle["Latitude"],
                                      vehicle["Longitude"]),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      return Text(snapshot.data,
                                          style: TextStyle(fontSize: 12));
                                    }
                                    return Text("Loading...",
                                        style: TextStyle(fontSize: 12));
                                  })
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  onIgnitionData(ignition) {
    String ignitionTxt = "rsz_battery_no_data";
    if (ignition == null || ignition == "battery_no_data") {
      ignitionTxt = "rsz_battery_no_data";
    } else if (ignition == "battery_ignition_off") {
      ignitionTxt = "rsz_battery_ignition_off";
    } else if (ignition == "battery_ignition_on") {
      ignitionTxt = "rsz_battery_ignition_on";
    } else if (ignition == "battery_ignition_idle") {
      ignitionTxt = "rsz_battery_ignition_idle";
    } else if (ignition == "plug_no_data") {
      ignitionTxt = "rsz_plug_no_data";
    } else if (ignition == "plug_ignition_off") {
      ignitionTxt = "rsz_plug_ignition_off";
    } else if (ignition == "plug_ignition_on") {
      ignitionTxt = "rsz_plug_ignition_on";
    } else if (ignition == "plug_ignition_idle") {
      ignitionTxt = "rsz_plug_ignition_idle";
    }

    return Image.asset(
      "assets/images/$ignitionTxt.png",
      width: 20,
    );
  }

  onACData(ac) {
    String acTxt = "freezer-safe";
    if (ac == null) {
      acTxt = "freezer-safe";
    } else if (ac == "OFF") {
      acTxt = "freezer-safe";
    } else if (ac == "ON") {
      acTxt = "freezer-safe2";
    }

    return Image.asset(
      "assets/images/$acTxt.png",
      width: 20,
    );
  }
}
