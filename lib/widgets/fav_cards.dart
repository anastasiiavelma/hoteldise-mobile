import 'package:flutter/material.dart';
import 'package:hoteldise/models/hotel.dart';
import 'package:hoteldise/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoteldise/services/firestore.dart';
import 'package:hoteldise/widgets/hotel_card.dart';
import 'package:hoteldise/widgets/loader.dart';

class FavCards extends StatefulWidget {
  final AuthBase Auth;
  const FavCards({
    Key? key,
    required this.Auth,
  }) : super(key: key);

  @override
  State<FavCards> createState() => _FavCardsState();
}

class _FavCardsState extends State<FavCards> {
  List<Hotel> _favourites = [];
  List ids = [];
  bool loaded = false;

  @override
  void initState() {
    getHotels();
    super.initState();
  }

  getHotels() async {
    await Firestore()
        .getUserFavourites(widget.Auth.currentUser!.uid)
        .then((value) {
      ids = value;
    });
    if (ids.isNotEmpty) {
      List<Hotel> newHotels = <Hotel>[];
      FirebaseFirestore db = FirebaseFirestore.instance;
      await db
          .collection("hotels")
          .where(FieldPath.documentId, whereIn: ids)
          .withConverter(
              fromFirestore: Hotel.fromFirestore,
              toFirestore: (Hotel hotel, _) => hotel.toFirestore())
          .get()
          .then((event) async {
        for (var doc in event.docs) {
          newHotels.add(doc.data());
          newHotels.last.hotelId = doc.reference.id;
        }
        for (int i = 0; i < newHotels.length; i++) {
          await newHotels[i].setExtraFields();
        }
        _favourites = newHotels;
      });
      setState(() {
        loaded = true;
      });
    }
    setState(() {
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("widget is finished");
    if (loaded == false) {
      return Loader();
    } else {
      if (_favourites.isEmpty) {
        return Center(
            child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 70),
              child: Text(
                "Do not any favourites",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/images/empty.png',
                width: 300,
                fit: BoxFit.cover,
              ),
            )
          ],
        ));
      }
      return Center(
          child: Column(
        children: [
          const SizedBox(
            height: 70.0,
          ),
          const Text(
            "Favourites",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Flexible(
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: _favourites.length + 1,
              itemBuilder: (context, index) {
                if (index == _favourites.length) {
                  return const SizedBox(height: 0);
                } else {
                  return HotelCard(
                    hotel: _favourites[index],
                    Auth: widget.Auth,
                  );
                }
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 20);
              },
            ),
          ),
        ],
      ));
    }
  }
}
