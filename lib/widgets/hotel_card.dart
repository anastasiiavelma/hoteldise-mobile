import 'package:flutter/material.dart';
import 'package:hoteldise/models/hotel.dart';
import 'package:hoteldise/pages/hotels/home/filter.dart';
import 'package:hoteldise/services/auth.dart';
import 'package:hoteldise/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoteldise/themes/constants.dart';
import 'package:hoteldise/utils/toast.dart';
import '../../../widgets/text_widget.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../pages/hotels/hotel_page/hotelPage.dart';

class HotelCard extends StatefulWidget {
  final AuthBase Auth;
  final Hotel hotel;

  const HotelCard({
    Key? key,
    required this.hotel,
    required this.Auth,
  }) : super(key: key);

  @override
  State<HotelCard> createState() => _HotelCardState();
}

class _HotelCardState extends State<HotelCard> {
  List _favourites = [];
  bool _isHeartLoading = true;
  //Hotel hotel = widget.hotel;

  @override
  void initState() {
    super.initState();

    Firestore().fetchUser(widget.Auth.currentUser!.uid).then((user) {
      setState(() {
        _favourites = user!.favourites;
        _isHeartLoading = false;
      });
    }).catchError((e) {
      setState(() {
        _isHeartLoading = false;
      });
    });
  }

  void _toggleFavourite() async {
    try {
      if (widget.hotel.isFavourite!) {
        setState(() {
          widget.hotel.isFavourite = false;
        });
        await Firestore().deletePlaceFromFavourites(
            widget.Auth.currentUser!.uid, widget.hotel.hotelId);
      } else {
        setState(() {
          widget.hotel.isFavourite = true;
        });
        await Firestore().addPlaceToFavourites(
            widget.Auth.currentUser!.uid, widget.hotel.hotelId);
      }
    } on FirebaseException catch (e) {
      CustomToast();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          Navigator.push<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
                builder: (BuildContext context) =>
                    HotelPage(hotel: widget.hotel),
                fullscreenDialog: true),
          );
        // FocusScope.of(context).requestFocus(FocusNode());
        // openHotelPage(widget.hotel);
        },
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 340),
          decoration: BoxDecoration(
            color: elevatedGrey,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topRight,
                height: 200.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.hotel.mainImageUrl))),
                child: IconButton(
                    onPressed: () => setState(() {
                          _isHeartLoading ? null : _toggleFavourite();
                        }),
                    iconSize: 40,
                    icon: widget.hotel.isFavourite!
                        ? Icon(
                            EvaIcons.heart,
                            color: Colors.pink[200],
                          )
                        : Icon(
                            EvaIcons.heartOutline,
                            color: Colors.grey[300],
                          )),
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
                            text: widget.hotel.name,
                            size: 16,
                            weight: FontWeight.w700,
                            overflow: TextOverflow.ellipsis,
                            color: textBase,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  widget.hotel.address.address,
                                  softWrap: false,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: lightGreyColor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              // const SizedBox(width: 4),
                              // const Icon(
                              //   Icons.location_on,
                              //   size: 14,
                              //   color: primaryColor,
                              // ),
                              // AppText(
                              //     text: hotel.distance != 0
                              //         ? "${hotel.distance.toInt()} km to hotel"
                              //         : "hotel too far",
                              //     size: 12,
                              //     color: lightGreyColor),
                              const SizedBox(width: 50),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              for (int i = 0; i < widget.hotel.rating.mark; i++)
                                const Icon(
                                  Icons.star_rounded,
                                  size: 16,
                                  color: primaryColor,
                                ),
                              for (int i = 0;
                                  i < 5 - widget.hotel.rating.mark;
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
                                      "based on ${widget.hotel.rating.count.toString()} mark${widget.hotel.rating.count > 1 ? "s" : ""}",
                                  size: 12,
                                  color: lightGreyColor,
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
                          text: "${widget.hotel.averageCost}\$",
                          size: 16,
                          weight: FontWeight.w700,
                          color: textBase,
                        ),
                        const SizedBox(height: 4),
                        AppText(text: "/avg per night", size: 12, color: textBase),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  Future<void> openHotelPage(Hotel hotel) async {
      MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => HotelPage(hotel: hotel)
      );
  }
  Future<void> openSomePage() async {
    MaterialPageRoute<dynamic>(
      builder: (BuildContext context) => FiltersScreen(costRange: new RangeValues(0, 1000), facilities: ["null"],)
    );
  }

}
