import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoteldise/models/hotel.dart';

import '../../themes/colors.dart';
import '../../widgets/bottom_navigation_bar.dart';
import '../../widgets/text_widget.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({Key? key}) : super(key: key);

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  List<Hotel> hotels = <Hotel>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SizedBox(
                height: 23,
              ),
              const Text(
                'Favourites',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(
                height: 20,
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
      bottomNavigationBar: const BottomMenu(),
    );
  }

  Widget _buildIToteltem(int index) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromRGBO(220, 218, 218, 1),
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
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
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
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
                              const Icon(
                                Icons.star_rounded,
                                size: 16,
                                color: primaryColor,
                              ),
                            for (int i = 0;
                                i < 5 - hotels[index].rating.mark;
                                i++)
                              const Icon(
                                Icons.star_border_rounded,
                                size: 16,
                                color: primaryColor,
                              ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: AppText(
                                text:
                                    "based on ${hotels[index].rating.count.toString()} mark${hotels[index].rating.count > 1 ? "s" : ""}",
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
