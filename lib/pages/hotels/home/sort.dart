import '../../../models/hotel.dart';

abstract class SortOption {
  final String name;

  SortOption(this.name);

  doSort(List<Hotel> hotels) {}
}

class SortByMark implements SortOption {
  @override
  String get name => 'Mark';

  @override
  List<Hotel> doSort(List<Hotel> hotels) {
    hotels.sort((a, b) => b.rating.mark.compareTo(a.rating.mark));
    return hotels;
  }
}

class SortByPriceDecrease implements SortOption {
  @override
  String get name => 'Price decrease';

  @override
  List<Hotel> doSort(List<Hotel> hotels) {
    hotels.sort((a, b) => b.averageCost.compareTo(a.averageCost));
    return hotels;
  }
}

class SortByPriceIncrease implements SortOption {
  @override
  String get name => 'Price increase';

  @override
  List<Hotel> doSort(List<Hotel> hotels) {
    hotels.sort((a, b) => a.averageCost.compareTo(b.averageCost));
    return hotels;
  }
}
