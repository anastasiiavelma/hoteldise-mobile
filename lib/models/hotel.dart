import 'dart:convert';

import 'package:hoteldise/models/address.dart';
import 'package:hoteldise/models/hotel_comment.dart';
import 'package:hoteldise/models/rating.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Hotel {
  Hotel(
      {required this.createdAt,
      required this.contactNumber,
      required this.siteLink,
      required this.photosUrls,
      required this.address,
      required this.rating,
      required this.adminId,
      required this.comments,
      required this.name,
      required this.description});

  final String name;
  final String description;
  final DateTime createdAt;
  final String contactNumber;
  final String siteLink;
  final String adminId;
  final List<String> photosUrls;
  final Address address;
  final Rating rating;
  final List<HotelComment> comments;

  factory Hotel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Hotel(
      name: data!['name'],
      description: data['description'],
      createdAt: (data['created_at'] as Timestamp).toDate(),
      contactNumber: data['contact_number'],
      siteLink: data['site_link'],
      adminId: data['admin_id'],
      address: Address.fromJson(data!['address']),
      rating: Rating.fromJson(data['rating']),
      photosUrls: List.from(data?['photos_urls']),
      comments: List<HotelComment>.from(data?['comments'].map((model) => HotelComment.fromJson(model))),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (description != null) "description": description,
      if (createdAt != null) "createdAt": createdAt,
      if (contactNumber != null) "contactNumber": contactNumber,
      if (siteLink != null) "siteKink": siteLink,
      if (adminId != null) "admin_id": adminId,
      if (address != null) "address": address,
      if (rating != null) "rating": rating,
      if (photosUrls != null) "photos_urls": photosUrls,
      if (comments != null) "comments": comments,
    };
  }
}
