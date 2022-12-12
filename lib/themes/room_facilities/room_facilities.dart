import 'package:flutter/material.dart';

List<RoomFacility> roomFacilities = [
  AirConditioningRoomFacility(),
  FreeWIFIRoomFacility(),
  JacuzziRoomFacility(),
  MinibarRoomFacility(),
  SeaViewRoomFacility(),
  CityViewRoomFacility(),
  KitchenRoomFacility(),
];

abstract class RoomFacility {
  final String name;
  final Icon icon;

  RoomFacility(this.name, this.icon);
}

class AirConditioningRoomFacility implements RoomFacility {
  @override
  String get name => 'Air conditioning';

  @override
  Icon get icon => const Icon(Icons.air_outlined);
}

class FreeWIFIRoomFacility implements RoomFacility {
  @override
  String get name => 'Free WI-FI';

  @override
  Icon get icon => const Icon(Icons.wifi);
}

class JacuzziRoomFacility implements RoomFacility {
  @override
  String get name => 'Jacuzzi';

  @override
  Icon get icon => const Icon(Icons.bathroom);
}

class MinibarRoomFacility implements RoomFacility {
  @override
  String get name => 'Mini-bar';

  @override
  Icon get icon => const Icon(Icons.kitchen);
}

class SeaViewRoomFacility implements RoomFacility {
  @override
  String get name => 'Sea view';

  @override
  Icon get icon => const Icon(Icons.sensor_window_outlined);
}

class CityViewRoomFacility implements RoomFacility {
  @override
  String get name => 'City view';

  @override
  Icon get icon => const Icon(Icons.location_city);
}

class KitchenRoomFacility implements RoomFacility {
  @override
  String get name => 'Kitchen';

  @override
  Icon get icon => const Icon(Icons.kitchen);
}