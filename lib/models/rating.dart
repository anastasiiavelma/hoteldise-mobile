class Rating {
  Rating( {required this.mark, required this.count});
  late int mark;
  late int count;

  Rating.fromJson(Map json) {
    mark = json['mark'];
    count = json['count'];
  }
}