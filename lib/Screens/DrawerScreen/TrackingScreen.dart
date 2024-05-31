import 'dart:async';
import 'dart:math';

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:fluster/fluster.dart';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Screens/DrawerScreen/MapHelper.dart';
import 'package:trackofyapp/Screens/DrawerScreen/MapMarker.dart';
import 'package:trackofyapp/Screens/DrawerScreen/VehicleDetailScreen.dart';
import 'package:trackofyapp/Screens/HomeScreen/HomeScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/drawer.dart';
import 'package:trackofyapp/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  static final LatLng _kMapCenter = LatLng(28.6505, 77.135);

  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 7.0, tilt: 0, bearing: 0);

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> vehicles = [];
  final List<Marker> _markers = <Marker>[];
  late GoogleMapController mapCtrl;

  var selected;
  late List selectedList;

  final int _minClusterZoom = 0;
  final int _maxClusterZoom = 19;
  Fluster<MapMarker>? _clusterManager;
  double _currentZoom = 7;
  bool _isMapLoading = true;
  bool _areMarkersLoading = true;
  final Color _clusterColor = Colors.blue;
  final Color _clusterTextColor = Colors.white;

  bool isTracking = true;
  List<Polyline> polylines = [];
  Map<String, List<LatLng>> vehicleLines = Map();
  int selectIndex = -1;

  void _onMapCreated(GoogleMapController controller) async {
    mapCtrl = controller;
    mapCtrl
        .animateCamera(CameraUpdate.newLatLngZoom(_kMapCenter, _currentZoom));

    setState(() {
      _isMapLoading = false;
    });

    vehicles = await ApiService.vehicles();
    _initMarkers();
  }

  /// Inits [Fluster] and all the markers with network images and updates the loading state.
  _initMarkers() async {
    print("==== START TRACKING(tracking) ====");
    final List<MapMarker> markers = [];
    // _markers.clear();
    selectIndex = -1;
    for (int i = 0; i < vehicles.length; i++) {
      if (!isTracking) {
        return;
      }

      print("===================");
      print(
          "${vehicles[i]["serviceId"]}, ${vehicleLines[vehicles[i]["serviceId"].toString()]}");
      print("===================");
      if (selected == null ||
          selected["serviceId"] == vehicles[i]["serviceId"]) {
        var trackingRes =
            await ApiService.liveTracking(vehicles[i]["serviceId"].toString());
        if (trackingRes.isNotEmpty) {
          var trackingInfo = trackingRes[0];
          print(trackingInfo);
          var vehPos = LatLng(double.parse(trackingInfo["lat"]),
              double.parse(trackingInfo["lng"]));
          final BitmapDescriptor markerImage =
              await MapHelper.getMarkerImageFromUrl(trackingInfo["icon"]);

          if (vehicleLines[vehicles[i]["serviceId"].toString()] == null) {
            vehicleLines[vehicles[i]["serviceId"].toString()] = [vehPos];
          } else {
            List<LatLng> temp =
                vehicleLines[vehicles[i]["serviceId"].toString()]!;
            if (temp[temp.length - 1] != vehPos) {
              vehicleLines[vehicles[i]["serviceId"].toString()]!.add(vehPos);
            }
          }

          markers.add(
            MapMarker(
                id: (i + 1).toString(),
                position: vehPos,
                icon: markerImage,
                rotation: double.parse(trackingInfo["angle"]),
                info: InfoWindow(
                    title: trackingInfo["vehicle_name"],
                    onTap: () async {
                      setState(() {
                        isTracking = false;
                      });
                      await Get.to(() => VehicleDetailScreen(
                          serviceId: vehicles[i]["serviceId"].toString()));
                      setState(() {
                        isTracking = true;

                        _initMarkers();
                      });
                    }),
                onClick: () async {}),
          );

          // if (i == vehicles.length - 1) {
          //   mapCtrl.animateCamera(CameraUpdate.newLatLngZoom(
          //       LatLng(double.parse(trackingInfo["lat"]),
          //           double.parse(trackingInfo["lng"])),
          //       _currentZoom));
          // }
        }
      }
    }
    // print('===========');
    // print("${markers.length} ${selectIndex}");
    // print('===========');
    polylines.clear();
    if (selected == null) {
      for (int i = 0; i < vehicles.length; i++) {
        polylines.add(Polyline(
          polylineId: PolylineId(i.toString()),
          points: vehicleLines[vehicles[i]["serviceId"].toString()] ?? [],
          color: Colors.black,
          width: 2,
        ));
      }
    } else {
      polylines.add(Polyline(
        polylineId: PolylineId(selected["serviceId"].toString()),
        points: vehicleLines[selected["serviceId"].toString()] ?? [],
        color: Colors.black,
        width: 2,
      ));
    }

    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
    );

    await _updateMarkers();
    print("==== END TRACKING(tracking) ====");

    if (isTracking) {
      Future.delayed(Duration(seconds: 10), () {
        _initMarkers();
      });
    }
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  Future<void> _updateMarkers([double? updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    setState(() {
      _areMarkersLoading = true;
    });

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      80,
    );

    _markers
      ..clear()
      ..addAll(updatedMarkers);

    setState(() {
      _areMarkersLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    print("dispose");
    isTracking = false;
    super.dispose();
  }

  void fetchVehicles() async {
    SmartDialog.showLoading(msg: "Loading...");
    vehicles = await ApiService.vehicles();
    SmartDialog.dismiss();

    // vehicles.insert(0, {'serviceId': "all", 'vehReg': "ALL"});

    await initMap();

    setState(() {});
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
                scaffoldKey.currentState!.openDrawer();
              },
              child: Icon(
                Icons.menu,
                color: Color(0xff1574a4),
              )),
          centerTitle: false,
          titleSpacing: 0,
          title: Container(
            child: Row(
              children: [
                Text(
                  "Tracking",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    color: ThemeColor.primarycolor,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Container(
                    child: PopupMenuButton(
                      onSelected: (item) {
                        setState(() {
                          print(item);
                          _areMarkersLoading = true;
                          selected = item;
                        });
                      },
                      itemBuilder: (BuildContext context) => vehicles
                          .map((e) => PopupMenuItem(
                                value: e,
                                child: Text(e["vehReg"] ?? ""),
                              ))
                          .toList(),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                  selected == null
                                      ? "Select Vehicle"
                                      : selected["vehReg"],
                                  style: TextStyle(
                                      fontSize: 16,
                                      overflow: TextOverflow.ellipsis)),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                    ),
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
                        setState(() {
                          isTracking = false;
                        });
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
              polylines: polylines.toSet(),
              mapToolbarEnabled: true,
              zoomGesturesEnabled: true,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              initialCameraPosition: _kInitialPosition,
              markers: _markers.toSet(),
              onMapCreated: (controller) => _onMapCreated(controller),
              onCameraMove: (position) => _updateMarkers(position.zoom),
              // initialCameraPosition: _kInitialPosition,
              // markers: Set<Marker>.of(_markers),
              // onMapCreated: (controller) {
              //   mapCtrl = controller;
              //   fetchVehicles();
              // },
            ),
            Opacity(
              opacity: _isMapLoading ? 1 : 0,
              child: Center(child: CircularProgressIndicator()),
            ),

            // Map markers loading indicator
            if (_areMarkersLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Card(
                    elevation: 2,
                    color: Colors.grey.withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        'Loading',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  initMap() async {
    _markers.clear();
    for (int i = 0; i < vehicles.length; i++) {
      print(vehicles[i]);
      var trackingRes =
          await ApiService.liveTracking(vehicles[i]["serviceId"].toString());
      if (trackingRes.isNotEmpty) {
        var trackingInfo = trackingRes[0];
        print(trackingInfo);
        BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/images/red_car.png");
        _markers.add(Marker(
          markerId: MarkerId(trackingInfo["vehicle_name"]),
          icon: markerIcon,
          position: LatLng(double.parse(trackingInfo["lat"]),
              double.parse(trackingInfo["lng"])),
        ));

        if (i == 0) {
          mapCtrl.animateCamera(CameraUpdate.newLatLngZoom(
              LatLng(double.parse(trackingInfo["lat"]),
                  double.parse(trackingInfo["lng"])),
              14));
        }
      }
    }
  }
}
