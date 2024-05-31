import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:trackofyapp/Screens/DrawerScreen/MapHelper.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/drawer.dart';
import 'package:trackofyapp/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NotificationDetailScreen extends StatefulWidget {
  double lat, lng;
  String setOn;

  NotificationDetailScreen(
      {Key? key, required this.lat, required this.lng, required this.setOn})
      : super(key: key);

  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  static late CameraPosition _kInitialPosition;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Marker> _markers = <Marker>[];
  late GoogleMapController mapCtrl;
  String address = "";

  @override
  void initState() {
    super.initState();
    _kInitialPosition = CameraPosition(
        target: LatLng(widget.lat, widget.lng), zoom: 7, tilt: 0, bearing: 0);
  }

  fetchPoiLocations() async {
    SmartDialog.showLoading(msg: "Loading...");
    address = await ApiService.getAddress(widget.lat, widget.lng);
    SmartDialog.dismiss();
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "$address",
                  maxLines: 3,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: ThemeColor.primarycolor,
                  ),
                ),
                Text(
                  "Sent On: ${widget.setOn}",
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
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _kInitialPosition,
              markers: Set<Marker>.of(_markers),
              onMapCreated: (controller) async {
                mapCtrl = controller;
                await fetchPoiLocations();
                await onAddMarker(LatLng(widget.lat, widget.lng));
              },
              mapType: MapType.normal,
            ),
          ],
        ),
      ),
    );
  }

  onAddMarker(latlng) async {
    _markers.clear();
    BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/images/red_car.png");
    var marker = Marker(
      markerId: MarkerId("marker1"),
      position: latlng,
      icon: markerIcon,
      infoWindow: InfoWindow(
        title: address,
      ),
    );
    _markers.add(marker);
    setState(() {});
  }
}
