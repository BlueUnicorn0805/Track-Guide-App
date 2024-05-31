import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trackofyapp/Screens/DrawerScreen/NotificationDetailScreen.dart';
import 'package:trackofyapp/Screens/HomeScreen/HomeScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/drawer.dart';
import 'package:trackofyapp/constants.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  List<NotificationMessage> messages = [];
  List<NotificationMessage> filteremessages = [];
  TextEditingController searchctr = TextEditingController();
  bool isLoading = true;
  String _query = "";

  @override
  void initState() {
    super.initState();
    searchctr.text = "";
    _getNotifications();
  }

  void search(String query) {
    setState(
      () {
        _query = query;
        filteremessages = messages
            .where(
              (item) => item.message.toLowerCase().contains(
                    _query.toLowerCase(),
                  ),
            )
            .toList();
      },
    );
  }

  Future<void> _getNotifications() async {
    SmartDialog.showLoading(msg: "Loading...");
    messages = await ApiService.getNotifications();
    filteremessages = messages;
    SmartDialog.dismiss();
    setState(() {});
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
                  "Notification",
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black87,
                    ),
                    hintText: 'Search Notification',
                  ),
                  controller: searchctr,
                  onChanged: (e) {
                    search(e);
                  },
                ),
              ),
              Padding(
                // height: Get.size.height * 0.03,
                // width: Get.size.width * 0.99,
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Center(
                    child: Text(
                  "You have ${messages.length} unread notifications",
                  style: TextStyle(color: ThemeColor.greycolor, fontSize: 15),
                )),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 05.0),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteremessages.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final message = filteremessages[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Material(
                            elevation: 3,
                            child: InkWell(
                              onTap: () async {
                                await Permission.locationAlways.isDenied.then((value) {
                                  if (value) {
                                    Permission.locationAlways.request();
                                  }
                                });
                                Get.to(() => NotificationDetailScreen(
                                      lat: message.lat,
                                      lng: message.lng,
                                      setOn: message.sentOn,
                                    ));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            "assets/images/Screenshot_2022-09-17_154834-removebg-preview.png",
                                            height: 40),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 22.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Sent ON ${message.sentOn}",
                                                  style: TextStyle(
                                                      color:
                                                          ThemeColor.bluecolor,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  message.message,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        )

        // ListView.builder(
        //   itemCount: messages.length,
        //   itemBuilder: (BuildContext context, int index) {
        //     final message = messages[index];
        //     return ListTile(
        //       title: Text(message.msgStatus),
        //       subtitle: Text(message.message),
        //       trailing: Text(message.sentOn),
        //     );
        //   },
        // ),
        );
  }
}

class NotificationMessage {
  var id;
  final String msgStatus;
  final String message;
  final String sentOn;
  final double lat;
  final double lng;

  NotificationMessage({
    required this.id,
    required this.msgStatus,
    required this.message,
    required this.sentOn,
    required this.lat,
    required this.lng,
  });
}
