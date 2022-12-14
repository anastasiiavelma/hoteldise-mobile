// ignore_for_file: unnecessary_const

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hoteldise/models/room_type.dart';
import 'package:hoteldise/widgets/text_widget.dart';

import '../../../themes/constants.dart';

class RoomCard extends StatefulWidget {
  final RoomType room;

  const RoomCard({Key? key, required this.room}) : super(key: key);

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  List<String> photos = [];

  Future<void> setImages() async {
    for (int i = 0; i < widget.room.photosUrls.length; i++) {
      photos.add(await FirebaseStorage.instance
          .ref()
          .child(widget.room.photosUrls[i])
          .getDownloadURL());
    }
  }

  @override
  void initState() {
    setImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showPopup();
      },
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: elevatedGrey,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(width: 1, color: elevatedGrey)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.bed_outlined),
            AppText(
              text:
                  'Cost: ${widget.room.price.price} ${widget.room.price.currency}',
              color: textBase,
              size: 14,
            ),
            AppText(
              text: widget.room.description,
              color: textBase,
              size: 14,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Future _showPopup() async {
    setImages();
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: SizedBox(
                  width: 350,
                  height: 470,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      centerTitle: true,
                      title: const Text(
                        "Chosen room",
                        style: TextStyle(color: primaryColor),
                      ),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    body: ListView(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: getPhotos(),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Description: ${widget.room.description}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Number of places in room: ${widget.room.numOfPlaces}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Facilities:',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  getFacilities(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Number of such rooms: ${widget.room.numOfFreeSuchRooms}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Cost: ${widget.room.price.price} ${widget.room.price.currency}/per night',
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )));
        });
  }

  Widget getPhotos() {
    if (widget.room.photosUrls.isNotEmpty) {
      return SizedBox(
        height: 200,
        width: 330,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext ctx, int index) {
            return SizedBox(
                height: 200,
                width: 330,
                child: ListView(
                  children: <Widget>[
                    Center(
                      child: Image.network(
                        photos[index],
                        fit: BoxFit.fill,
                        height: 200,
                        width: 300,
                      ),
                    ),
                  ],
                ));
          },
          itemCount: photos.length,
        ),
      );
    } else {
      return SizedBox(
          height: 200,
          width: 330,
          child: ListView(
            children: <Widget>[
              Center(
                  child: Image.asset(
                'assets/images/no_image.jpg',
                fit: BoxFit.fill,
                height: 200,
                width: 300,
              )),
            ],
          ));
    }
  }

  getFacilities() {
    if (widget.room.facilities != null) {
      for (var i in widget.room.facilities!) {
        return Text(
          '  — $i',
          style: const TextStyle(
            fontSize: 16,
          ),
        );
      }
    } else {
      return const Text(
        '  No facilities in this room',
        style: TextStyle(
          fontSize: 16,
        ),
      );
    }
  }
}
