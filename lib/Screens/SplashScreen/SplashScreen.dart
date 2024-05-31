import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Screens/SplashScreen/SplashScreenController.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GetBuilder(
      builder: (_) => Scaffold(
        body: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.blue.shade200,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [
                        0.6,
                        0.9,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  child: Center(
                    child: Image.asset(
                      "assets/images/logo.png",
                      width: size.width * 0.6,
                    ),
                  ),
                ),
              ],
            )),
      ),
      init: SplashController(),
    );
  }
}
