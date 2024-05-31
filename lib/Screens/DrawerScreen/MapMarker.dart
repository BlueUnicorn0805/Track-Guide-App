import 'package:fluster/fluster.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// [Fluster] can only handle markers that conform to the [Clusterable] abstract class.
///
/// You can customize this class by adding more parameters that might be needed for
/// your use case. For instance, you can pass an onTap callback or add an
/// [InfoWindow] to your marker here, then you can use the [toMarker] method to convert
/// this to a proper [Marker] that the [GoogleMap] can read.
class MapMarker extends Clusterable {
  final String id;
  final LatLng position;
  double rotation;
  BitmapDescriptor? icon;
  void Function()? onClick;
  InfoWindow? info;

  MapMarker({
    required this.id,
    required this.position,
    required this.rotation,
    this.onClick,
    this.icon,
    this.info,
    isCluster = false,
    clusterId,
    pointsSize,
    childMarkerId,
  }) : super(
            markerId: id,
            latitude: position.latitude,
            longitude: position.longitude,
            isCluster: isCluster,
            clusterId: clusterId,
            pointsSize: pointsSize,
            childMarkerId: childMarkerId);

  Marker toMarker() => Marker(
      markerId: MarkerId(isCluster! ? 'cl_$id' : id),
      position: LatLng(
        position.latitude,
        position.longitude,
      ),
      infoWindow: info == null ? InfoWindow(title: "") : info!,
      rotation: rotation,
      icon: icon!,
      onTap: onClick);
}
