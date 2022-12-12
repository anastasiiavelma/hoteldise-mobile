import 'package:flutter/material.dart';
import 'package:hoteldise/themes/room_facilities/room_facilities.dart';
import 'package:hoteldise/widgets/hotel_comment.dart';
import 'package:hoteldise/widgets/room_card.dart';
import 'package:hoteldise/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../../models/room_type.dart';
import '../../../services/auth.dart';
import '../../../services/firestore.dart';
import '../../../widgets/star_icon_button.dart';
import '/../../themes/constants.dart';
import '/../models/hotel.dart';

class RoomPage extends StatefulWidget {
  const RoomPage(
      {Key? key,
      required this.room // required this.hotel
      })
      : super(key: key);

  final RoomType room;

  @override
  State<RoomPage> createState() => RoomPageState();
}

class RoomPageState extends State<RoomPage> with TickerProviderStateMixin {
  SizedBox sectionSeparator = const SizedBox(height: 20);
  SizedBox sectionContentSeparator = const SizedBox(height: 4);
  int currentImageInd = 0;
  List<RoomFacility> roomFacilities = [
    AirConditioningRoomFacility(),
    FreeWIFIRoomFacility(),
    JacuzziRoomFacility(),
    MinibarRoomFacility(),
    SeaViewRoomFacility(),
    CityViewRoomFacility(),
    KitchenRoomFacility(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Stack(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            foregroundDecoration: const BoxDecoration(color: Colors.black26),
            child: Image.network(
              widget.room.photosUrls[currentImageInd],
              fit: BoxFit.cover,
            )),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 250,
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                color: backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      children: const [
                        Text(
                          "\$ 200 ",
                          style: TextStyle(
                            color: textBase,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          "/per night",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryColor),
                        child: const Text(
                          "Book Now",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Text(
                    //   "Description".toUpperCase(),
                    //   style: const TextStyle(
                    //     fontWeight: FontWeight.w600,
                    //     fontSize: 14.0,
                    //   ),
                    // ),
                    // sectionContentSeparator,
                    // ReadMoreText(
                    //   widget.hotel.description,
                    //   trimLines: 3,
                    //   trimCollapsedText: 'Show More',
                    //   trimExpandedText: 'Show Less',
                    //   trimMode: TrimMode.Line,
                    //   style: const TextStyle(fontSize: 14, color: textBase),
                    //   lessStyle:
                    //       const TextStyle(fontSize: 14, color: secondaryColor),
                    //   moreStyle:
                    //       const TextStyle(fontSize: 14, color: secondaryColor),
                    // ),
                    // sectionSeparator,
                    // Text(
                    //   "Rooms".toUpperCase(),
                    //   style: const TextStyle(
                    //     fontWeight: FontWeight.w600,
                    //     fontSize: 14.0,
                    //   ),
                    // ),
                    // sectionContentSeparator,
                    // rooms.isNotEmpty
                    //     ? SizedBox(
                    //         height: 78,
                    //         child: SingleChildScrollView(
                    //           scrollDirection: Axis.horizontal,
                    //           child: ListView.separated(
                    //               shrinkWrap: true,
                    //               itemCount: rooms.length,
                    //               scrollDirection: Axis.horizontal,
                    //               itemBuilder:
                    //                   (BuildContext context, int index) {
                    //                 return RoomCard(
                    //                     room: rooms[index]);
                    //               },
                    //               separatorBuilder: (context, index) =>
                    //                   const SizedBox(
                    //                     width: 10,
                    //                   )),
                    //         ),
                    //       )
                    //     : AppText(
                    //         text: "Looks like no empty rooms at the moment",
                    //         color: textBase,
                    //         size: 14,
                    //       ),
                    // sectionSeparator,
                    // Text(
                    //   "Rating".toUpperCase(),
                    //   style: const TextStyle(
                    //     fontWeight: FontWeight.w600,
                    //     fontSize: 14.0,
                    //   ),
                    // ),
                    // sectionContentSeparator,
                    // Row(
                    //   children: [
                    //     AppText(
                    //       text: "User score:",
                    //       color: textBase,
                    //       size: 14,
                    //     ),
                    //     const SizedBox(width: 4),
                    //     const Icon(
                    //       Icons.star_rounded,
                    //       size: 18,
                    //       color: primaryColor,
                    //     ),
                    //     AppText(
                    //         text:
                    //             "${widget.hotel.rating.mark}/5 based on ${widget.hotel.rating.count} marks",
                    //         color: Colors.white,
                    //         size: 14)
                    //   ],
                    // ),
                    // sectionContentSeparator,
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   children: [
                    //     AppText(
                    //       text: "Yours score:",
                    //       color: textBase,
                    //       size: 14,
                    //     ),
                    //     const SizedBox(width: 4),
                    //     getStarButtons()
                    //   ],
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     AppText(
                    //       text: "Reviews".toUpperCase(),
                    //       color: textBase,
                    //       size: 14,
                    //       weight: FontWeight.w600,
                    //     ),
                    //     TextButton(
                    //       onPressed: () {},
                    //       child: AppText(
                    //         text: "See All",
                    //         color: secondaryColor,
                    //         size: 14,
                    //         weight: FontWeight.w600,
                    //       ),
                    //     )
                    //   ],
                    // ),
                    // sectionContentSeparator,
                    // HotelComment(
                    //     content:
                    //         'djjjjjjjjjjjjjjjjjjjjjjjjjjjjjqnjqnwnqjddjjjjjjjjjjjjjjjjjjjjjjjjjjjjjqnjqnwnqjddjjjjjjjjjjjjjjjjjjjjjjjjjjjjjqnjqnwnqjddjjjjjjjjjjjjjjjjjjjjjjjjjjjjjqnjqnwnqjddjjjjjjjjjjjjjjjjjjjjjjjjjjjjjqnjqnwnqjddjjjjjjjjjjjjjjjjjjjjjjjjjjjjjqnjqnwnqjddjjjjjjjjjjjjjjjjjjjjjjjjjjjjjqnjqnwnqjd',
                    //     avatarUrl: null,
                    //     publishDate: DateTime.now(),
                    //     authorName: 'Petro'),
                    // const SizedBox(height: 8),
                    // OutlinedButton(
                    //   onPressed: () {},
                    //   style: ElevatedButton.styleFrom(
                    //     minimumSize: const Size.fromHeight(40),
                    //     side:
                    //         const BorderSide(width: 1.2, color: secondaryColor),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(32.0),
                    //     ),
                    //   ),
                    //   child: AppText(
                    //     text: "Write a Review",
                    //     color: secondaryColor,
                    //     size: 14,
                    //     weight: FontWeight.w600,
                    //   ),
                    // ),
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => {Navigator.pop(context)}),
          ),
        ),
      ],
    )));
  }
}
