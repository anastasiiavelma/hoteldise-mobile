import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import '../themes/constants.dart';

Future<Position> getUserCurrentLocation() async {
  // await Geolocator.requestPermission().then((value){
  // }).onError((error, stackTrace) async {
  //   await Geolocator.requestPermission();
  //   print("ERROR"+error.toString());
  // });
  return await Geolocator.getCurrentPosition(
      forceAndroidLocationManager: true, desiredAccuracy: LocationAccuracy.low);
}

Future<double> getDistance(LatLng hotelLocation) async {
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      debugPrint("Geolocation permission is denied");
      return 0;
    }
  }

  // List<Placemark> newPlace = await placemarkFromCoordinates(endLocation.latitude, endLocation.longitude);

  late LatLng userLocation;
  await getUserCurrentLocation().then((value) {
    userLocation = LatLng(value.latitude, value.longitude);
  });

  List<LatLng> polylineCoordinates = [];

  PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
    googleAPiKey,
    PointLatLng(userLocation.latitude, userLocation.longitude),
    PointLatLng(hotelLocation.latitude, hotelLocation.longitude),
    travelMode: TravelMode.driving,
  );

  if (result.points.isNotEmpty) {
    for (var point in result.points) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    }
  }
  else {
    print(result.errorMessage);
  }

//polulineCoordinates is the List of longitute and latidtude.
  double totalDistance = 0;
  for (var i = 0; i < polylineCoordinates.length - 1; i++) {
    totalDistance += calculateDistanceBetweenPoints(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i + 1].latitude,
        polylineCoordinates[i + 1].longitude);
  }
  return totalDistance;
}

//it will return distance in KM
double calculateDistanceBetweenPoints(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

