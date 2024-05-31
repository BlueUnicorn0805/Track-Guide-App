import 'dart:async';
import 'dart:math';

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackofyapp/Screens/DrawerScreen/AlertSettingScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/MapHelper.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/drawer.dart';
import 'package:trackofyapp/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vector_math/vector_math.dart' as vmath;

class PlaybackScreen extends StatefulWidget {
  var serviceId;
  var vehicleName;
  PlaybackScreen({Key? key, required this.serviceId, required this.vehicleName})
      : super(key: key);

  @override
  State<PlaybackScreen> createState() => _PlaybackScreenState();
}

class _PlaybackScreenState extends State<PlaybackScreen>
    with TickerProviderStateMixin {
  static final LatLng _kMapCenter =
      LatLng(37.42796133580664, -122.085749655962);

  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 14.0, tilt: 0, bearing: 0);

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> vehicles = [];
  final List<Marker> _markers = <Marker>[];
  late GoogleMapController mapCtrl;
  double vLat = 19.018255973653343, vLng = 72.84793849278007;

  var vehicleData;

  var selected;
  late List selectedList;
  String startDate = "";
  String endDate = "";
  TextEditingController stoppageCtrl = TextEditingController();
  TextEditingController overspeedCtrl = TextEditingController();
  bool isPlay = false;

  List<Map<String, dynamic>> playbackHist = [];
  List<LatLng> points = [];
  List<List<LatLng>> redPoints = [];

  List<Polyline> polylines = [];
  int backIndex = 0;
  var curPlayHist;
  int stoppageLimit = 10;
  int overspeedLimit = 60;
  String playbackSpeed = "1x";

  var icon;

  @override
  void initState() {
    super.initState();
    stoppageCtrl.text = stoppageLimit.toString();
    overspeedCtrl.text = overspeedLimit.toString();
    startDate = DateFormat('yyyy-MM-dd ').format(DateTime.now()) + "00:00";
    endDate = DateFormat('yyyy-MM-dd ').format(DateTime.now()) + "23:59";
    // startDate = "2024-01-25 00:00";
    // endDate = "2024-01-25 23:59";
  }

  void fetchData() async {
    setState(() {
      polylines.clear();
      _markers.clear();
      isPlay = false;
      curIndex = 0;
    });
    SmartDialog.showLoading(msg: "Loading...");
    playbackHist = await ApiService.playback(
        widget.serviceId.toString(), startDate, endDate);
    print(playbackHist);
    for (int i = 0; i < playbackHist.length; i++) {
      var histItem = playbackHist[i];
      LatLng histPos = LatLng(histItem["lat"], histItem["lng"]);
      points.add(histPos);
      if (i == 0) {
        BitmapDescriptor markerIcon =
            await MapHelper.getMarkerImageFromUrl(histItem["icon_url"]);
        icon = markerIcon;
        _markers.add(Marker(
            markerId: MarkerId(widget.vehicleName),
            icon: markerIcon,
            anchor: Offset(0.5, 0.5),
            infoWindow: InfoWindow(title: widget.vehicleName),
            rotation: (histItem["angle"] as int).toDouble(),
            position: histPos));
        var zoomLevel = await mapCtrl.getZoomLevel();
        mapCtrl.animateCamera(CameraUpdate.newLatLngZoom(histPos, zoomLevel));
        curPlayHist = histItem;
      }
    }

    setOverspeedPath(overspeedLimit);
    await setStoppageMarker();

    SmartDialog.dismiss();
  }

  setOverspeedPath(overspeedLimitP) {
    List<Polyline> tempLines = [];
    for (int i = 0; i < playbackHist.length - 1; i++) {
      var histItem = playbackHist[i];
      LatLng histPos = LatLng(histItem["lat"], histItem["lng"]);
      if (histItem["speed"] >= overspeedLimitP) {
        tempLines.add(Polyline(
          polylineId: PolylineId('${tempLines.length}'),
          points: [
            histPos,
            LatLng(playbackHist[i + 1]["lat"], playbackHist[i + 1]["lng"])
          ],
          color: Colors.red,
          width: 4,
        ));
      }
    }
    tempLines.add(Polyline(
      polylineId: PolylineId('0'),
      points: points,
      color: Colors.teal,
      width: 4,
    ));
    print("=========");
    print(tempLines.length);
    print("=========");
    polylines.clear();
    polylines.addAll(tempLines);

    setState(() {});
  }

  setStoppageMarker() async {
    List<Marker> tempMarkers = [];
    for (int i = 0; i < playbackHist.length - 1; i++) {
      var histItem = playbackHist[i];
      LatLng histPos = LatLng(histItem["lat"], histItem["lng"]);
      DateTime prevDate =
          DateFormat("yyyy-MM-dd HH:mm:ss").parse(histItem["date"]);
      DateTime nextDate =
          DateFormat("yyyy-MM-dd HH:mm:ss").parse(playbackHist[i + 1]["date"]);
      var diff = nextDate.difference(prevDate);
      if (diff.inMinutes >= stoppageLimit) {
        BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(30, 30)),
            "assets/images/stop-sign.png");
        tempMarkers.add(Marker(
            markerId: MarkerId(i.toString()),
            icon: markerIcon,
            infoWindow: InfoWindow(
                snippet: "Duration: ${_printDuration(diff)}",
                title:
                    "From: ${playbackHist[i]["date"]} To: ${playbackHist[i + 1]["date"]}"),
            position: histPos));
      }
    }
    if (_markers.length > 0) {
      _markers.removeRange(1, _markers.length);
    }
    _markers.addAll(tempMarkers);
    setState(() {});
  }

  playback() async {
    isPlay = !isPlay;

    if (isPlay) {
      transition(curIndex);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: DrawerClass(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
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
          title: Text(
            "Playback",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 21,
              color: ThemeColor.primarycolor,
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black45,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text("Stoppage(mins)",
                          style: TextStyle(color: Colors.white)),
                      Container(
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          controller: stoppageCtrl,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              stoppageLimit =
                                  value.isEmpty ? 0 : int.parse(value);
                              setStoppageMarker();
                            });
                          },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Overspeed(kmph)",
                          style: TextStyle(color: Colors.white)),
                      Container(
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          controller: overspeedCtrl,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              overspeedLimit =
                                  value.isEmpty ? 0 : int.parse(value);
                              setOverspeedPath(overspeedLimit);
                            });
                          },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Color(0xffc0c0c0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () async {
                      DateTimeRange? pickedDate = await showDateRangePicker(
                        context: context,
                        initialDateRange: DateTimeRange(
                          start: DateTime.now(),
                          end: DateTime.now(),
                        ),
                        firstDate: DateTime(
                            2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101),
                        builder: (context, child) {
                          return Column(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 400.0,
                                ),
                                child: child,
                              ),
                            ],
                          );
                        },
                      );

                      if (pickedDate != null) {
                        TimeOfDay? startPickedTime = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        TimeOfDay? endPickedTime = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        print(pickedDate.start);
                        print(pickedDate.end);
                        print(startPickedTime.toString().padLeft(2, '0'));
                        setState(() {
                          startDate = DateFormat('yyyy-MM-dd')
                                  .format(pickedDate.start) +
                              " " +
                              (startPickedTime == null
                                  ? "00:00"
                                  : '${startPickedTime.hour.toString().padLeft(2, '0')}:${startPickedTime.minute.toString().padLeft(2, '0')}');
                          endDate = DateFormat('yyyy-MM-dd')
                                  .format(pickedDate.end) +
                              " " +
                              (endPickedTime == null
                                  ? "00:00"
                                  : '${endPickedTime.hour.toString().padLeft(2, '0')}:${endPickedTime.minute.toString().padLeft(2, '0')}');
                          fetchData();
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          startDate,
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                        SizedBox(width: 24),
                        Text(
                          "to",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white),
                        ),
                        SizedBox(width: 24),
                        Text(
                          endDate,
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    onSelected: (item) {
                      setState(() {
                        playbackSpeed = item;
                        if (item == "1x") {
                          numDeltas = 20;
                          delay = 100;
                        } else if (item == "2x") {
                          numDeltas = 20;
                          delay = 80;
                        } else if (item == "3x") {
                          numDeltas = 20;
                          delay = 60;
                        } else if (item == "4x") {
                          numDeltas = 20;
                          delay = 30;
                        } else if (item == "5x") {
                          numDeltas = 20;
                          delay = 10;
                        }
                      });
                    },
                    itemBuilder: (BuildContext context) =>
                        ["1x", "2x", "3x", "4x", "5x"]
                            .map((e) => PopupMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      color: Colors.white,
                      alignment: Alignment.center,
                      child:
                          Text(playbackSpeed, style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      playback();
                    },
                    child: Icon(isPlay ? Icons.pause : Icons.play_arrow,
                        color: Colors.white, size: 48),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black87,
              ),
              child: curPlayHist == null
                  ? SizedBox.shrink()
                  : Text(
                      "Date: ${curPlayHist["date"]} Speed: ${curPlayHist["speed"]} Odometer: ${double.parse(curPlayHist["odometer"].toString() == "" ? "0" : curPlayHist["odometer"].toString()).toStringAsFixed(2)} Distance: ${calculateDistance()}km Time: ${getDuration()}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Colors.white)),
            ),
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kInitialPosition,
                rotateGesturesEnabled: true,
                tiltGesturesEnabled: true,
                mapToolbarEnabled: true,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                polylines: polylines.toSet(),
                onMapCreated: (GoogleMapController controller) {
                  mapCtrl = controller;
                  fetchData();
                },
                markers: _markers.toSet(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int numDeltas = 20; //number of delta to devide total distance
  int delay = 100; //milliseconds of delay to pass each delta
  var i = 0;
  double deltaLat = 0;
  double deltaLng = 0;
  LatLng? curPosition;
  var curIndex = 0;

  transition(index) {
    var sItem = playbackHist[index];
    var tItem = playbackHist[index + 1];
    curPlayHist = sItem;
    LatLng sPos = LatLng(sItem["lat"], sItem["lng"]);
    LatLng tPos = LatLng(tItem["lat"], tItem["lng"]);
    i = 0;
    deltaLat = (tPos.latitude - sPos.latitude) / numDeltas;
    deltaLng = (tPos.longitude - sPos.longitude) / numDeltas;
    curPosition = sPos;
    moveMarker();
  }

  moveMarker() async {
    if (!isPlay) {
      return;
    }
    curPosition = LatLng(
        curPosition!.latitude + deltaLat, curPosition!.longitude + deltaLng);

    _markers[0] = Marker(
        markerId: MarkerId(widget.vehicleName),
        position: curPosition!,
        icon: icon,
        anchor: Offset(0.5, 0.5),
        infoWindow: InfoWindow(title: widget.vehicleName),
        rotation: (playbackHist[curIndex]["angle"] as int).toDouble());
    var zoomLevel = await mapCtrl.getZoomLevel();
    mapCtrl.animateCamera(CameraUpdate.newLatLngZoom(curPosition!, zoomLevel));

    setState(() {
      //refresh UI
    });

    if (i != numDeltas) {
      i++;
      Future.delayed(Duration(milliseconds: delay), () {
        moveMarker();
      });
    } else {
      curIndex++;
      if (curIndex < playbackHist.length - 1) {
        transition(curIndex);
      } else {
        print("~~~~~~~~~~~~~~~");
        print("END BACK");
        print("~~~~~~~~~~~~~~~");
        setState(() {
          isPlay = false;
          curIndex = 0;
        });
      }
    }
  }

  String calculateDistance() {
    var lat1, lon1, lat2, lon2;
    if (curIndex >= playbackHist.length) {
      return "0.00";
    }
    lat1 = playbackHist[curIndex]["lat"];
    lon1 = playbackHist[curIndex]["lng"];
    lat2 = playbackHist[curIndex + 1]["lat"];
    lon2 = playbackHist[curIndex + 1]["lng"];
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return (12742 * asin(sqrt(a))).toStringAsFixed(2);
  }

  String getDuration() {
    if (curIndex >= playbackHist.length) {
      return "";
    }
    DateTime prevDate =
        DateFormat("yyyy-MM-dd HH:mm:ss").parse(playbackHist[curIndex]["date"]);
    DateTime nextDate = DateFormat("yyyy-MM-dd HH:mm:ss")
        .parse(playbackHist[curIndex + 1]["date"]);
    var diff = nextDate.difference(prevDate);

    return _printDuration(diff);
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    String resultHour = "";
    String resultMins = "";
    String resultSecs = "";
    if (duration.inHours != 0) {
      resultHour = twoDigits(duration.inHours) + " hour";
    }
    if (twoDigitMinutes != "00") {
      resultMins = twoDigitMinutes + " min";
    }
    if (twoDigitSeconds != "00") {
      resultSecs = twoDigitSeconds + " sec";
    }
    return "$resultHour $resultMins $resultSecs";
  }
}
