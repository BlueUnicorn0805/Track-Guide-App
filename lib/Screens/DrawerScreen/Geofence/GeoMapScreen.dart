import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Screens/HomeScreen/HomeScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/drawer.dart';
import 'package:trackofyapp/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoMapScreen extends StatefulWidget {
  double lat, lng, radius;
  String address;
  String startTime, endTime;
  String fenceName;
  List<String> selectedVehicleIds = [];

  GeoMapScreen({
    Key? key,
    required this.lat,
    required this.lng,
    required this.address,
    required this.radius,
    required this.startTime,
    required this.endTime,
    required this.fenceName,
    required this.selectedVehicleIds,
  }) : super(key: key);

  @override
  State<GeoMapScreen> createState() => _GeoMapScreenState();
}

class _GeoMapScreenState extends State<GeoMapScreen> {
  static late CameraPosition _kInitialPosition;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Marker> _markers = <Marker>[];
  late GoogleMapController mapCtrl;
  Set<Circle> circles = Set.from([]);
  Set<Polygon> polygons = Set.from([]);
  Set<Polyline> polylines = Set.from([]);
  String selectedPolyType = "";

  @override
  void initState() {
    super.initState();
    _kInitialPosition = CameraPosition(
        target: LatLng(widget.lat, widget.lng),
        zoom: 14.0,
        tilt: 0,
        bearing: 0);
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
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Color(0xff1574a4),
              )),
          centerTitle: false,
          titleSpacing: 0,
          title: Container(
            width: Get.width * 0.7,
            child: Row(
              children: [
                Text(
                  "GeoFence",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    color: ThemeColor.primarycolor,
                  ),
                ),
              ],
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _kInitialPosition,
              markers: Set<Marker>.of(_markers),
              onMapCreated: (controller) {
                mapCtrl = controller;
              },
              onTap: (latlng) {
                onAddMarker(latlng);
              },
              circles: circles,
              polygons: polygons,
              polylines: polylines,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  color: Colors.black.withOpacity(0.6),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          onDrawPolygon();
                        },
                        child:
                            Icon(Icons.rectangle_outlined, color: Colors.white),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () {
                          onDrawPolyline();
                        },
                        child:
                            Icon(Icons.line_axis_outlined, color: Colors.white),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () {
                          onDrawCircle();
                        },
                        child: Icon(Icons.circle_outlined, color: Colors.white),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Container(
                        width: 1,
                        color: Colors.grey,
                        height: 32,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Text(
                          widget.address,
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          circles = Set.from([]);
                          polygons = Set.from([]);
                          polylines = Set.from([]);
                          _markers.clear();
                          selectedPolyType = "";
                        });
                      },
                      child: Container(
                        color: Colors.blue[900]?.withOpacity(0.8),
                        width: 80,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 8),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text(
                          "CLEAR",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    if (selectedPolyType.isNotEmpty)
                      InkWell(
                        onTap: () async {
                          SmartDialog.showLoading(msg: "Loading...");
                          await ApiService.saveFenceAlert(
                              widget.selectedVehicleIds.join(","),
                              widget.startTime,
                              selectedPolyType,
                              widget.radius.toString(),
                              widget.fenceName,
                              widget.lat.toString(),
                              widget.lng.toString());
                          await SmartDialog.dismiss();
                          await SmartDialog.showToast("Success!!!");
                          Navigator.pop(context, "success");
                        },
                        child: Container(
                          color: Colors.blue[900]?.withOpacity(0.8),
                          width: 80,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Text(
                            "SAVE",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  onAddMarker(latlng) {
    _markers.add(Marker(
      markerId: MarkerId("$latlng"),
      position: latlng,
    ));
    setState(() {});
  }

  onDrawCircle() {
    if (_markers.isEmpty) {
      SmartDialog.showToast("Please click any position.");
      return;
    }
    selectedPolyType = "circle";
    circles = Set.from([
      Circle(
          circleId: CircleId("${_markers[0].position}"),
          center: _markers[0].position,
          radius: widget.radius,
          fillColor: Colors.red.withOpacity(0.3),
          strokeWidth: 1,
          strokeColor: Colors.black)
    ]);
    setState(() {});
  }

  onDrawPolygon() {
    selectedPolyType = "polygon";
    List<LatLng> points = [];
    for (Marker marker in _markers) {
      points.add(marker.position);
    }
    polygons = Set.from([
      Polygon(
        polygonId: PolygonId('1'),
        points: points,
        fillColor: Colors.red.withOpacity(0.3),
        strokeColor: Colors.black,
        geodesic: true,
        strokeWidth: 1,
      )
    ]);
    setState(() {});
  }

  onDrawPolyline() {
    selectedPolyType = "line";
    List<LatLng> points = [];
    for (Marker marker in _markers) {
      points.add(marker.position);
    }
    polylines = Set.from([
      Polyline(
        polylineId: PolylineId('1'),
        points: points,
        color: Colors.black,
        width: 2,
      )
    ]);
    setState(() {});
  }
}
