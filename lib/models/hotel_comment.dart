import 'package:cloud_firestore/cloud_firestore.dart';

class HotelComment {
  HotelComment({required this.content, required this.userId, required this.date});
  late String content;
  late String userId;
  late DateTime date;

  HotelComment.fromJson(Map json) {
    content = json['content'];
    userId = json['userId'];
    date = (json['date'] as Timestamp).toDate();
  }
}
