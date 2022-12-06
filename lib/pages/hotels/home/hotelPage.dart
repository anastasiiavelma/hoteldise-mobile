import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/auth.dart';
import '../../../services/firestore.dart';
import '/../../themes/constants.dart';
import '/../models/hotel.dart';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    //AuthBase Auth = Provider.of<AuthBase>(context);

    const String image = "assets/images/hotel_template.jpg";
    String hotelName = "Hotel Name";
    String hotelMark = "5.0";
    int reviewCount = 21;
    String hotelAddress = "Stege, Denmark";
    int matchedPlaces = 3;

    return SafeArea(
        child: Scaffold(
            body: Stack(
      children: [
        Container(
            height: 400,
            foregroundDecoration: const BoxDecoration(color: Colors.black26),
            child: Image.asset(
              image,
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
                color: backgroundColor, // Colors.white
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
                                children: [
                                  for (int i = 0;
                                      i < widget.hotel.rating.mark;
                                      i++)
                                    const Icon(
                                      Icons.star_rounded,
                                      size: 18,
                                      color: primaryColor,
                                    ),
                                  for (int i = 0;
                                      i < 5 - widget.hotel.rating.mark;
                                      i++)
                                    const Icon(
                                      Icons.star_border_rounded,
                                      size: 18,
                                      color: primaryColor,
                                    ),
                                ],
                              ),
                              Text.rich(TextSpan(
                                  children: [
                                    const WidgetSpan(
                                      child: Icon(
                                        Icons.location_on,
                                        size: 16.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    TextSpan(
                                        text: widget.hotel.address.address),
                                  ],
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.0,
                                  )))
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
                      height: 30,
                    ),
                    Text(
                      "Description".toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      widget.hotel.description,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 16,
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Text(
                              "8.4 / 85 reviews",
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            )),
                        const Spacer(),
                      ],
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
        // Align(
        //   alignment: Alignment.bottomLeft,
        //   child: BottomNavigationBar(
        //     items: [
        //       BottomNavigationBarItem(icon: Icon(Icons.search)),
        //       BottomNavigationBarItem(icon: Icon(Icons.favorite_border)),
        //       BottomNavigationBarItem(icon: Icon(Icons.settings)),
        //     ],
        //   ),
        // )
      ],
    )));
  }

// void _toggleFavourite() async {
//   try {
//     if (_isFavourite) {
//       _isFavourite = false;
//       await Firestore().deletePlaceFromFavourites(
//           widget.Auth.currentUser!.uid, widget.hotel.hotelId);
//     } else {
//       _isFavourite = true;
//       await Firestore().addPlaceToFavourites(
//           widget.Auth.currentUser!.uid, widget.hotel.hotelId);
//     }
//   } on FirebaseException catch (e) {
//     CustomToast();
//   }
// }
}

class ColorBox extends StatelessWidget {
  const ColorBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(color: Colors.red, border: Border.all()),
    );
  }
}
