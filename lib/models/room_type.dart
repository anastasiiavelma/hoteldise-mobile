import 'package:firebase_storage/firebase_storage.dart';
import 'package:hoteldise/models/price.dart';

class RoomType {
  RoomType(
      {required this.price,
      required this.bonusForBooking,
      required this.numOfPlaces,
      required this.facilities,
      required this.description,
      required this.photosUrls,
      required this.numOfFreeSuchRooms,
      required this.id});

  late Price price;
  late int numOfPlaces;
  late int? bonusForBooking;
  late List<String>? facilities;
  late String description;
  late List<String> photosUrls;
  late int numOfFreeSuchRooms;
  late String id;

  RoomType.fromJson(Map json) {
    price = Price.fromJson(json['price']);
    numOfPlaces = json['numOfPlaces'];
    bonusForBooking = json['bonusForBooking'];
    facilities = List.from(json['facilities']);
    description = json['description'];
    photosUrls = List.from(json['photosUrls']);
    numOfFreeSuchRooms = json['numOfFreeSuchRooms'];
    id = json['id'];
  }
}
