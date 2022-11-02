import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoteldise/models/hotel.dart';

import '../../themes/colors.dart';
import '../../widgets/bottom_navigation_bar.dart';
import '../../widgets/text_widget.dart';

class HotelsHome extends StatefulWidget {
  const HotelsHome({Key? key}) : super(key: key);

  @override
  State<HotelsHome> createState() => _HotelsHomeState();
}

List<String> sortOptions = <String>[
  'Most relevant',
  'The nearest',
  'Most rated'
];

class _HotelsHomeState extends State<HotelsHome> {
  String currentSortOption = sortOptions[0];
  List<Hotel> hotels = <Hotel>[];
  Uint8List? photo;

  getAllHotels() async {
    List<Hotel> newHotels = <Hotel>[];
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection("hotels")
        .withConverter(
            fromFirestore: Hotel.fromFirestore,
            toFirestore: (Hotel hotel, _) => hotel.toFirestore())
        .get()
        .then((event) {
      for (var doc in event.docs) {
        newHotels.add(doc.data());
      }
      setState(() {
        hotels = newHotels;
      });
    });

    final pathReference = FirebaseStorage.instance
        .ref()
        .child("hotels/1246280_16061017110043391702.jpg");
    const oneMegabyte = 1024 * 1024;
    photo = await pathReference.getData(oneMegabyte * 5);
  }

  Color GetColorOfSortListOption(String currentOption) {
    if (currentOption == 1000) return Colors.green;
    return Colors.black;
  }

  List<Material> GetSortListItems() {
    List<Material> list = [];
    for (int i = 0; i < sortOptions.length; i++) {
      String label = sortOptions[i];
      var newItem = Material(
        child: InkWell(
          child: ListTile(
            title: AppText(
                text: label,
                color:
                    label == currentSortOption ? primaryColor : Colors.black),
            onTap: () {
              setState(() {
                currentSortOption = label;
              });
              Navigator.pop(context);
            },
            contentPadding: EdgeInsets.zero,
          ),
        ),
      );
      list.add(newItem);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    getAllHotels();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              TextField(
                autocorrect: false,
                enableSuggestions: false,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                cursorColor: Colors.black87,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  filled: true,
                  fillColor: Colors.grey[200],
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.white, width: 0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.white, width: 0),
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  hintText: "Search for hotels",
                  hintStyle:
                      const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      showModalBottomSheet<dynamic>(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext buildContext) {
                            return Wrap(children: <Widget>[
                              Container(
                                color: const Color(0xFF737373),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 30, top: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: AppText(
                                            text: 'Sort by',
                                            weight: FontWeight.w900,
                                            size: 20,
                                          ),
                                        ),
                                        Column(children: GetSortListItems()),
                                        Center(
                                          child: ListTile(
                                            title: Center(
                                                child: AppText(
                                              text: 'CANCEL',
                                              weight: FontWeight.w700,
                                              color: Colors.grey,
                                            )),
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ]);
                          });
                    },
                    icon: Icon(Icons.sort, color: Colors.black),
                    label: AppText(
                      text: currentSortOption,
                      size: 12,
                      weight: FontWeight.w500,
                    ),
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {},
                    icon: Icon(Icons.filter_alt_rounded, color: Colors.black),
                    label: AppText(
                      text: "Filter",
                      size: 12,
                      weight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Flexible(
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: hotels.length + 1,
                  itemBuilder: (context, index) {
                    if (index == hotels.length) {
                      return const SizedBox(height: 0);
                    } else
                      return _buildIToteltem(index);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 20);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomMenu(),
    );
  }

  Widget _buildIToteltem(int index) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 340),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromRGBO(220, 218, 218, 1),
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color(0xffDDDDDD),
              blurRadius: 6.0,
              spreadRadius: 2.0,
              offset: Offset(0.0, 0.0),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16), topLeft: Radius.circular(16)),
              child: Image.asset(
                height: 180,
                width: double.infinity,
                fit: BoxFit.fitWidth,
                "assets/images/hotel_template.jpg",
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: hotels[index].name,
                          size: 16,
                          weight: FontWeight.w700,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                hotels[index].address.address,
                                softWrap: false,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: primaryColor,
                            ),
                            AppText(
                                text: "2 km to city",
                                size: 12,
                                color: Colors.grey),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            for (int i = 0; i < hotels[index].rating.mark; i++)
                              Icon(
                                Icons.star_rounded,
                                size: 16,
                                color: primaryColor,
                              ),
                            for (int i = 0;
                                i < 5 - hotels[index].rating.mark;
                                i++)
                              Icon(
                                Icons.star_border_rounded,
                                size: 16,
                                color: primaryColor,
                              ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: AppText(
                                text:
                                    "based on ${hotels[index].rating.count.toString()} mark" +
                                        (hotels[index].rating.count > 1
                                            ? "s"
                                            : ""),
                                size: 12,
                                color: Colors.grey,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      AppText(
                        text: "190\$",
                        size: 16,
                        weight: FontWeight.w700,
                      ),
                      const SizedBox(height: 4),
                      AppText(
                          text: "/per night", size: 12, color: Colors.black),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
