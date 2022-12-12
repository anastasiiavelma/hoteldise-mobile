import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hoteldise/pages/hotels/home/home.dart';
import 'package:hoteldise/utils/toast.dart';
import 'package:hoteldise/widgets/comments.dart';
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

class HotelPage extends StatefulWidget {
  const HotelPage({
    Key? key,
    this.onApplyClick,
    this.onCancelClick,
    this.barrierDismissible = true,
    required this.hotel, // required this.hotel
    required this.context,
  }) : super(key: key);

  final Hotel hotel;
  final bool barrierDismissible;
  final Function(DateTime, DateTime)? onApplyClick;
  final Function()? onCancelClick;
  final BuildContext context;

  @override
  State<HotelPage> createState() => HotelPageState();
}

class HotelPageState extends State<HotelPage> with TickerProviderStateMixin {
  AnimationController? animationController;
  SizedBox sectionSeparator = const SizedBox(height: 20);
  SizedBox sectionContentSeparator = const SizedBox(height: 4);

  final TextEditingController _textFieldController = TextEditingController();
  late List<RoomType> rooms;
  String commentText = '';
  List<dynamic> comments = [];

  Map<String, dynamic> _placeRating = {"count": 0, "mark": 0};
  bool _isRatingSending = false;
  int filledStars = 0;
  late AuthBase Auth;

  void _toggleFavourite(AuthBase auth) async {
    if (widget.hotel.isFavourite!) {
      setState(() {
        widget.hotel.isFavourite = false;
      });
      await Firestore().deletePlaceFromFavourites(
          auth.currentUser!.uid, widget.hotel.hotelId);
    } else {
      setState(() {
        widget.hotel.isFavourite = true;
      });
      await Firestore()
          .addPlaceToFavourites(auth.currentUser!.uid, widget.hotel.hotelId);
    }
  }

  @override
  void initState() {
    rooms = widget.hotel.rooms
        .where((room) => room.numOfFreeSuchRooms > 0)
        .toList();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    animationController?.forward();
    super.initState();
    setState(() {
      _placeRating = {
        'count': widget.hotel.rating.count,
        'mark': widget.hotel.rating.mark
      };
    });
    setState(() {
      Auth = Provider.of<AuthBase>(widget.context);
    });
    Firestore()
        .getUserRatingForPlace(Auth.currentUser!.uid, widget.hotel.hotelId)
        .then((value) => setState(() {
              filledStars = value;
            }));
    // Firestore().getPlaceComments(widget.hotel.hotelId).then((value) {
    //   setState(() {
    //     comments = value;
    //   });
    // });
  }

