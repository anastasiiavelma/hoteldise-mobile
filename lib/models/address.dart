import 'package:cloud_firestore/cloud_firestore.dart';

class Address {

   late String address;
   late GeoPoint geopoint;

  Address.fromJson(Map json) {
    address = json['address'];
    geopoint = json['geopoint'];
  }
}