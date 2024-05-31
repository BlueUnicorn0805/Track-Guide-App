import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
import 'package:trackofyapp/Screens/DrawerScreen/POIScreens/PoiMapScreen.dart';
import 'package:trackofyapp/Screens/HomeScreen/HomeScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/constants.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

class AddPOIScreen extends StatefulWidget {
  const AddPOIScreen({Key? key}) : super(key: key);

  @override
  State<AddPOIScreen> createState() => _AddPOIScreenState();
}

class _AddPOIScreenState extends State<AddPOIScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String address = "";
  double sLat = 19.018255973653343, sLng = 72.84793849278007;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add POI",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: ThemeColor.primarycolor,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                var p = await PlacesAutocomplete.show(
                    types: List.empty(),
                    components: [Component(Component.country, "in")],
                    strictbounds: false,
                    context: context,
                    mode: Mode.overlay,
                    apiKey: GOOGLE_MAP_KEY);
                if (p != null) {
                  setState(() {
                    _getLatLng(p);
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey)),
                child: Stack(alignment: Alignment.centerLeft, children: [
                  Icon(Icons.search, color: Colors.green),
                  Center(
                      child: Text("Search Location",
                          style: TextStyle(fontSize: 16)))
                ]),
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(address.isEmpty ? "No Place Selected" : address,
                    style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            InkWell(
              onTap: () {
                Get.to(
                    () => PoiMapScreen(lat: sLat, lng: sLng, address: address));
              },
              child: Container(
                color: Colors.blue[900],
                width: 100,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text("MAP", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getLatLng(Prediction prediction) async {
    GoogleMapsPlaces _places =
        new GoogleMapsPlaces(apiKey: GOOGLE_MAP_KEY); //Same API_KEY as above
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(prediction.placeId!);
    sLat = detail.result.geometry!.location.lat;
    sLng = detail.result.geometry!.location.lng;
    address = prediction.description!;
    setState(() {});
  }
}
