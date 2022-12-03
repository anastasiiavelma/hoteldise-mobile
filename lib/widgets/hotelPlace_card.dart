import 'package:flutter/material.dart';
import 'package:hoteldise/models/room_type.dart';

class HotelPlaceCard extends StatefulWidget {
  final RoomType? roomType;

  const HotelPlaceCard({
    Key? key,
    this.roomType, // required this.roomType
  }) : super(key: key);

  @override
  State<HotelPlaceCard> createState() => _HotelPlaceCardState();
}

class _HotelPlaceCardState extends State<HotelPlaceCard> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: const BoxDecoration(color: Colors.red),
      ),
    );
  }
}