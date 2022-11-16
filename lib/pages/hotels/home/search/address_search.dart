import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoteldise/themes/constants.dart';
import 'package:hoteldise/widgets/text_widget.dart';

import '../../../../models/hotel.dart';
import '../../../../services/place_service.dart';

class AddressSearch extends SearchDelegate<Suggestion> {
  ListView? list;

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
        close(context, Suggestion(null, query));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        future: PlaceApiProvider().fetchSuggestions(query, 'en'),
        builder: (context, snapshot) {
          if (query == '') {
            list = null;
            return Container();
          } else if (snapshot.hasData) {
            List<Suggestion> suggestionList = snapshot.data as List<Suggestion>;
            list = ListView.builder(
              itemBuilder: (context, index) {
                if (index != suggestionList.length) {
                  return ListTile(
                      onTap: () {
                        close(context, suggestionList[index]);
                      },
                      title: AppText(
                          text: suggestionList[index].description,
                          weight: FontWeight.bold,
                          color: textBase));
                } else {
                  return getBasicText(context);
                }
              },
              itemCount: suggestionList.length + 1,
            );
            return list!;
          } else {
            return const Center(child: Text('Loading...'));
          }
        });
  }

  ListTile getBasicText(BuildContext context) {
    return ListTile(
      title: AppText(text: 'Direct search: $query', color: textBase),
      onTap: () {
        close(context, Suggestion(null, query));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return list != null ? list! : Container();
  }
}
