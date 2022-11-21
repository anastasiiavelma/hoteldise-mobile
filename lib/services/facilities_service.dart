import 'package:cloud_firestore/cloud_firestore.dart';

class FacilitiesService {
  final FirebaseFirestore _fStore = FirebaseFirestore.instance;

  Future<List<String>> getFacilities() async {
    return await _fStore.collection('roomsFacilities').get().then(((snapshot) =>
        (snapshot.docs.first.data()["facilities"] as List)
            .map((item) => item as String)
            .toList()));
  }
}