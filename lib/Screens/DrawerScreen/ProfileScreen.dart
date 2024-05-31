import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Screens/DrawerScreen/ChangePassword.dart';
import 'package:trackofyapp/Screens/HomeScreen/HomeScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/drawer.dart';
import 'package:trackofyapp/constants.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic> userDetails = {};
  bool isLoading = false;

  /// fetching PROFILE PAGE DETAILS FROM SAME LOGIN API ->    DEVENDRA KUMAR GUPTA
  Future<void> fetchUserDetails() async {
    SmartDialog.showLoading(msg: "Loading...");
    userDetails = await ApiService.getUserProfile();
    if (userDetails.isNotEmpty) {
      setState(() {
        description = [
          userDetails['company_name'] ?? '',
          userDetails['name'] ?? '',
          userDetails['email_id'] ?? '',
          userDetails['mobile_no'] ?? '',
          userDetails['address'] ?? '',
          userDetails['billing_address'] ?? '',
          '',
        ];
      });
    }
    SmartDialog.dismiss();
  }

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  List<String> images = [
    "assets/images/user_profile.png",
    "assets/images/username_profile.png",
    "assets/images/email_profile.png",
    "assets/images/mobile_profile.png",
    "assets/images/blackloc.png",
    "assets/images/blackloc.png",
    "assets/images/lock.png",
  ];
  List<String> title = [
    "Company Name:",
    "Name:",
    "Email:",
    "Mobile:",
    "Adress:",
    "Billing Adress:",
    "Change password",
  ];
  List<String> description = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      drawer: DrawerClass(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
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
                "Profile",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: ThemeColor.primarycolor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  buildShowDialog(context);
                },
                child: Container(
                  height: Get.size.height * 0.03,
                  width: 120,
                  color: ThemeColor.primarycolor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("DATE FORMAT",
                            style:
                                TextStyle(fontSize: 12, color: Colors.white)),
                        Image.asset(
                          "assets/images/calendar.png",
                          height: 14,
                          width: 14,
                        )
                      ],
                    ),
                  ),
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
                  SizedBox(
                    width: Get.size.width * 0.04,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: description.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              if (index == 0) {
                // Get.to(()=>HomeScreen());
              } else if (index == 1) {
                // Get.to(()=>AddDoctor());
              } else if (index == 2) {
                // Get.to(()=>AddClinic());
              } else if (index == 3) {
                // Get.to(()=>StartScreen());
              } else if (index == 4) {
                // Get.to(()=>StartScreen());
              } else if (index == 5) {
                // Get.to(()=>StartScreen());
              } else if (index == 6) {
                Get.to(() => ChangePasswordScreen());
              }
            },
            child: Card(
              elevation: 2,
              child: SizedBox(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Image.asset(
                              images[index],
                              height: 25,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                                child: Container(
                              child: Text(
                                title[index],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                    fontSize: 17),
                              ),
                            )),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          description[index],
                          style: TextStyle(fontSize: 18),
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 300,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Get.size.height * 0.01,
                        ),
                        Text(
                          "Select Date Format",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(
                          height: Get.size.height * 0.03,
                        ),
                        InkWell(
                          onTap: () {
                            changeDateFormat("yyyy-mm-dd");
                          },
                          child: Text(
                            "yyyy-mm-dd",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.size.height * 0.03,
                        ),
                        InkWell(
                          onTap: () {
                            changeDateFormat("dd-mm-yyyy");
                          },
                          child: Text(
                            "dd-mm-yyyy",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.size.height * 0.03,
                        ),
                        InkWell(
                          onTap: () {
                            changeDateFormat("mm-dd-yyyy");
                          },
                          child: Text(
                            "mm-dd-yyyy",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.size.height * 0.03,
                        ),
                        InkWell(
                          onTap: () {
                            changeDateFormat("yyyy/mm/dd");
                          },
                          child: Text(
                            "yyyy/mm/dd",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.size.height * 0.03,
                        ),
                        InkWell(
                          onTap: () {
                            changeDateFormat("dd/mm/yyyy");
                          },
                          child: Text(
                            "dd/mm/yyyy",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.size.height * 0.03,
                        ),
                        InkWell(
                          onTap: () {
                            changeDateFormat("mm/dd/yyyy");
                          },
                          child: Text(
                            "mm/dd/yyyy",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  changeDateFormat(newFormat) async {
    Navigator.pop(context);
    SmartDialog.showLoading(msg: "Loading...");
    await ApiService.changeDateFormat(newFormat);
    SmartDialog.dismiss();
    SmartDialog.showToast("Date Format is changed.");
  }
}
