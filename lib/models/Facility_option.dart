import 'package:cloud_firestore/cloud_firestore.dart';

class FacilityOption {
  FacilityOption({
    required this.title,
    this.isSelected = false,
  });

  String title;
  bool isSelected;
}
