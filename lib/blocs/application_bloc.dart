import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trackofyapp/Screens/DrawerScreen/POIScreens/geolocator_service.dart';

class ApplicationBloc with ChangeNotifier{

  final  geolocatorService=GeolocatorService();

  // variables
    Position ?currentLocation;

  ApplicationBloc() {
    setCurrentLocation();
  }
  setCurrentLocation() async{
    currentLocation=await geolocatorService.getCurrentLocation();
    notifyListeners();// notify UI that
  }

}