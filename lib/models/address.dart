import 'package:geopoint/geopoint.dart';

class Address {
  Address({required this.address, required this.geopoint});
  final String address;
  final GeoPoint geopoint;
}