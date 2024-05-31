import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackofyapp/Screens/DashboardScreen/DashboardScreen.dart';
import 'package:trackofyapp/Screens/DashboardScreen/NewDashboardScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/Geofence/GeofenceScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/NotificationsScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/ParkingScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/POIScreens/PoiScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/ProfileScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/ReportsSelections/ReportsScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/ScheduleScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/SettingsScreen/SettingsScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/TrackingScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/VehicleScreen.dart';
import 'package:trackofyapp/Screens/HomeScreen/HomeScreen.dart';
import 'package:trackofyapp/Screens/OnboardingScreen/LoginScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/constants.dart';

class DrawerClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        height: Get.size.height,
        child: ListView(
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: 50,
            ),
            GestureDetector(
              child: tiles('Home', "assets/images/ic_setting_icon.png"),
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Get.offAll(() => HomeScreen());
              },
            ),
            GestureDetector(
              child: tiles('Dashboard', "assets/images/meter.png"),
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Get.offAll(() => NewDashboardScreen());
              },
            ),
            GestureDetector(
                onTap: () {
                  Get.offAll(() => ProfileScreen());
                },
                child: tiles('Profile', "assets/images/person.png")),
            GestureDetector(
              child: tiles('Vehicle', "assets/images/redcar.png"),
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Get.offAll(() => VehicleScreen());
              },
            ),
            GestureDetector(
              child: tiles('Tracking', "assets/images/loca.png"),
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Get.offAll(() => TrackingScreen());
              },
            ),
            GestureDetector(
                child: tiles('Reports', "assets/images/report.png"),
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Get.offAll(() => ReportsScreen());
                }),
            GestureDetector(
                child: tiles('Schedule Reports', "assets/images/report.png"),
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Get.offAll(() => ScheduleScreen());
                }),
            GestureDetector(
                child: tiles('Notification',
                    "assets/images/Screenshot_2022-09-17_154834-removebg-preview.png"),
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Get.offAll(() => NotificationScreen());
                }),
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Get.offAll(() => GeofenceScreen());
                },
                child: tiles('Geofence', "assets/images/locationcar.png")),
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Get.offAll(() => PoiScreen());
                },
                child: tiles('POI', "assets/images/locationred.png")),
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Get.offAll(() => ParkingScreen());
                },
                child: tiles('Parking', "assets/images/locationred.png")),
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Get.offAll(() => SettingsScreen());
                },
                child: tiles('Setting', "assets/images/ic_setting_icon.png")),
            GestureDetector(
              child: tiles('Logout', "assets/images/exit.png"),
              onTap: () async {
                var dlg = await Get.defaultDialog(
                    backgroundColor: ThemeColor.primarycolor,
                    titlePadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    title: 'Are you sure want to Logout?',
                    titleStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    textCancel: "CANCEL",
                    textConfirm: "OK",
                    confirmTextColor: Colors.white,
                    contentPadding: const EdgeInsets.all(0),
                    cancelTextColor: Colors.white,
                    buttonColor: ThemeColor.secondarycolor,
                    onConfirm: () async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove('user');
                      ApiService.currentUser = null;
                      Get.offAll(() => LoginScreen());
                    },
                    middleText: "");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget tiles(String text, img) {
    return ListTile(
      title: Row(
        children: [
          Image.asset(
            img,
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