  void updateRating(int newRating) async {
    setState(() {
      _isRatingSending = true;
    });
    if (newRating != filledStars) {
      int oldUserRating = filledStars;
      setState(() {
        filledStars = newRating;
      });
      Map<String, dynamic> newPlaceRating = await Firestore().updatePlaceRating(
          oldUserRating: oldUserRating,
          newUserRating: newRating,
          oldMark: _placeRating['mark'],
          hotelId: widget.hotel.hotelId,
          usersCount: _placeRating['count']);
      await Firestore().updateUserPlaceRating(
          Auth.currentUser!.uid, widget.hotel.hotelId, newRating);
      setState(() {
        _placeRating = newPlaceRating;
      });
    }
    setState(() {
      _isRatingSending = false;
    });
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  Row getStarButtons() {
    List<Widget> row = [];
    for (int i = 0; i < 5; i++) {
      row.add(
        StarIconButton(
          isFilled: false,
          onPressed: () {},
          isDisabled: false,
        ),
      );
      row.add(const SizedBox(
        width: 10,
      ));
    }
    return Row(
      children: [...row],
    );
  }

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
              widget.hotel.mainImageUrl,
              fit: BoxFit.cover,
            )),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 250,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  widget.hotel.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                color: backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: primaryColor,
                                  ),
                                  Expanded(
                                      child: ReadMoreText(
                                    widget.hotel.address.address,
                                    trimLines: 3,
                                    trimCollapsedText: 'Show More',
                                    trimExpandedText: 'Show Less',
                                    trimMode: TrimMode.Line,
                                    style: const TextStyle(
                                        fontSize: 12, color: lightGreyColor),
                                    lessStyle: const TextStyle(
                                        fontSize: 12, color: secondaryColor),
                                    moreStyle: const TextStyle(
                                        fontSize: 12, color: secondaryColor),
                                  ))
                                ],
                              )
                            ],
                          ),
                        ),
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
                    Text(
                      "Description".toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                      ),
                    ),
                    sectionContentSeparator,
                    ReadMoreText(
                      widget.hotel.description,
                      trimLines: 3,
                      trimCollapsedText: 'Show More',
                      trimExpandedText: 'Show Less',
                      trimMode: TrimMode.Line,
                      style: const TextStyle(fontSize: 14, color: textBase),
                      lessStyle:
                          const TextStyle(fontSize: 14, color: secondaryColor),
                      moreStyle:
                          const TextStyle(fontSize: 14, color: secondaryColor),
                    ),
                    sectionSeparator,
                    Text(
                      "Rooms".toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                      ),
                    ),
                    sectionContentSeparator,
                    rooms.isNotEmpty
                        ? SizedBox(
                            height: 78,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: rooms.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return RoomCard(room: rooms[index]);
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                        width: 10,
                                      )),
                            ),
                          )
                        : AppText(
                            text: "Looks like no empty rooms at the moment",
                            color: textBase,
                            size: 14,
                          ),
                    sectionSeparator,
                    Text(
                      "Rating".toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                      ),
                    ),
                    sectionContentSeparator,
                    Row(
                      children: [
                        AppText(
                          text: "User score:",
                          color: textBase,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: primaryColor,
                        ),
                        AppText(
                            text:
                                "${widget.hotel.rating.mark}/5 based on ${widget.hotel.rating.count} marks",
                            color: Colors.white,
                            size: 14)
                      ],
                    ),
                    sectionContentSeparator,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppText(
                          text: "Yours score:",
                          color: textBase,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        _buildRatingStars(filledStars)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: "Reviews".toUpperCase(),
                          color: textBase,
                          size: 14,
                          weight: FontWeight.w600,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: AppText(
                            text: "See All",
                            color: secondaryColor,
                            size: 14,
                            weight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                    sectionContentSeparator,
                    // ElevatedButton(
                    //     child: Text("Add comment"),
                    //     style: ElevatedButton.styleFrom(
                    //         padding: const EdgeInsets.symmetric(
                    //             vertical: 15, horizontal: 30)),
                    //     onPressed: () => _showPopup())
                  ],
                ),
              ),
              ...comments.map((item) => Comment(
                    commentText: item['comment'],
                    imagePath: item['avatarUrl'],
                  ))
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
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HotelsHome()),
                );
              },
            ),
            actions: [
              IconButton(
                  onPressed: () => setState(() {
                        _toggleFavourite(
                            Provider.of<AuthBase>(context, listen: false));
                      }),
                  iconSize: 40,
                  icon: widget.hotel.isFavourite!
                      ? Icon(
                          Icons.favorite,
                          size: 28,
                          color: Colors.pink[200],
                        )
                      : Icon(
                          Icons.favorite_border,
                          size: 28,
                          color: Colors.grey[300],
                        )),
            ],
          ),
        ),
      ],
    )));
  }

  // Future _showPopup() async {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: const Text("Add your comment"),
  //           content: TextField(
  //             onChanged: (value) {
  //               commentText = value;
  //             },
  //             controller: _textFieldController,
  //             decoration: const InputDecoration(hintText: "Comment"),
  //           ),
  //           actions: <Widget>[
  //             ElevatedButton(
  //               child: const Text("Add"),
  //               style: ElevatedButton.styleFrom(
  //                   padding:
  //                       EdgeInsets.symmetric(vertical: 15, horizontal: 30)),
  //               onPressed: () {
  //                 if (commentText != '') {
  //                   Firestore()
  //                       .addComment(
  //                           comment: commentText,
  //                           hotel_id: widget.hotel!.hotelId,
  //                           user_email: Auth.currentUser!.email ?? '',
  //                           user_id: Auth.currentUser!.uid)
  //                       .then((value) => CustomToast(
  //                               color: Colors.green,
  //                               message: "Your comment added")
  //                           .show());
  //                 }
  //                 _textFieldController.clear();
  //                 setState(() {
  //                   commentText = '';
  //                 });
  //                 Navigator.pop(context);
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }

  Widget _buildRatingStars(int filledStars) {
    List<StarIconButton> filledStarsList = [];
    List<StarIconButton> outlinedStarsList = [];
    for (int i = 1; i <= filledStars; i++) {
      filledStarsList.add(StarIconButton(
          isFilled: true,
          isDisabled: _isRatingSending,
          onPressed: () => updateRating(i)));
    }
    for (int i = filledStars + 1; i <= 5; i++) {
      outlinedStarsList.add(StarIconButton(
          isFilled: false,
          isDisabled: _isRatingSending,
          onPressed: () => updateRating(i)));
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [...filledStarsList, ...outlinedStarsList]);
  }
}
