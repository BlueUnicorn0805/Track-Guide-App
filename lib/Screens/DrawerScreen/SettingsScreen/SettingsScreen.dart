import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Screens/DrawerScreen/SettingsScreen/ControlLocation.dart';
import 'package:trackofyapp/Screens/DrawerScreen/SettingsScreen/DriverManagement.dart';
import 'package:trackofyapp/Screens/DrawerScreen/SettingsScreen/VehiclePerformanceManagement.dart';
import 'package:trackofyapp/Widgets/drawer.dart';
import 'package:trackofyapp/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var images = ["assets/images/Untitled_design__4_-removebg-preview.png","assets/images/locationcar-removebg-preview.png","assets/images/redcar-removebg-preview.png"];
  var title = ["Driver Management","Control Location Management","Vehicle Performance Management"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      // drawer: DrawerClass(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back_outlined,color: Color(0xff1574a4),)),
          centerTitle: false,
          title: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Manage Settings",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,
                color: ThemeColor.primarycolor,
              ),),

            ],
          ),

        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: Get.size.height * 0.03),
              ListView.builder(
                itemCount: images.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                      onTap: (){
                    if(index==0){
                      Get.to(()=>DriverManagement());
                    } else if(index==1){
                      Get.to(()=>ControlLocation());
                    }else if(index==2){
                      Get.to(()=>VehiclePerformanceManagement());
                    }
                  },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: Container(
                          height: Get.size.height * 0.13,
                          width: Get.size.width * 0.95,
                          decoration: BoxDecoration(
                              color: ThemeColor.primarycolor,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(images[index],height: 40,),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(title[index],style: TextStyle(color: Colors.white,fontSize: 13),),
                              )
                            ],
                          ),
                        ),
                      ),
                  );
                }

              )

            ],
          ),
        ),
      ),
    );
  }
}
