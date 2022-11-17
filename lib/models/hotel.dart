import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hoteldise/models/address.dart';
import 'package:hoteldise/models/hotel_comment.dart';
import 'package:hoteldise/models/rating.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoteldise/models/room_type.dart';

import '../services/geolocation.dart';

class Hotel {
  Hotel({
    required this.createdAt,
    required this.rooms,
    required this.averageCost,
    required this.siteLink,
    required this.photosUrls,
    required this.address,
    required this.rating,
    required this.adminId,
    required this.comments,
    required this.name,
    required this.description,
  });

  final String name;
  final Address address;
  final Rating rating;
  final String siteLink;
  final DateTime createdAt;
  final String adminId;
  final List<RoomType> rooms;
  final String description;
  final List<String> photosUrls;
  final List<HotelComment> comments;
  final int averageCost;
  double distance = 0;
  String mainImageUrl = "";
  String hotelId = "";

  factory Hotel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Hotel(
        name: data!['name'],
        description: data['description'],
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        siteLink: data['siteLink'],
        adminId: data['adminId'],
        address: Address.fromJson(data!['address']),
        rating: Rating.fromJson(data['rating']),
        photosUrls: List.from(data?['photosUrls']),
        comments: List<HotelComment>.from(
            data?['comments'].map((model) => HotelComment.fromJson(model))),
        rooms: List<RoomType>.from(
            data?['rooms'].map((model) => RoomType.fromJson(model))),
        averageCost: data['averageCost'].toInt());
  }

  //not done
  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (description != null) "description": description,
      if (createdAt != null) "createdAt": createdAt,
      if (siteLink != null) "siteKink": siteLink,
      if (adminId != null) "adminId": adminId,
      if (address != null) "address": address,
      if (rating != null) "rating": rating,
      if (photosUrls != null) "photos_urls": photosUrls,
      if (comments != null) "comments": comments,
    };
  }

  Future<void> setDistance() async {
    await getDistance(
            LatLng(address.geopoint.latitude, address.geopoint.longitude))
        .then((value) {
      distance = value;
    });
  }

  Future<void> setMainImage() async {
    mainImageUrl = await FirebaseStorage.instance
        .ref()
        .child(photosUrls[0])
        .getDownloadURL();
  }
}
