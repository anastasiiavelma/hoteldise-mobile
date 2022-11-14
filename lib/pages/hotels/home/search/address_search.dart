import 'package:flutter/material.dart';

import '../../../../services/place_service.dart';

class AddressSearch extends SearchDelegate<Suggestion> {

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
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var placeProvider = PlaceApiProvider();
    return FutureBuilder(
        // We will put the api call here
        future: placeProvider.fetchSuggestions(query, 'en'),
        builder: (context, snapshot) {
          if (query == '') {
            return Container();
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) => ListTile(
                // we will display the data returned from our future here
                title: Text((snapshot.data as List)[index]),
                onTap: () {
                  close(context, (snapshot.data as List)[index]);
                },
              ),
              itemCount: (snapshot.data as List).length,
            );
          }
          return Container(child: Text('ddded'),);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }
}
