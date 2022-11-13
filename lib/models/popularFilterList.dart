import 'package:cloud_firestore/cloud_firestore.dart';

class PopularFilterListData {
  PopularFilterListData({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;

  //static List<PopularFilterListData> popularFList = getPopularFiltersList();

  static List<PopularFilterListData> popularFList = <PopularFilterListData>[
    PopularFilterListData(
      titleTxt: 'Free Breakfast',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Free Parking',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Pool',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Pet Friendly',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Free wifi',
      isSelected: false,
    ),
  ];


  static List<PopularFilterListData> accomodationList = [
    PopularFilterListData(
      titleTxt: 'All',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Apartment',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Home',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Villa',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Hotel',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Resort',
      isSelected: false,
    ),
  ];

  Future<List<PopularFilterListData>> getPopularFiltersList() async
  {
    List<PopularFilterListData> popularFListData = [];
    FirebaseFirestore db = FirebaseFirestore.instance;

    final docRef = db.collection("roomsFacilities").doc("ZLXmtXEKMpptUJO8Crkp");
    docRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );

    /*await db
        .collection("roomsFacilities")
        .withConverter(
        fromFirestore: Hotel.fromFirestore,
        toFirestore: (Hotel hotel, _) => hotel.toFirestore())
        .get()
        .then((event) async {
      for (var doc in event.docs) {
        newHotels.add(doc.data());
      }

      for (int i = 0; i < newHotels.length; i++) {
        await newHotels[i].setDistance();
        await newHotels[i].setMainImage();
      }

      setState(() {
        hotels = newHotels;
        sortByAverageCost(SortType.desc);
      });
    });*/

    return popularFListData;
  }
}
