import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Screens/HomeScreen/HomeScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/drawer.dart';
import 'package:trackofyapp/constants.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController oldPwdCtrl = TextEditingController();
  TextEditingController newPwdCtrl = TextEditingController();

  Future<void> updatePassword() async {
    if (oldPwdCtrl.text == "" || newPwdCtrl.text == "") {
      SmartDialog.showToast("Please Input Password!!!");
      return;
    }
    SmartDialog.showLoading(msg: "Loading...");
    await ApiService.changePassword(oldPwdCtrl.text, newPwdCtrl.text);
    SmartDialog.dismiss();
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
  }

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
          title: Text(
            "Change Password",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: ThemeColor.primarycolor,
            ),
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
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: oldPwdCtrl,
              decoration: InputDecoration(
                labelText: "Old Password",
              ),
              obscureText: true,
            ),
            TextFormField(
              controller: newPwdCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "New Password",
              ),
            ),
            SizedBox(height: 16),
            MaterialButton(
              minWidth: double.infinity,
              onPressed: () {
                updatePassword();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              color: Color(0xff6200ee),
              child: Text(
                "Change password",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
