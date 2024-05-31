import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackofyapp/Models/User.dart';
import 'package:trackofyapp/Screens/HomeScreen/HomeScreen.dart';
import 'package:trackofyapp/Screens/OnboardingScreen/LoginScreen.dart';
import 'package:trackofyapp/Screens/SplashScreen/SplashScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // await Permission.notification.isDenied.then((value) {
  //   if (value) {
  //     Permission.notification.request();
  //   }
  // });
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var curUserStr = prefs.getString('user');
  if (curUserStr != null) {
    User user = User.fromJson(jsonDecode(curUserStr));
    ApiService.currentUser = user;
  }

  // HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.//
//   return GetMaterialApp( //for navigation dont forget to use GetMaterialApp
//   title: 'getXpro',
//   theme: ThemeData(
//   primarySwatch: Colors.blue,
//   ),
//   initialRoute: '/',
//   routes: {
//   '/': (context) => HomePage(),
//   '/cart': (context) => CartPage(),
//   },
//   );
// }
//

  @override
  Widget build(BuildContext context) {
    // FlutterNativeSplash.remove();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: SplashScreen(),//ApiService.currentUser == null ? LoginScreen() : HomeScreen(),
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
