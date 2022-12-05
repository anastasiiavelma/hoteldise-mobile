import 'package:flutter/material.dart';
import '/../../themes/constants.dart';
import '/../models/hotel.dart';
//import 'package:hoteldise/services/auth.dart';
//import 'package:provider/provider.dart';

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

    const String image = "assets/images/hotel_template.jpg";
    String hotelName = "Hotel Name";
    String hotelMark = "5.0";
    int reviewCount = 21;
    String hotelAddress = "Stege, Denmark";
    int matchedPlaces = 3;
    bool _isFavourite = true;

    return SafeArea(
        child: Scaffold(
            body: Stack(
              children: [
                Container(
                    height: 400,
                    foregroundDecoration: const BoxDecoration(
                      color: Colors.black26
                    ),
                    child: Image.asset(image,
                      fit: BoxFit.cover,
                    )
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 250,),
                       Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
                         child: Text(hotelName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                          ),
                         ),
                       ),
                      Row(
                        children: <Widget>[
                          const SizedBox(width: 16,),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: const Text("8.4 / 85 reviews", style: TextStyle(color: Colors.white, fontSize: 14),)
                          ),
                          const Spacer(),
                        ],
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
                                        children: const [
                                          Icon(Icons.star, color: primaryColor,),
                                          Icon(Icons.star, color: primaryColor,),
                                          Icon(Icons.star, color: primaryColor,),
                                          Icon(Icons.star, color: primaryColor,),
                                          Icon(Icons.star_border, color: primaryColor,),
                                        ],
                                      ),
                                      const Text.rich(
                                          TextSpan(
                                              children: [
                                                WidgetSpan(child: Icon(Icons.location_on, size: 16.0, color: Colors.grey,), ),
                                                TextSpan(text: "8 km to centerum"),
                                              ],
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0,
                                              )
                                          )
                                      )
                                    ],
                                  ),
                                ),
                                Column(
                                  children: const [
                                    Text("\$ 200 ",
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    Text("/per night",
                                      style: TextStyle(
                                        color: Colors.grey,

                                        fontSize: 12.0,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 20,),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                child: const Text("Book Now", style: TextStyle(
                                    fontWeight: FontWeight.normal
                                  ),
                                ),
                                onPressed: () {},
                              ),
                            ),
                            const SizedBox(height: 30,),
                            Text("Description".toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0,
                              ),
                            ),
                            const SizedBox(height: 10.0,),
                            const Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum quam tortor, vehicula a nunc tincidunt, faucibus consequat sapien. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque auctor ac diam mattis mattis. Donec vestibulum dictum maximus. Vestibulum a nunc varius, placerat nulla ut, pretium ante. Praesent accumsan, erat in posuere placerat, tellus mi molestie est, sit amet tincidunt velit sem eu sem. Proin laoreet vitae libero non lacinia.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0,
                              ),
                            ),
                            const SizedBox(height: 10,),
                            const Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum quam tortor, vehicula a nunc tincidunt, faucibus consequat sapien. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque auctor ac diam mattis mattis. Donec vestibulum dictum maximus. Vestibulum a nunc varius, placerat nulla ut, pretium ante. Praesent accumsan, erat in posuere placerat, tellus mi molestie est, sit amet tincidunt velit sem eu sem. Proin laoreet vitae libero non lacinia.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0,
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
                    title: const Text("Detail",
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.normal,

                      ),
                    ),
                    centerTitle: true,
                    leading: const Icon(Icons.arrow_back),
                    actions: [ _isFavourite ?
                      IconButton(
                        icon: const Icon(Icons.favorite),
                        color: Colors.pink[200],
                        onPressed: () {},
                      )
                        :
                      IconButton(
                        icon: const Icon(Icons.favorite_border),
                        color: Colors.grey[300],
                        onPressed: () {},
                      )
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
            )
        )
    );
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