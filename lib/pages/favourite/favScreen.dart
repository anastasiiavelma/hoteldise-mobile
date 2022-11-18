import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoteldise/models/hotel.dart';
import 'package:hoteldise/services/auth.dart';
import 'package:hoteldise/services/firestore.dart';
import 'package:hoteldise/widgets/hotel_card.dart';
import 'package:hoteldise/widgets/loader.dart';
import '../../themes/constants.dart';
import 'package:provider/provider.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({Key? key}) : super(key: key);

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  List<Hotel> _favourites = [];
  bool _isLoading = true;

  getHotels(List<dynamic> ids) async {
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
  }

  Widget build(BuildContext context) {
    AuthBase Auth = Provider.of<AuthBase>(context);
    Firestore().getUserFavourites(Auth.currentUser!.uid).then((value) {
      getHotels(value);
    }).whenComplete(() => setState(() {
          _isLoading = false;
        }));
    if (_isLoading) {
      return Loader();
    }
    return Scaffold(
        backgroundColor: backgroundColor, body: _buildBody(context, Auth));
  }

  Widget _buildBody(BuildContext context, AuthBase Auth) {
    if (_favourites == 0) {
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
                  Auth: Auth,
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
