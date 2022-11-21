class Booking {
  final DateTime start;
  final DateTime end;
  final String roomId;
  final bool isPaid;
  final String hotelId;

  Booking.fromJson(json) :
    start = json['start'],
    end = json['end'],
    roomId = json['roomId'],
    isPaid = json['isPaid'],
    hotelId = json['hotelId'];
}
