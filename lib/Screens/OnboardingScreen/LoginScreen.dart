import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide Response;
import 'package:trackofyapp/Screens/DrawerScreen/NotificationsScreen.dart';
import 'package:trackofyapp/Screens/OnboardingScreen/ForgotPassword.dart';
import 'package:trackofyapp/Screens/HomeScreen/HomeScreen.dart';
import 'package:trackofyapp/Screens/OnboardingScreen/Terms%20and%20Condition.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/constants.dart';
import 'package:trackofyapp/Widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submitForm() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    //  bool checkbox = isChecked;
    if (isChecked) {
      SmartDialog.showLoading(msg: "Loading...");
      final response = await ApiService.login(username, password);
      SmartDialog.dismiss();
      if (response) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        
      }
    } else {
      //  print('Terms and Conditions not accepted');
      SmartDialog.showToast('Terms and Conditions not accepted');
    }

    // Send a POST request to the API endpoint
  }

  bool _isObscure = true;
  bool isChecked = false;

  @override
  void initState() {
    _usernameController.text = "";
    _passwordController.text = "";
    // _usernameController.text = "dps_faridabad";
    // _passwordController.text = "12345";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff0973a3),
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
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
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Image.asset(
                          "assets/images/logo.png",
                          //      height: Get.size.height * 0.08,
                          width: Get.size.width * 0.6,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              color: ThemeColor.primarycolor,
                              //     width: MediaQuery.of(context).size.width * 0.95,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/username_img.png",
                                      height: 35,
                                      width: 35,
                                    ),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0,
                                      ),
                                      child: Container(
                                        child: TextFormField(
                                          controller: _usernameController,
                                          style: TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              isDense: true,
                                              labelText: "Username*",
                                              labelStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always),
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            ),
                            //Password field
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              color: ThemeColor.primarycolor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/password_img.png",
                                      height: 30,
                                      width: 30,
                                    ),
                                    Expanded(
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 15.0,
                                          ),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.65,
                                            child: TextFormField(
                                              obscureText: _isObscure,
                                              controller: _passwordController,
                                              style: TextStyle(
                                                  color: Colors.white),
                                              decoration: InputDecoration(
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                isDense: true,
                                                labelText: "Password*",
                                                labelStyle: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                suffixIcon: IconButton(
                                                    icon: Icon(
                                                      _isObscure
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off,
                                                      color: Colors.white,
                                                      size: 30,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _isObscure =
                                                            !_isObscure;
                                                      });
                                                    }),
                                              ),
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Checkbox(
                                        value: isChecked,
                                        onChanged: (value) {
                                          setState(() => isChecked = value!);
                                        },
                                        activeColor: ThemeColor.greycolor,
                                        checkColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "I accept the terms and conditions.",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                                onTap: _submitForm,
                                child: Container(
                                    height: 40,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: ThemeColor.primarycolor,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'LOGIN',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ))),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => ForgotPassword());
                                    },
                                    child: Text(
                                      "Forgot Password ?",
                                      style: TextStyle(
                                          color: Colors.grey.shade600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => Terms());
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey.shade300,
                                ),
                                child: Center(
                                  child: Text(
                                    'READ TERMS AND CONDITIONS',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            InkWell(
                              onTap: () async {
                                final Uri url = Uri.parse(
                                    'https://play.google.com/store/apps/details?id=com.example.trackofy');
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                } else {
                                  throw Exception('Could not launch $url');
                                }
                              },
                              child: Text(
                                "App Version 3.048",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ),
                            SizedBox(height: 10),
                            InkWell(
                              child: Text(
                                "Developed and Designed by trackofy team",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              onTap: () async {
                                final Uri url =
                                    Uri.parse('https://www.trackofy.com');
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                } else {
                                  throw Exception('Could not launch $url');
                                }
                              },
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
  }
}
