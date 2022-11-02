import 'dart:ffi';

class Price {
  Price({required this.currency, required this.price});
  late int price;
  late String currency;

  Price.fromJson(Map json) {
    price = json['price'];
    currency = json['currency'];
  }
}