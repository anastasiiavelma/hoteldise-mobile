import 'package:flutter/material.dart';
import '/../../themes/constants.dart';
import '/../models/hotel.dart';

import 'package:hoteldise/services/auth.dart';
import 'package:provider/provider.dart';

class HotelPage extends StatefulWidget {
  const HotelPage(
      {Key? key,
        this.onApplyClick,
        this.onCancelClick,
        this.barrierDismissible = true,
        this.hotel // required this.hotel
      }  ) : super(key: key);

  final Hotel? hotel;
  final bool barrierDismissible;
  final Function(DateTime, DateTime)? onApplyClick;
  final Function()? onCancelClick;

  @override
  State<HotelPage> createState() => HotelPageState();
}

class HotelPageState extends State<HotelPage> with TickerProviderStateMixin{
  AnimationController? animationController;

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
    const String imagePath = "assets/images/hotel_template.jpg";

    String hotelName = "Hotel Name Name Name Name Name Name Name";
    String hotelMark = "5.0";
    int reviewCount = 21;
    String hotelAddress = "Stege, Denmark";
    int matchedPlaces = 3;

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.white,
              backgroundColor: backgroundColor,
              elevation: 0,
              title: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Hotel Detail", textAlign: TextAlign.center,
                  )
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {},
              ),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite, color: Colors.redAccent,)
                )
              ],
            ),
            backgroundColor: backgroundColor, // backgroundColor
            body: Center(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Colors.grey), // Colors.grey
                      child: Image.asset(imagePath),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(color: backgroundColor), // Colors.grey
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 60,
                            //decoration: const BoxDecoration(color: backgroundColor),
                            child:
                               Text(
                                  hotelName,
                                style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w500,
                                    color: textBase
                                ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                            width: double.infinity
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 20,
                                color: primaryColor,
                              ),
                              Text(
                                hotelMark,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: textBase
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                                height: 20,
                                child: Text(
                                  " · ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: textBase
                                  ),
                                ),
                                //decoration: const BoxDecoration(color: Colors.red),
                              ),
                              Text(
                                (reviewCount == 1)? "$reviewCount review" : "$reviewCount reviews",
                                style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: textBase
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                                height: 20,
                                child: Text(
                                  " · ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: textBase
                                  ),
                                ),
                                //decoration: const BoxDecoration(color: Colors.red),
                              ),
                              Text(
                                  hotelAddress,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: textBase
                                  ),
                              ),
                            ]
                          ),
                          const SizedBox(
                            width: double.infinity,
                            height: 10
                          ),
                          const Divider(
                            thickness: 2, // thickness of the line
                            indent: 5, // empty space to the leading edge of divider.
                            endIndent: 0, // empty space to the trailing edge of the divider.
                            color: textBase, // The color to use when painting the line.
                            height: 10, // The divider's height extent.
                          ),
                          const SizedBox(
                              width: double.infinity,
                              height: 5
                          ),
                          Column(
                            children: const [
                               Align(
                                 alignment: Alignment.centerLeft,
                                 child: Text(
                                  "Places:",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      color: textBase
                                   )
                                  ),
                               ),
                              // Flexible(
                              //     child: ListView.separated(
                              //       scrollDirection: Axis.horizontal,
                              //       itemCount: matchedPlaces + 1,
                              //         itemBuilder: (context, index) {
                              //           if (index == matchedHotels.length) {
                              //             return const SizedBox(height: 0);
                              //           }
                              //           else {
                              //             return HotelCard(
                              //               hotel: matchedHotels[index],
                              //               Auth: Auth,
                              //             );
                              //           }
                              //         },
                              //         separatorBuilder: (BuildContext context, int index) {
                              //           return const SizedBox(height: 20);
                              //         }
                              //     )
                              // )
                            ],
                          ),
                          const ColorBox(),
                          const Divider(
                            thickness: 2, // thickness of the line
                            indent: 5, // empty space to the leading edge of divider.
                            endIndent: 0, // empty space to the trailing edge of the divider.
                            color: textBase, // The color to use when painting the line.
                            height: 10, // The divider's height extent.
                          ),
                        ],
                      ),
                    )
                  ],
                )
            )
        )
    );
  }
}

class ColorBox extends StatelessWidget{
  const ColorBox({super.key});

  @override
  Widget build(BuildContext context){
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.red,
          border: Border.all()
      ),
    );
  }
}