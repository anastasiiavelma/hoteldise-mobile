class FirestoreUser {
  final String _email;
  final String _id;
  final List<dynamic> _favourites;

  FirestoreUser.fromJson(json)
      : _email = json['email'],
        _id = json['_id'],
        _favourites = json['favourites'];

  String get email => _email;
  String get id => _id;
  List<dynamic> get favourites => _favourites;
}
