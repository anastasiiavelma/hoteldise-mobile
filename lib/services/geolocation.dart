import 'dart:math';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Position> getUserCurrentLocation() async {
  await Geolocator.requestPermission().then((value){
  }).onError((error, stackTrace) async {
    await Geolocator.requestPermission();
    print("ERROR"+error.toString());
  });
  return await Geolocator.getCurrentPosition();
}

Future<double> getDistance(LatLng endLocation) async {
  LatLng startLocation = LatLng(0, 0);
  getUserCurrentLocation().then((value) async {
    startLocation = LatLng(value.latitude, value.longitude);
  });

  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "AIzaSyAJ229JdSZjTaOQ2AsmdS31-ih_sDd-8So";

  Set<Marker> markers = Set(); //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  double distance = 0.0;

  List<LatLng> polylineCoordinates = [];

  PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    googleAPiKey,
    PointLatLng(startLocation.latitude, startLocation.longitude),
    PointLatLng(endLocation.latitude, endLocation.longitude),
    travelMode: TravelMode.driving,
  );

  if (result.points.isNotEmpty) {
    result.points.forEach((PointLatLng point) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    });
  } else {
    print(result.errorMessage);
  }

//polulineCoordinates is the List of longitute and latidtude.
  double totalDistance = 0;
  for(var i = 0; i < polylineCoordinates.length-1; i++){
    totalDistance += calculateDistanceBetweenPoints(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i+1].latitude,
        polylineCoordinates[i+1].longitude);
  }

  return totalDistance;
}

double calculateDistanceBetweenPoints(lat1, lon1, lat2, lon2){
  var p = 0.017453292519943295;
  var a = 0.5 - cos((lat2 - lat1) * p)/2 +
      cos(lat1 * p) * cos(lat2 * p) *
          (1 - cos((lon2 - lon1) * p))/2;
  return 12742 * asin(sqrt(a));
}

//it will return distance in KM