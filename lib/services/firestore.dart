import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hoteldise/models/user.dart';
import 'package:hoteldise/services/auth.dart';

class Firestore {
  final FirebaseFirestore _fStore = FirebaseFirestore.instance;

  Future<void> addUser(User user) async {
    Timestamp timestamp = Timestamp.fromDate(DateTime.now());

    final newUser = {
      "email": user.email!,
      "timeStamp": timestamp,
      "favourites": [],
    };

    _fStore.collection('users').doc(user.uid).set(newUser);
  }

  Future<FirestoreUser?> fetchUser(String id) {
    return _fStore
        .collection('users')
        .where('_id', isEqualTo: id)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isEmpty) {
        addUser(AuthService().currentUser!);
      } else {
        return FirestoreUser.fromJson(snapshot.docs[0]);
      }
    });
  }

  Future<List<dynamic>> getUserFavourites(String userId) async {
    return _fStore
        .collection('users')
        .doc(userId)
        .get()
        .then((doc) => doc['favourites']);
  }
}
