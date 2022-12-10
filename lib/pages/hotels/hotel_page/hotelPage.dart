import 'package:flutter/material.dart';
import 'package:hoteldise/widgets/hotel_comment.dart';
import 'package:hoteldise/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../../services/auth.dart';
import '../../../services/firestore.dart';
import '../../../widgets/star_icon_button.dart';
import '/../../themes/constants.dart';
import '/../models/hotel.dart';

class HotelPage extends StatefulWidget {
  const HotelPage(
      {Key? key,
      this.onApplyClick,
      this.onCancelClick,
      this.barrierDismissible = true,
      required this.hotel // required this.hotel
      })
      : super(key: key);

  final Hotel hotel;
  final bool barrierDismissible;
  final Function(DateTime, DateTime)? onApplyClick;
  final Function()? onCancelClick;

  @override
  State<HotelPage> createState() => HotelPageState();
}

class HotelPageState extends State<HotelPage> with TickerProviderStateMixin {
  AnimationController? animationController;
  SizedBox sectionSeparator = const SizedBox(height: 20);
  SizedBox sectionContentSeparator = const SizedBox(height: 4);

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
    animationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    animationController?.forward();
    super.initState();
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
                    height: 400,
                    foregroundDecoration:
                        const BoxDecoration(color: Colors.black26),
                    child: Image.network(
                      widget.hotel.mainImageUrl,
                      fit: BoxFit.cover,
                    )),
                SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                fontSize: 12,
                                                color: lightGreyColor),
                                            lessStyle: const TextStyle(
                                                fontSize: 12,
                                                color: secondaryColor),
                                            moreStyle: const TextStyle(
                                                fontSize: 12,
                                                color: secondaryColor),
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
                              style: const TextStyle(
                                  fontSize: 14, color: textBase),
                              lessStyle: const TextStyle(
                                  fontSize: 14, color: secondaryColor),
                              moreStyle: const TextStyle(
                                  fontSize: 14, color: secondaryColor),
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
                                getStarButtons()
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
                            HotelComment(content: 'djjjjjjjjjjjjjjjjjjjjjjjjjjjjjqnjqnwnqjddjjjjjjjjjjjjjjjjjjjjjjjjjjjjjqnjqnwnqjddjjjjjjjjjjjjjjjjjjjjjjjjjjjjjqnjqnwnqjddjjjjjjjjjjjjjjjjjjjjjjjjjjjjjqnjqnwnqjddjjjjjjjjjjjjjjjjjjjjjjjjjjjjjqnjqnwnqjddjjjjjjjjjjjjjjjjjjjjjjjjjjjjjqnjqnwnqjddjjjjjjjjjjjjjjjjjjjjjjjjjjjjjqnjqnwnqjd', avatarUrl: null, publishDate: DateTime.now(), authorName: 'Petro'),
                            const SizedBox(height: 8),
                            OutlinedButton(
                              onPressed: null,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(40),
                                side: const BorderSide(width: 1.2, color: secondaryColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                              child: AppText(
                                text: "Write a Review",
                                color: secondaryColor,
                                size: 14,
                                weight: FontWeight.w600,
                              ),
                            ),
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
                    actions: [
                      IconButton(
                          onPressed: () => setState(() {
                                _toggleFavourite(Provider.of<AuthBase>(context,
                                    listen: false));
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
}
