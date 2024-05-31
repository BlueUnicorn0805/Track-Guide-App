import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackofyapp/Screens/DashboardScreen/NewDashboardScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/Geofence/GeofenceScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/NotificationsScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/POIScreens/PoiScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/ProfileScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/ReportsSelections/ReportsScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/ScheduleScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/SettingsScreen/SettingsScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/TrackingScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/VehicleScreen.dart';
import 'package:trackofyapp/Screens/OnboardingScreen/LoginScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> images = [
    'assets/images/meter.png',
    'assets/images/person.png',
    'assets/images/redcar.png',
    'assets/images/loca.png',
    'assets/images/report.png',
    'assets/images/report.png',
    'assets/images/locationcar.png',
    'assets/images/locationred.png',
    'assets/images/ic_setting_icon.png',
    'assets/images/exit.png',
  ];
  List<String> txt = [
    "Dashboard",
    "Profile",
    "Vehicle",
    "Tracking",
    "Reports",
    "Schedule Reports",
    "Geofence",
    "POI",
    "Settings",
    "Logout",
  ];
  @override
  Widget build(BuildContext context) {
    var x = (Get.width - 0) / 20;

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
          centerTitle: true,
          title: Image.asset(
            "assets/images/logo.png",
            height: 60,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                  onTap: () {
                    Get.to(() => NotificationScreen());
                  },
                  child: Icon(
                    Icons.notifications_sharp,
                    color: Colors.red,
                    size: 35,
                  )),
            )
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/back_home2.jpg"),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          Container(
            height: (Get.width / 5) * 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: GridView.builder(
                padding: EdgeInsets.all(0), //EdgeInsets.fromLTRB(x, x, x, 0),
                itemCount: 10,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  childAspectRatio: 2 / 3,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () async {
                      if (index == 0) {
                        Get.to(() => NewDashboardScreen());
                      } else if (index == 1) {
                        Get.to(() => ProfileScreen());
                      } else if (index == 2) {
                        Get.to(() => VehicleScreen());
                      } else if (index == 3) {
                        Get.to(() => TrackingScreen());
                      } else if (index == 4) {
                        Get.to(() => ReportsScreen());
                      } else if (index == 5) {
                        Get.to(() => ScheduleScreen());
                      } else if (index == 6) {
                        Get.to(() => GeofenceScreen());
                      } else if (index == 7) {
                        Get.to(() => PoiScreen());
                      } else if (index == 8) {
                        Get.to(() => SettingsScreen());
                      } else if (index == 9) {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.remove('user');
                        ApiService.currentUser = null;
                        Get.offAll(() => LoginScreen());
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          width: Get.width / 5,
                          height: Get.width / 5,
                          padding: const EdgeInsets.all(5),
                          child: Image.asset(
                            images[index],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(
                            txt[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12, color: Colors.black87),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
