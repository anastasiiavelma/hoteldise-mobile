import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoteldise/themes/constants.dart';
import 'package:hoteldise/widgets/text_widget.dart';

import '../../../../models/hotel.dart';

class AddressSearch extends SearchDelegate<String> {
  late String prevSearch;
  ListView? list;
  List<Hotel> hotels = [];

  AddressSearch(this.prevSearch) {
    getHotels();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    if (query == '') {
      return [];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        )
      ];
    }
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, prevSearch);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Builder(builder: (context) {
      if (query == '') {
        list = null;
        return Container();
      } else {
        List<String> suggestionList = hotels
            .map((e) => e.address.address)
            .where((el) => el.toLowerCase().contains(query.toLowerCase()))
            .toList();
        if (suggestionList.isNotEmpty) {
          list = ListView.builder(
            itemBuilder: (context, index) {
              if (index != suggestionList.length) {
                return ListTile(
                    onTap: () {
                      close(context, suggestionList[index]);
                    },
                    title: AppText(
                        text: suggestionList[index],
                        weight: FontWeight.bold,
                        color: textBase));
              } else {
                return getBasicText(context);
              }
            },
            itemCount: suggestionList.length + 1,
          );
          return list!;
        }
        list = null;
        return Center(child: AppText(text: 'Nothing found', color: textBase,));
      }
    });
  }

  ListTile getBasicText(BuildContext context) {
    return ListTile(
      title: AppText(text: 'Direct search: $query', color: textBase),
      onTap: () {
        close(context, query);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return list != null ? list! : Center(child: AppText(text: 'Nothing found', color: textBase,));
  }

  void getHotels() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection("hotels")
        .withConverter(
            fromFirestore: Hotel.fromFirestore,
            toFirestore: (Hotel hotel, _) => hotel.toFirestore())
        .get()
        .then((event) async {
      for (var doc in event.docs) {
        hotels.add(doc.data());
      }
    });
  }
}
