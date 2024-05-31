import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Screens/DrawerScreen/VehicleDetailScreen.dart';
import 'package:trackofyapp/Screens/HomeScreen/HomeScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/drawer.dart';
import 'package:trackofyapp/constants.dart';
import 'package:http/http.dart' as http;

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({Key? key}) : super(key: key);

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // Declare variables to store the fetched data
  List<Map<String, dynamic>> vehiclesData = [];
  Map<String, dynamic> vehiclesDatabyGroup = {};
  List<String> groups = [];

  @override
  void initState() {
    super.initState();
    // Call the API when the widget is first created
    fetchData();
  }

  void fetchData() async {
    SmartDialog.showLoading(msg: "Loading...");
    vehiclesData = await ApiService.vehicles();
    setState(() {});
    SmartDialog.dismiss();
  }

  void fetchDatabyGroup() async {
    SmartDialog.showLoading(msg: "Loading...");
    var groupData = await ApiService.vehiclesByGroup();
    print(groupData);
    for (int i = 0; i < groupData.length; i++) {
      groups.add(groupData[i]["location"]);
      vehiclesDatabyGroup[groupData[i]["location"]] = groupData[i]["result"];
      if (i == 0) {
        dropdownGroup = groupData[i]["location"];
        vehiclesData = List<Map<String, dynamic>>.from(
            (groupData[i]["result"]).map((item) => {
                  'serviceId': item['service_id'],
                  'vehReg': item['veh_reg'],
                  'created': item['sys_created'],
                  'renewalDue': item['sys_renewal_due'],
                  'imei': item['imei'],
                  'mobileNo': item['mobile_no'],
                  'mobileNo1': item['mobile_no1'],
                  'is_selected': false,
                }));
      }
    }
    setState(() {});
    SmartDialog.dismiss();
  }

  String dropdownvalue = 'ListView';
  String dropdownGroup = 'Select Name..';

  // List of items in our dropdown menu
  var items = ['ListView', 'GroupView'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      drawer: DrawerClass(),
      key: scaffoldKey,
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
          title: Row(
            children: [
              Container(
                width: Get.size.width * 0.30,
                child: DropdownButton(
                  underline: SizedBox(),
                  isExpanded: true,
                  // Initial Value
                  value: dropdownvalue,
                  // Down Arrow Icon
                  icon: const Icon(Icons.arrow_drop_down_sharp),
                  // Array list of items
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                      onTap: () {
                        if (items == "GroupView") {
                          fetchDatabyGroup();
                        } else {
                          fetchData();
                        }
                      },
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),
              ),
              SizedBox(
                width: 8,
              ),
              if (dropdownvalue == "GroupView")
                Container(
                  width: Get.size.width * 0.30,
                  child: DropdownButton(
                    underline: SizedBox(),
                    isExpanded: true,
                    value: dropdownGroup,
                    icon: const Icon(Icons.arrow_drop_down_sharp),
                    items: groups.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                        onTap: () {
                          setState(() {
                            vehiclesData = List<Map<String, dynamic>>.from(
                                vehiclesDatabyGroup[item].map((item) => {
                                      'serviceId': item['service_id'],
                                      'vehReg': item['veh_reg'],
                                      'created': item['sys_created'],
                                      'renewalDue': item['sys_renewal_due'],
                                      'imei': item['imei'],
                                      'mobileNo': item['mobile_no'],
                                      'mobileNo1': item['mobile_no1'],
                                      'is_selected': false,
                                    }));
                            print(vehiclesData);
                          });
                        },
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownGroup = newValue!;
                      });
                    },
                  ),
                )
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: GestureDetector(
                  onTap: () {
                    Get.offAll(() => HomeScreen());
                  },
                  child: Icon(
                    Icons.home,
                    color: ThemeColor.primarycolor,
                    size: 25,
                  )),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                    vehiclesData.length, // use the length of the fetched data
                itemBuilder: (BuildContext context, int index) {
                  final vehicle = vehiclesData[index];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => VehicleDetailScreen(
                                serviceId: vehicle["serviceId"]));
                          },
                          child: Material(
                            elevation: 2,
                            color: Colors.grey[350],
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0, left: 8),
                                              child: Text(
                                                vehicle['vehReg'],
                                                style: TextStyle(
                                                    color: ThemeColor.logocolor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                "Service ID                  :",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black54),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 6.0),
                                              child: Text(
                                                "Creation                    :",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black54),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 6.0),
                                              child: Text(
                                                "EXPIRY                      :",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black54),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 6.0),
                                              child: Text(
                                                "IMEI                           :",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black54),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 6.0),
                                              child: Text(
                                                "SIM 1                         :",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black54),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 6.0),
                                              child: Text(
                                                "SIM 2                         :",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black54),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 06.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 14.0),
                                                child: Text(
                                                  "Track Vehicle",
                                                  style: TextStyle(
                                                      color: Colors.green[400],
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6.0),
                                                      child: Text(
                                                        vehicle['serviceId']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6.0),
                                                      child: Text(
                                                        vehicle['created'],
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6.0),
                                                      child: Text(
                                                        vehicle['renewalDue'],
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6.0),
                                                      child: Text(
                                                        vehicle['imei'],
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6.0),
                                                      child: Text(
                                                        vehicle['mobileNo'] ??
                                                            "",
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6.0),
                                                      child: Text(
                                                        vehicle['mobileNo1'] ??
                                                            "",
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// / previous  day work
// class VehicleScreen extends StatefulWidget {
//   const VehicleScreen({Key? key}) : super(key: key);
//
//
//   @override
//   State<VehicleScreen> createState() => _VehicleScreenState();
//
// }
//
// class _VehicleScreenState extends State<VehicleScreen> {
//   final GlobalKey <ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//
//   List<Map<String, dynamic>> vehicles = [];
//
//
//   Future<void> _fetchData() async {
//     final url = Uri.parse('http://trackofy.fasttracksoft.us/API/user_api.php?method=get_user_vehicles&user_id=890');
//     final response = await http.post(url);
//
//     if (response.statusCode == 200 && response.body.isNotEmpty) {
//
//       final data = jsonDecode(response.body);
//       print(data);
//       setState(() {
//         vehicles = List<Map<String, dynamic>>.from(data);
//       });
//     } else {
//       throw Exception('Failed to fetch data from API');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }
//
//
//
//
//   String dropdownvalue = 'Listview';
//
//   // List of items in our dropdown menu
//   var items = [
//     'Listview',
//
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[350],
//       drawer: DrawerClass(),
//       key: scaffoldKey,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(60.0),
//         child: AppBar(
//           elevation: 0,
//           backgroundColor: Colors.white,
//           automaticallyImplyLeading: false,
//           leading: GestureDetector(
//               onTap: () {
//                 scaffoldKey.currentState!.openDrawer();
//               },
//               child: Icon(Icons.menu,color: Color(0xff1574a4),)),
//           title: Container(
//             width: Get.size.width * 0.30,
//             child: DropdownButton(
//               underline: SizedBox(),
//               isExpanded: true,
//               // Initial Value
//               value: dropdownvalue,
//               // Down Arrow Icon
//               icon: const Icon(Icons.arrow_drop_down_sharp),
//               // Array list of items
//               items: items.map((String items) {
//                 return DropdownMenuItem(
//                   value: items,
//                   child: Text(items),
//                 );
//               }).toList(),
//               // After selecting the desired option,it will
//               // change button value to selected value
//               onChanged: (String? newValue) {
//                 setState(() {
//                   dropdownvalue = newValue!;
//                 });
//               },
//             ),
//           ),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.only(right: 12.0),
//               child: GestureDetector(
//                   onTap: () {
//                     Get.to(()=>HomeScreen());
//                   },
//                   child: Icon(Icons.home,color: ThemeColor.primarycolor,size: 25,)),
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               child: ListView.builder(
//                 scrollDirection: Axis.vertical,
//                 physics: NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: vehicles.length,
//                 itemBuilder: (BuildContext context, int index) {
//
//                   final vehicle = vehicles[index];
//                   return Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
//                         child: Material(
//                           elevation: 2,color: Colors.grey[350],
//                           borderRadius: BorderRadius.all(Radius.circular(0)),
//                           child: Container(
//                             height: Get.size.height * 0.22 ,
//                             width: Get.size.width * 0.99,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.all(Radius.circular(0)),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Column(crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Padding(
//
//                                             padding: const EdgeInsets.only(top: 14.0,left: 09),
//                                             child: Text(vehicle['veh_reg'],style: TextStyle(
//                                               color: ThemeColor.logocolor,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 13,
//                                             ),),
//                                             // padding: const EdgeInsets.only(top: 14.0,left: 09),
//                                             // child: Text("DL1ZC8973",style: TextStyle(color: ThemeColor.logocolor,
//                                             // fontWeight: FontWeight.bold,
//                                             // fontSize: 13),),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(top: 8.0),
//                                             child: Text('Service ID: ${vehicle['service_id']}',style: TextStyle(
//                                               fontSize: 13,
//                                               color: Colors.black54,
//                                             ),),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(top: 8.0),
//                                             child: Text('Creation: ${vehicle['sys_created']}',style: TextStyle(
//                                               fontSize: 13,
//                                               color: Colors.black54,
//                                             ),),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(top: 8.0),
//                                             child: Text('EXPIRY: ${vehicle['sys_renewal_due']}',style: TextStyle(
//                                               fontSize: 13,
//                                               color: Colors.black54,
//                                             ),),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(top: 8.0),
//                                             child: Text('IMEI : ${vehicle['imei']}',style: TextStyle(
//                                               fontSize: 13,
//                                               color: Colors.black54,
//                                             ),),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(top: 8.0),
//                                             child: Text('SIM 1: ${vehicle['mobile_no']}',style: TextStyle(
//                                               fontSize: 13,
//                                               color: Colors.black54,
//                                             ),),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(top: 8.0),
//                                             child: Text('SIM 2: ${vehicle['mobile_no1']}',style: TextStyle(
//                                               fontSize: 13,
//                                               color: Colors.black54,
//                                             ),),
//                                           ),
//
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.only(right: 06.0),
//                                         child: Column(crossAxisAlignment: CrossAxisAlignment.end,
//                                           children: [
//                                             Padding(
//                                               padding: const EdgeInsets.only(top: 14.0),
//                                               child: Text("Track Vehicle",style: TextStyle(color: Colors.green[400],
//                                                   fontWeight: FontWeight.bold),),
//                                             ),
//                                             Padding(
//                                               padding: const EdgeInsets.all(8.0),
//                                               child: Column(
//                                                 children: [
//                                                   Padding(
//                                                     padding: const EdgeInsets.only(top: 8.0),
//                                                     child: Text("33765",style: TextStyle(fontSize: 13,color: Colors.black54),),
//                                                   ),
//                                                   Padding(
//                                                     padding: const EdgeInsets.only(top: 6.0),
//                                                     child: Text("2022-09-15",style: TextStyle(fontSize: 13,color: Colors.black54),),
//                                                   ),
//                                                   Padding(
//                                                     padding: const EdgeInsets.only(top: 6.0),
//                                                     child: Text("2023-09-15",style: TextStyle(fontSize: 13,color: Colors.black54),),
//                                                   ),
//                                                   Padding(
//                                                     padding: const EdgeInsets.only(top: 6.0),
//                                                     child: Text("869630055531705",style: TextStyle(fontSize: 13,color: Colors.black54),),
//                                                   ),
//                                                   Padding(
//                                                     padding: const EdgeInsets.only(top: 6.0),
//                                                     child: Text("5754207437142",style: TextStyle(fontSize: 13,color: Colors.black54),),
//                                                   ),
//                                                   Padding(
//                                                     padding: const EdgeInsets.only(top: 6.0),
//                                                     child: Text("",style: TextStyle(fontSize: 13,color: Colors.black54),),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//
//
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
