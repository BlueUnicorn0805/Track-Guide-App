import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/drawer.dart';
import 'package:trackofyapp/Widgets/widgets.dart';
import 'package:trackofyapp/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AlertSettingScreen extends StatefulWidget {
  var serviceId;
  var vehicleName;
  AlertSettingScreen(
      {Key? key, required this.serviceId, required this.vehicleName})
      : super(key: key);

  @override
  State<AlertSettingScreen> createState() => _AlertSettingScreenState();
}

class _AlertSettingScreenState extends State<AlertSettingScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> allAlerts = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    print("======");
    print(widget.serviceId);
    print("======");
    SmartDialog.showLoading(msg: "Loading...");
    data = await ApiService.getVehicleAlerts(widget.serviceId.toString());
    var resAllAlerts = await ApiService.getAllAlerts();
    allAlerts = resAllAlerts.map((e) {
      var res =
          data.where((element) => element["alert_type_id"] == e["alert_id"]);
      if (res.isNotEmpty) {
        print("~~~~~~");
        print(res.first);
        print("~~~~~~");
        return {...e, "is_notification": res.first["is_notification"]};
      }
      return {...e, "is_notification": 0};
    }).toList();
    print("====== Alert Data");
    print(allAlerts);
    print("======");

    SmartDialog.dismiss();

    setState(() {});
  }

  updateAlert(alertId, notify) async {
    SmartDialog.showLoading(msg: "Loading...");
    var res = await ApiService.updateAlert(
        widget.serviceId.toString(), "$alertId", notify);
    SmartDialog.dismiss();
    SmartDialog.showToast(res
        ? "Update Successfully"
        : "An error occurred while communicating with the server.");
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: DrawerClass(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Color(0xff1574a4),
              )),
          centerTitle: false,
          title: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Alert Setting",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    color: ThemeColor.primarycolor,
                  ),
                ),
                Text(
                  widget.vehicleName,
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeColor.primarycolor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: allAlerts.length,
              itemBuilder: (context, index) {
                var alertData = allAlerts[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 2),
                  decoration: BoxDecoration(
                    color: index % 2 == 0
                        ? Colors.white
                        : Color.fromARGB(255, 207, 216, 221),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 1,
                      )
                    ],
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 8),
                          Builder(builder: (context) {
                            String img = "assets/images/information.png";
                            if (alertData["alert_name"] == null) {
                              img = "assets/images/information.png";
                            } else if (alertData["alert_name"] == "Door") {
                              img = "assets/images/ic_door_new.PNG";
                            } else if (alertData["alert_name"] == "AC") {
                              img = "assets/images/ic_ac_new.PNG";
                            } else if (alertData["alert_name"] == "Ignition") {
                              img = "assets/images/ic_ignition_new.PNG";
                            } else if (alertData["alert_name"] ==
                                "Main Power") {
                              img = "assets/images/plug.png";
                            } else if (alertData["alert_name"] == "Panic") {
                              img = "assets/images/ic_speed_new.PNG";
                            } else if (alertData["alert_name"] == "Speed") {
                              img = "assets/images/stop-sign.png";
                            }
                            return Image.asset(img, width: 20);
                          }),
                          SizedBox(width: 8),
                          Text(alertData["alert_name"] ?? ""),
                        ],
                      ),
                      Transform.scale(
                        scale: 0.7,
                        child: Switch(
                          onChanged: (value) async {
                            var res = await updateAlert(
                                alertData["alert_id"], value ? 1 : 0);
                            if (res) {
                              setState(() {
                                alertData["is_notification"] = value ? 1 : 0;
                              });
                            }
                          },
                          value: alertData["is_notification"] == 1,
                          activeColor: ThemeColor.primarycolor,
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
