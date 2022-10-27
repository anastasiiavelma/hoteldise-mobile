import 'package:hoteldise/models/address.dart';
import 'package:hoteldise/models/hotel_comment.dart';
import 'package:hoteldise/models/rating.dart';

class Hotel {
  Hotel( {required this.createdAt, required this.contactNumber, required this.siteKink, required this.photosUrls, required this.address, required this.rating, required this.adminId, required this.comments,required this.name, required this.description});
  final String name;
  final String description;
  final String createdAt;
  final String contactNumber;
  final String siteKink;
  final String adminId;
  final List<String> photosUrls;
  final Address address;
  final Rating rating;
  final List<HotelComment> comments;
}