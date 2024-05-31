import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:trackofyapp/api%20calll.dart';

class data extends StatefulWidget {
  const data({Key? key}) : super(key: key);


  @override
  State<data> createState() => _dataState();


}

class _dataState extends State<data> {

   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showNotification();
    var initializationSettingsIos;
    var initializationSettingsAndroid=
    new AndroidInitializationSettings("app_icon");
    var initializationSetting= new InitializationSettings(
     android: initializationSettingsAndroid,);

    flutterLocalNotificationsPlugin=new
    FlutterLocalNotificationsPlugin();

  }
   showNotification() async {
     var android = AndroidNotificationDetails(
         'channel id', 'channel name');
     var iOS = DarwinNotificationDetails();
     var platform = NotificationDetails(android: android, iOS: iOS);
     await flutterLocalNotificationsPlugin.periodicallyShow(0, 'Hello user,',
         "Don't miss out on the exciting deals for the day.", RepeatInterval.everyMinute, platform);

   }


  @override
  Widget build(BuildContext context) {
    return  Container(

     child: Center(
       child: ElevatedButton(

          onPressed: (){//showNotification();
print("done");
            apiCall().api();
    },
           child: Text("notification"),
        ),
     )

    );
  }
}


