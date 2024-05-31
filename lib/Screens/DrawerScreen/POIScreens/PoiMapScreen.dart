import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Screens/HomeScreen/HomeScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/drawer.dart';
import 'package:trackofyapp/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PoiMapScreen extends StatefulWidget {
  double lat, lng;
  String address;

  PoiMapScreen({
    Key? key,
    required this.lat,
    required this.lng,
    required this.address,
  }) : super(key: key);

  @override
  State<PoiMapScreen> createState() => _PoiMapScreenState();
}

class _PoiMapScreenState extends State<PoiMapScreen> {
  static late CameraPosition _kInitialPosition;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Marker> _markers = <Marker>[];
  late GoogleMapController mapCtrl;
  List<Map<String, dynamic>> poiLocations = [];
  TextEditingController nameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _kInitialPosition = CameraPosition(
        target: LatLng(widget.lat, widget.lng),
        zoom: 14.0,
        tilt: 0,
        bearing: 0);

    fetchPoiLocations();
  }

  void fetchPoiLocations() async {
    SmartDialog.showLoading(msg: "Loading...");
    poiLocations = await ApiService.getPoiLocation();
    SmartDialog.dismiss();
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
                  "Add POI",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
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
              onMapCreated: (controller) {
                mapCtrl = controller;
              },
              onTap: (latlng) {
                onAddMarker(latlng);
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: TextFormField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      isDense: true,
                      label: Text(
                        "Poi Name",
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  color: Colors.black.withOpacity(0.6),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          onSavePoiLocation();
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
              ],
            ),
            if (poiLocations.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 200,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: poiLocations.length,
                        itemBuilder: (context, index) {
                          var poiData = poiLocations[index];
                          return Container(
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                )
                              ],
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  poiData["name"],
                                  style: TextStyle(
                                      color: ThemeColor.primarycolor,
                                      fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  color: Colors.grey,
                                  padding: EdgeInsets.all(1),
                                  child: Column(
                                    children: [
                                      IntrinsicHeight(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.white,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Country"),
                                                    Text(poiData["geo_country"],
                                                        style: TextStyle(
                                                            fontSize: 12))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 1),
                                            Expanded(
                                              child: Container(
                                                color: Colors.white,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Street"),
                                                    Text(poiData["geo_street"],
                                                        style: TextStyle(
                                                            fontSize: 12))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 1),
                                            Expanded(
                                              child: Container(
                                                color: Colors.white,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Town"),
                                                    Text(poiData["geo_town"],
                                                        style: TextStyle(
                                                            fontSize: 12))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 1),
                                      IntrinsicHeight(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.white,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Latitude"),
                                                    Text(
                                                        poiData["gps_latitude"]
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 12))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 1),
                                            Expanded(
                                              child: Container(
                                                color: Colors.white,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Longitude"),
                                                    Text(
                                                        poiData["gps_longitude"]
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 12))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 1),
                                            Expanded(
                                              child: Container(
                                                color: Colors.white,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("POI Radius"),
                                                    Text(
                                                        poiData["gps_radius"]
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 12))
                                                  ],
                                                ),
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
                          );
                        }),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  onAddMarker(latlng) {
    _markers.clear();
    _markers.add(Marker(
      markerId: MarkerId("$latlng"),
      position: latlng,
    ));
    setState(() {});
  }

  onSavePoiLocation() async {
    if(nameCtrl.text.isEmpty){
      SmartDialog.showToast("Please input POI Name");
      return ;
    }
    if(_markers.isEmpty){
      SmartDialog.showToast("Please choose position");
      return ;
    }
    SmartDialog.showLoading(msg: "Loading...");
    var res = await ApiService.savePoiLocation(nameCtrl.text, _markers[0].position.latitude.toString(), _markers[0].position.longitude.toString(), widget.address, "1000");
    SmartDialog.dismiss();
    if(res){
      SmartDialog.showToast("POI is saved");
    }else{
      SmartDialog.showToast("Something went wrong");
    }
  }
}
