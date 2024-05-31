import 'dart:async';
import 'dart:math';

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Screens/DrawerScreen/AlertSettingScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/MapHelper.dart';
import 'package:trackofyapp/Screens/DrawerScreen/PlaybackScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/drawer.dart';
import 'package:trackofyapp/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vector_math/vector_math.dart' as vMath;

class VehicleDetailScreen extends StatefulWidget {
  var serviceId;
  VehicleDetailScreen({Key? key, required this.serviceId}) : super(key: key);

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen>
    with TickerProviderStateMixin {
  static final LatLng _kMapCenter =
      LatLng(19.018255973653343, 72.84793849278007);

  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 7.0, tilt: 0, bearing: 0);

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> vehicles = [];

  final List<Marker> _markers = <Marker>[];
  List<LatLng> points = [];

  late GoogleMapController mapCtrl;
  MapType mapType = MapType.normal;

  String selectedMap = "Google";

  var vehicleData;
  var selected;
  late List selectedList;
  double vLat = 19.018255973653343, vLng = 72.84793849278007;
  bool isExpand = false;
  bool isFirstPanel = true;
  bool isTracking = true;

  PageController _pageController = PageController();
  Set<Polyline> polylines = Set.from([]);

  final _mapMarkerSC = StreamController<List<Marker>>();
  StreamSink<List<Marker>> get _mapMarkerSink => _mapMarkerSC.sink;
  Stream<List<Marker>> get mapMarkerStream => _mapMarkerSC.stream;
  var carIcon;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
    isTracking = false;
  }

  fetchData() async {
    await onTracking();
    if (isTracking) {
      Future.delayed(Duration(seconds: 10), () {
        fetchData();
      });
    }
  }

  onTracking() async {
    if (!isTracking) {
      return;
    }
    print("==== TRACKING START ====");
    data = await ApiService.liveTracking(widget.serviceId.toString());
    _markers.clear();
    if (data.isNotEmpty) {
      var e = data[0];
      vehicleData = e;
      LatLng ePos = LatLng(double.parse(e["lat"]), double.parse(e["lng"]));
      BitmapDescriptor markerIcon =
          await MapHelper.getMarkerImageFromUrl(e["icon"]);
      carIcon = markerIcon;
      var zoomLevel = await mapCtrl.getZoomLevel();
      mapCtrl.animateCamera(CameraUpdate.newLatLngZoom(ePos, zoomLevel));
      vLat = double.parse(e["lat"]);
      vLng = double.parse(e["lng"]);

      if (points.indexOf(ePos) == -1) {
        points.add(ePos);
      }
      if (points.length >= 2) {
        animateCar(
          points[points.length - 2].latitude,
          points[points.length - 2].longitude,
          points[points.length - 1].latitude,
          points[points.length - 1].longitude,
          _mapMarkerSink,
          this,
          mapCtrl,
        );
      } else {
        _markers.add(Marker(
            markerId: MarkerId(e["vehicle_name"]),
            icon: markerIcon,
            position: ePos,
            rotation: double.parse(e["angle"])));
      }
      polylines = Set.from([
        Polyline(
          polylineId: PolylineId('1'),
          points: points,
          color: Colors.black,
          width: 2,
        )
      ]);
      print("$vLat, $vLng");
      _mapMarkerSink.add(_markers);
      setState(() {});
    }
    print("==== TRACKING END ====");
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
                size: 24,
              )),
          centerTitle: false,
          title: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${vehicleData != null ? vehicleData["vehicle_name"] : "Vehicle"}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: ThemeColor.primarycolor,
                  ),
                ),
                Text(
                  "${vehicleData != null ? vehicleData["lastcontact"] : "Last Contact"}",
                  style: TextStyle(
                    fontSize: 11,
                    color: ThemeColor.primarycolor,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0, top: 4),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showSelectMapDialog();
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/worldwide.png",
                          height: 27,
                          width: 27,
                        ),
                        Text(
                          "Select Map",
                          style: TextStyle(
                            fontSize: 10,
                            color: ThemeColor.primarycolor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () async {
                      // setState(() {
                      //   isTracking = false;
                      // });
                      if (vehicleData == null) {
                        return;
                      }
                      await Get.to(() => PlaybackScreen(
                            serviceId: widget.serviceId,
                            vehicleName:
                                "${vehicleData != null ? vehicleData["vehicle_name"] : "Vehicle"}",
                          ));
                      // setState(() {
                      //   isTracking = true;
                      //   fetchData();
                      // });
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/video-player.png",
                          height: 27,
                          width: 27,
                        ),
                        Text(
                          "PLAYBACK",
                          style: TextStyle(
                            fontSize: 10,
                            color: ThemeColor.primarycolor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () async {
                      // setState(() {
                      //   isTracking = false;
                      // });
                      await Get.to(() => AlertSettingScreen(
                            serviceId: widget.serviceId,
                            vehicleName: vehicleData != null
                                ? vehicleData["vehicle_name"]
                                : "",
                          ));
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/caution.png",
                          height: 27,
                          width: 27,
                        ),
                        Text(
                          "ALERT",
                          style: TextStyle(
                            fontSize: 10,
                            color: ThemeColor.primarycolor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  onMap(),
                  Positioned(
                    left: 8,
                    bottom: 30,
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      mini: true,
                      onPressed: () {
                        showMapTypeDialog();
                      },
                      child: Image.asset(
                        "assets/images/worldwide.png",
                        height: 27,
                        width: 27,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      mini: true,
                      onPressed: () {
                        if (selectedMap == "Google") {
                          mapCtrl.animateCamera(CameraUpdate.newLatLngZoom(
                              LatLng(vLat, vLng), 14));
                        }
                      },
                      child: Icon(
                        Icons.my_location,
                        size: 27,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 100,
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      mini: true,
                      onPressed: () {
                        onShareLocation();
                      },
                      child: Icon(
                        Icons.share,
                        size: 27,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 150,
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      mini: true,
                      onPressed: () {
                        gotoNavigation();
                      },
                      child: Icon(
                        Icons.car_repair,
                        size: 27,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 12,
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: Colors.grey),
                    bottom: BorderSide(color: Colors.grey)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onVerticalDragStart: (details) {
                setState(() {
                  isExpand = !isExpand;
                });
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        onIgnitionData(),
                        Text(
                          "Ignition",
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    SizedBox(width: 8),
                    Column(
                      children: [
                        onBatteryData(),
                        Text(
                          "Battery(${vehicleData != null ? vehicleData["battery_percent_val"] : "0"})",
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    SizedBox(width: 8),
                    Column(
                      children: [
                        onACData(),
                        Text(
                          "AC",
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    SizedBox(width: 8),
                    Column(
                      children: [
                        Image.asset(
                          "assets/images/door.png",
                          width: 20,
                        ),
                        Text(
                          "Door",
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey,
            ),
            if (isExpand)
              Column(
                children: [
                  Container(
                    height: 145,
                    child: PageView.builder(
                        itemCount: 2,
                        controller: _pageController,
                        pageSnapping: true,
                        onPageChanged: (pos) {
                          isFirstPanel = pos == 0;
                          setState(() {});
                        },
                        itemBuilder: (context, pagePosition) {
                          if (pagePosition == 0) {
                            return Column(
                              children: [
                                Container(
                                  color: Colors.grey,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(width: 8),
                                                  Image.asset(
                                                    "assets/images/meter.png",
                                                    width: 15,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "Odometer (km)",
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                              Text(vehicleData != null
                                                  ? vehicleData["odometer"]
                                                  : '0')
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 1),
                                      Expanded(
                                        child: Container(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(width: 8),
                                                  Image.asset(
                                                    "assets/images/ic_distance.png",
                                                    width: 15,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "Today Distance (km)",
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                              Text(vehicleData != null
                                                  ? vehicleData["distance"]
                                                  : 'N/A')
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(width: 1, color: Colors.grey),
                                      Expanded(
                                        child: Container(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(width: 8),
                                                  Image.asset(
                                                    "assets/images/ic_speed_new.PNG",
                                                    width: 15,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "Speed (kmph)",
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                              Text(vehicleData != null
                                                  ? vehicleData["speed"]
                                                  : '0')
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.grey,
                                ),
                                Container(
                                  color: Colors.grey,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(width: 8),
                                                  Image.asset(
                                                    "assets/images/ic_last_parking.png",
                                                    width: 15,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "Last Parked",
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                              Text(vehicleData != null
                                                  ? vehicleData["halttime"]
                                                  : 'N/A')
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 1),
                                      Expanded(
                                        child: Container(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(width: 8),
                                                  Image.asset(
                                                    "assets/images/ic_idle.png",
                                                    width: 15,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "Idle Since",
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                              Text(vehicleData != null
                                                  ? vehicleData["idletime"]
                                                  : 'N/A')
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(width: 1, color: Colors.grey),
                                      Expanded(
                                        child: Container(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(width: 8),
                                                  Image.asset(
                                                    "assets/images/ic_today_halt_new.png",
                                                    width: 15,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "Max Speed (kmph)",
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                              Text(vehicleData != null
                                                  ? vehicleData["maxspeed"]
                                                  : '0')
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.grey,
                                ),
                                Container(
                                  color: Colors.grey,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(width: 8),
                                                  Image.asset(
                                                    "assets/images/ic_car_status.png",
                                                    width: 15,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "Vehicle Status",
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                              Text(vehicleData != null
                                                  ? vehicleData[
                                                      "vehicle_status"]
                                                  : 'N/A')
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 1),
                                      Expanded(
                                        child: Container(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(width: 8),
                                                  Image.asset(
                                                    "assets/images/ic_car_battery.png",
                                                    width: 15,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "Unit Battery",
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                              Text(vehicleData != null
                                                  ? vehicleData["unit_battery"]
                                                  : 'N/A')
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(width: 1, color: Colors.grey),
                                      Expanded(
                                        child: Container(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(width: 8),
                                                  Image.asset(
                                                    "assets/images/permit.png",
                                                    width: 15,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "Permit",
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                              Text(vehicleData != null
                                                  ? vehicleData["permit"]
                                                  : 'N/A')
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.grey,
                                ),
                                Container(
                                  color: Colors.grey,
                                  child: IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            color: Colors.white,
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(width: 8),
                                                    Image.asset(
                                                      "assets/images/Untitled_design__4_-removebg-preview.png",
                                                      width: 15,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      "Insurance",
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                                Text(vehicleData != null
                                                    ? vehicleData["insurance"]
                                                    : 'N/A')
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 1),
                                        Expanded(
                                          child: Container(
                                            color: Colors.white,
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(width: 8),
                                                    Image.asset(
                                                      "assets/images/ic_co2.png",
                                                      width: 15,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      "Pollution",
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                                Text(vehicleData != null
                                                    ? vehicleData["pollution"]
                                                    : 'Invalid')
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(width: 1, color: Colors.grey),
                                        Expanded(
                                          child: Container(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return Column(
                            children: [
                              Container(
                                color: Colors.grey,
                                child: IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(width: 8),
                                                  Image.asset(
                                                    "assets/images/ic_today_halt_new.png",
                                                    width: 15,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "Total Parked",
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                              Text(vehicleData != null
                                                  ? vehicleData["total_parked"]
                                                  : 'N/A')
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 1),
                                      Expanded(
                                        child: Container(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(width: 8),
                                                  Image.asset(
                                                    "assets/images/ic_idle.png",
                                                    width: 15,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "Today Idle",
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                              Text(vehicleData != null
                                                  ? vehicleData["today_idle"]
                                                  : 'N/A')
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(width: 1, color: Colors.grey),
                                      Expanded(
                                        child: Container(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(width: 8),
                                                  Image.asset(
                                                    "assets/images/meter.png",
                                                    width: 15,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "Today Running",
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                              Text(vehicleData != null
                                                  ? vehicleData["today_running"]
                                                  : 'N/A')
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 1,
                                color: Colors.grey,
                              ),
                              Container(
                                color: Colors.grey,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(width: 8),
                                                Image.asset(
                                                  "assets/images/meter.png",
                                                  width: 15,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  "Today Inactive",
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              ],
                                            ),
                                            Text(vehicleData != null
                                                ? vehicleData["today_inactive"]
                                                : 'N/A')
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 1),
                                    Expanded(
                                      child: Container(
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(width: 8),
                                                Image.asset(
                                                  "assets/images/ic_equator.png",
                                                  width: 15,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  "Latitude",
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              ],
                                            ),
                                            Text(vehicleData != null
                                                ? vehicleData["lat"]
                                                : 'N/A')
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(width: 1, color: Colors.grey),
                                    Expanded(
                                      child: Container(
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(width: 8),
                                                RotatedBox(
                                                  quarterTurns: 90,
                                                  child: Image.asset(
                                                    "assets/images/ic_equator.png",
                                                    width: 15,
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  "Longitude",
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              ],
                                            ),
                                            Text(vehicleData != null
                                                ? vehicleData["lng"]
                                                : 'N/A')
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 1,
                                color: Colors.grey,
                              ),
                              Container(
                                color: Colors.grey,
                                child: IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(width: 8),
                                                  Image.asset(
                                                    "assets/images/ic_fitness.png",
                                                    width: 15,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "Fitness",
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                              Text(vehicleData != null
                                                  ? vehicleData["fitness"]
                                                  : 'N/A')
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(width: 1, color: Colors.grey),
                                      Expanded(
                                        child: Container(color: Colors.white),
                                      ),
                                      Container(width: 1, color: Colors.grey),
                                      Expanded(
                                        child: Container(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            if (isFirstPanel == false) {
                              setState(() {
                                isFirstPanel = true;
                                _pageController.previousPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.bounceIn);
                              });
                            }
                          },
                          child: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            if (isFirstPanel == false) {
                              setState(() {
                                isFirstPanel = true;
                                _pageController.previousPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.bounceIn);
                              });
                            }
                          },
                          child: Icon(
                            Icons.circle,
                            color: isFirstPanel ? Colors.white : Colors.grey,
                            size: 10,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            if (isFirstPanel == true) {
                              setState(() {
                                isFirstPanel = false;
                                _pageController.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.bounceIn);
                              });
                            }
                          },
                          child: Icon(
                            Icons.circle,
                            color: isFirstPanel ? Colors.grey : Colors.white,
                            size: 10,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            if (isFirstPanel == true) {
                              setState(() {
                                isFirstPanel = false;
                                _pageController.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.bounceIn);
                              });
                            }
                          },
                          child: Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black87,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                        "${vehicleData != null ? vehicleData["address"] : ""}",
                        style: TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                  SizedBox(width: 16),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Alert!"),
                              titlePadding: EdgeInsets.all(16),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16),
                              content: Text(
                                  "Do you want to Immobilize your vehicle?\n!! When Immobilize, the vehicle will be in ARM state !!"),
                              actionsPadding:
                                  EdgeInsets.symmetric(horizontal: 16),
                              actions: [
                                TextButton(
                                  child: Text("NO"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text("YES"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 20,
                        ),
                        Text("To Immobilize",
                            style:
                                TextStyle(color: Colors.white, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showMapTypeDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text("Normal"),
                    onTap: () {
                      setState(() {
                        mapType = MapType.normal;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text("Satelite"),
                    onTap: () {
                      setState(() {
                        mapType = MapType.satellite;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text("Terrain"),
                    onTap: () {
                      setState(() {
                        mapType = MapType.terrain;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text("Hybrid"),
                    onTap: () {
                      setState(() {
                        mapType = MapType.hybrid;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  showSelectMapDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text("Google Map"),
                    onTap: () {
                      setState(() {
                        selectedMap = "Google";
                        Navigator.pop(context);
                      });
                    },
                  ),
                  ListTile(
                    title: Text("Bing Map"),
                    onTap: () {
                      setState(() {
                        selectedMap = "Bing";
                        Navigator.pop(context);
                      });
                    },
                  ),
                  ListTile(
                    title: Text("OpenStreet Map"),
                    onTap: () {
                      setState(() {
                        selectedMap = "OpenStreet";
                        Navigator.pop(context);
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  onMap() {
    if (selectedMap == "Google") {
      // return GoogleMap(
      //   initialCameraPosition: _kInitialPosition,
      //   markers: Set<Marker>.of(_markers),
      //   mapType: mapType,
      //   polylines: polylines,
      //   onMapCreated: (controller) {
      //     mapCtrl = controller;
      //     fetchData();
      //   },
      // );
      return StreamBuilder<List<Marker>>(
          stream: mapMarkerStream,
          builder: (context, snapshot) {
            return GoogleMap(
              initialCameraPosition: _kInitialPosition,
              mapType: mapType,
              polylines: polylines,
              rotateGesturesEnabled: true,
              tiltGesturesEnabled: true,
              mapToolbarEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                mapCtrl = controller;
                fetchData();
              },
              markers: Set<Marker>.of(snapshot.data ?? []),
              padding: EdgeInsets.all(8),
            );
          });
    } else if (selectedMap == "Bing") {
      return FutureBuilder(
          future: getBingUrlTemplate(
              'https://dev.virtualearth.net/REST/V1/Imagery/Metadata/RoadOnDemand?output=json&uriScheme=https&include=ImageryProviders&key=${BING_MAP_KEY}'),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            print(snapshot.data);
            if (snapshot.hasData) {
              return SfMaps(
                layers: [
                  MapTileLayer(
                    initialZoomLevel: 14,
                    zoomPanBehavior: MapZoomPanBehavior(),
                    initialFocalLatLng: MapLatLng(vLat, vLng),
                    initialMarkersCount: 1,
                    markerBuilder: (BuildContext context, int index) {
                      return MapMarker(
                        latitude: vLat,
                        longitude: vLng,
                        iconColor: Colors.white,
                        iconStrokeColor: Colors.black,
                        iconStrokeWidth: 2,
                        child: Image.asset(
                          "assets/images/red_car.png",
                          width: 30,
                        ),
                      );
                    },
                    urlTemplate: snapshot.data as String,
                  ),
                ],
              );
            }
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          });
    }
    return SfMaps(
      layers: [
        MapTileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          initialZoomLevel: 14,
          initialFocalLatLng: MapLatLng(vLat, vLng),
          zoomPanBehavior: MapZoomPanBehavior(),
          initialMarkersCount: 1,
          markerBuilder: (BuildContext context, int index) {
            return MapMarker(
              latitude: vLat,
              longitude: vLng,
              iconColor: Colors.white,
              iconStrokeColor: Colors.black,
              iconStrokeWidth: 2,
              child: Image.asset(
                "assets/images/red_car.png",
                width: 30,
              ),
            );
          },
        ),
      ],
    );
  }

  gotoNavigation() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Vehicle Navigation"),
            titlePadding: EdgeInsets.all(16),
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            content: Text("Are you sure want to navigate to your vehicle?"),
            actionsPadding: EdgeInsets.symmetric(horizontal: 16),
            actions: [
              TextButton(
                child: Text("NO"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("YES"),
                onPressed: () async {
                  final uri = Uri(
                      scheme: "google.navigation",
                      // host: '"0,0"',  {here we can put host}
                      queryParameters: {'q': '$vLat, $vLng'});
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    debugPrint('An error occurred');
                    SmartDialog.showToast(
                        "Please install Google Navigator App.");
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  onShareLocation() async {
    Share.share('Lat: $vLat, Lng: $vLng');
  }

  onIgnitionData() {
    String ignitionTxt = "rsz_battery_no_data";
    if (vehicleData == null) {
      ignitionTxt = "rsz_battery_no_data";
    } else if (vehicleData["ignitionOnOff"] == "Off") {
      ignitionTxt = "rsz_battery_ignition_off";
    } else if (vehicleData["ignitionOnOff"] == "On") {
      ignitionTxt = "rsz_battery_ignition_on";
    } else if (vehicleData["ignitionOnOff"] == "Idle") {
      ignitionTxt = "rsz_battery_ignition_idle";
    }

    return Container(
      width: 20,
      height: 20,
      child: Center(
          child: Image.asset(
        "assets/images/$ignitionTxt.png",
        width: 20,
      )),
    );
  }

  onBatteryData() {
    var value = vehicleData == null
        ? 0
        : double.parse(vehicleData["battery_percent_val"].toString());
    if (value == 0) {
      return Icon(
        Icons.battery_0_bar,
        color: Colors.red,
        size: 20,
      );
    } else if (value < 30 && value >= 1) {
      return Icon(
        Icons.battery_2_bar,
        color: Colors.red,
        size: 20,
      );
    } else if (value < 50 && value >= 30) {
      return Icon(
        Icons.battery_3_bar,
        color: Colors.orange,
        size: 20,
      );
    } else if (value >= 50 && value < 100) {
      return Icon(
        Icons.battery_5_bar,
        color: Colors.green,
        size: 20,
      );
    } else if (value == 100) {
      return Icon(
        Icons.battery_full,
        color: Colors.green,
        size: 20,
      );
    }

    return Icon(
      Icons.battery_0_bar,
      color: Colors.red,
      size: 20,
    );
  }

  onACData() {
    String acTxt = "freezer-safe";
    if (vehicleData == null) {
      acTxt = "freezer-safe";
    } else if (vehicleData["ac"] == "OFF") {
      acTxt = "freezer-safe1";
    } else if (vehicleData["ac"] == "ON") {
      acTxt = "freezer-safe2";
    }

    return Image.asset(
      "assets/images/$acTxt.png",
      width: 20,
    );
  }

  animateCar(
    double fromLat, //Starting latitude
    double fromLong, //Starting longitude
    double toLat, //Ending latitude
    double toLong, //Ending longitude
    StreamSink<List<Marker>>
        mapMarkerSink, //Stream build of map to update the UI
    TickerProvider
        provider, //Ticker provider of the widget. This is used for animation
    GoogleMapController controller, //Google map controller of our widget
  ) async {
    final double bearing =
        getBearing(LatLng(fromLat, fromLong), LatLng(toLat, toLong));

    _markers.clear();

    var carMarker = Marker(
        markerId: MarkerId(vehicleData["vehicle_name"]),
        position: LatLng(fromLat, fromLong),
        icon: carIcon,
        anchor: const Offset(0.5, 0.5),
        flat: true,
        rotation: bearing,
        draggable: false);

    //Adding initial marker to the start location.
    _markers.add(carMarker);
    mapMarkerSink.add(_markers);

    final animationController = AnimationController(
      duration: const Duration(seconds: 8), //Animation duration of marker
      vsync: provider, //From the widget
    );

    Tween<double> tween = Tween(begin: 0, end: 1);

    _animation = tween.animate(animationController)
      ..addListener(() async {
        //We are calculating new latitude and logitude for our marker
        final v = _animation!.value;
        double lng = v * toLong + (1 - v) * fromLong;
        double lat = v * toLat + (1 - v) * fromLat;
        LatLng newPos = LatLng(lat, lng);

        //Removing old marker if present in the marker array
        if (_markers.contains(carMarker)) _markers.remove(carMarker);

        //New marker location
        carMarker = Marker(
            markerId: MarkerId(vehicleData["vehicle_name"]),
            position: newPos,
            icon: carIcon,
            anchor: const Offset(0.5, 0.5),
            flat: true,
            rotation: bearing,
            draggable: false);

        //Adding new marker to our list and updating the google map UI.
        _markers.add(carMarker);
        mapMarkerSink.add(_markers);

        var zoomLevel = await mapCtrl.getZoomLevel();
        //Moving the google camera to the new animated location.
        controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: newPos, zoom: zoomLevel)));
      });

    //Starting the animation
    animationController.forward();
  }

  double getBearing(LatLng begin, LatLng end) {
    double lat = (begin.latitude - end.latitude).abs();
    double lng = (begin.longitude - end.longitude).abs();

    if (begin.latitude < end.latitude && begin.longitude < end.longitude) {
      return vMath.degrees(atan(lng / lat));
    } else if (begin.latitude >= end.latitude &&
        begin.longitude < end.longitude) {
      return (90 - vMath.degrees(atan(lng / lat))) + 90;
    } else if (begin.latitude >= end.latitude &&
        begin.longitude >= end.longitude) {
      return vMath.degrees(atan(lng / lat)) + 180;
    } else if (begin.latitude < end.latitude &&
        begin.longitude >= end.longitude) {
      return (90 - vMath.degrees(atan(lng / lat))) + 270;
    }
    return -1;
  }
}
