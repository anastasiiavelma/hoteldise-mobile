import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hoteldise/models/user.dart';
import 'package:hoteldise/services/auth.dart';

class Firestore {
  final FirebaseFirestore _fStore = FirebaseFirestore.instance;

  Future<void> addUser(User user) async {
    Timestamp timestamp = Timestamp.fromDate(DateTime.now());

    final newUser = {
      "_id": user.uid,
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

  Future addPlaceToFavourites(String userId, String placeId) async {
    List<dynamic> newFavourites = await getUserFavourites(userId);
    newFavourites.add(placeId);
    return _fStore
        .collection('users')
        .doc(userId)
        .update({'favourites': newFavourites});
  }

  Future deletePlaceFromFavourites(String userId, String placeId) async {
    List<dynamic> currentFavourites = await getUserFavourites(userId);
    List<dynamic> newFavourites =
        currentFavourites.where((item) => item != placeId).toList();

    return _fStore
        .collection('users')
        .doc(userId)
        .update({'favourites': newFavourites});
  }

  Future<List<dynamic>> getUsersBookedRooms() async {
    List<dynamic> bookedRooms = [];
    await _fStore.collection('users').get().then((snapshot) {
      for (var user in snapshot.docs) {
        bookedRooms.add(user["bookedRooms"]);
      }
    });
    return bookedRooms;
  }

  Future<int> getUserRatingForPlace(String userId, String hotelId) async {
    try {
      FirestoreUser? user = await fetchUser(userId);
      if (user == null) return 0;
      int indexOfObject =
          user.hotelsRatings.indexWhere((item) => item['hotelId'] == hotelId);
      if (indexOfObject == -1) {
        return 0;
      } else {
        return user.hotelsRatings[indexOfObject]['rating'].toInt();
      }
    } on FirebaseException catch (e) {
      return 0;
    }
  }

  Future<bool> updateUserPlaceRating(
      String userId, String hotelId, int newRating) async {
    try {
      FirestoreUser? fUser = await fetchUser(userId);
      if (fUser == null) return false;
      int indexOfPlace =
          fUser.hotelsRatings.indexWhere((item) => item['hotelId'] == hotelId);
      if (indexOfPlace == -1) {
        await _fStore.collection('users').doc(userId).update({
          'hotelsRatings': [
            ...fUser.hotelsRatings,
            {'hotelId': hotelId, 'rating': newRating}
          ]
        });
      } else {
        List newRatings = [...fUser.hotelsRatings];
        newRatings[indexOfPlace] = {
          ...newRatings[indexOfPlace],
          'rating': newRating
        };
        await _fStore
            .collection('users')
            .doc(userId)
            .update({'hotelsRatings': newRatings});
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> updatePlaceRating(
      {required String hotelId,
      required int newUserRating,
      required int oldUserRating,
      required double oldMark,
      required int usersCount}) async {
    int newUsersCount = oldUserRating == 0 ? usersCount + 1 : usersCount;
    print('((oldMark * usersCount - oldUserRating + newUserRating))' +
        (oldMark * usersCount - oldUserRating + newUserRating).toString());
    print('newUsersCount' + newUsersCount.toString());
    Map<String, dynamic> newRating = {
      'mark': oldUserRating == 0
          ? (oldMark * usersCount + newUserRating) / newUsersCount
          : (oldMark * usersCount - oldUserRating + newUserRating) /
              newUsersCount,
      'users': newUsersCount
    };
    await _fStore
        .collection('hotels')
        .doc(hotelId)
        .update({'rating': newRating});
    return newRating;
  }

  Future<void> addComment(
      {required String comment,
      required String user_id,
      required String user_email,
      required String hotel_id}) async {
    _fStore.collection('comments').doc().set({
      'user_id': user_id,
      'hotel_id': hotel_id,
      'comment': comment,
      'user_email': user_email,
      'timeStamp': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<List<dynamic>> getPlaceComments(String hotel_id) async {
    return await _fStore
        .collection('comments')
        .where('hotel_id', isEqualTo: hotel_id)
        .orderBy('timeStamp', descending: true)
        .get()
        .then((snapshot) => snapshot.docs.map((doc) {
              return {
                'comment': doc['comment'],
                'avatarUrl': 'assets/images/user_placeholder.jpg'
              };
            }).toList());
  }
}
