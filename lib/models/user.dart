class FirestoreUser {
  final String _email;
  final String _id;
  final List<dynamic> _favourites;
  final List<dynamic> _hotelsRatings;

  FirestoreUser.fromJson(json)
      : _email = json['email'],
        _id = json['_id'],
        _favourites = json['favourites'],
        _hotelsRatings = json['hotelsRatings'];

  String get email => _email;
  String get id => _id;
  List<dynamic> get favourites => _favourites;
  List<dynamic> get hotelsRatings => _hotelsRatings;
}
