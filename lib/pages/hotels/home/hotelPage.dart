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
    int matchedPlaces = 3;
    String lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque elementum volutpat porta. Nulla in nisl egestas, euismod ante vel, pulvinar erat. Duis varius ut ante et vulputate. Ut non porta diam. Aliquam convallis iaculis nunc et placerat. Nunc malesuada nisi accumsan diam viverra, vitae placerat magna commodo. Duis sit amet purus at lectus convallis pharetra dignissim id nisi. Duis hendrerit justo sed enim finibus, id tincidunt odio rutrum. Aliquam erat volutpat. Nulla dictum sollicitudin ante, eu luctus tortor aliquam vel. Pellentesque iaculis augue nisl, eu ultricies neque pellentesque vitae. Nam leo sapien, porttitor nec diam in, efficitur congue mi. Nam nibh mi, rutrum nec suscipit at, tincidunt sed nulla. Phasellus nibh turpis, maximus ac volutpat sed, varius sed lorem. Praesent luctus eros ac pellentesque condimentum. Sed viverra cursus velit, luctus lacinia orci placerat sed. Vestibulum mollis diam purus, nec vulputate erat mollis id. Aliquam in est dapibus, porta magna sit amet, cursus tortor. Etiam lobortis sed arcu sed cursus. Nam et lacus ut est vestibulum semper. Donec semper tincidunt magna id posuere. Sed ac sodales arcu. Donec urna lorem, luctus sed finibus nec, feugiat vitae sem. Nulla facilisi. Morbi pulvinar accumsan dui et vehicula. Mauris pharetra tellus est, vestibulum mattis. Aliquam in est dapibus, porta magna sit amet, cursus tortor. Etiam lobortis sed arcu sed cursus. Nam et lacus ut est vestibulum semper. Donec semper tincidunt magna id posuere. Sed ac sodales arcu. Donec urna lorem, luctus sed finibus nec, feugiat vitae sem. Nulla facilisi. Morbi pulvinar accumsan dui et vehicula. Mauris pharetra tellus est, vestibulum mattis.";
    bool _isFavourite = true;
    List<String> items = ["Overview", "Rooms", "Review"];

    return SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor,
            appBar: AppBar(
              foregroundColor: textBase,
              backgroundColor: backgroundColor,
              //Colors.transparent
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {},
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.favorite),
                  color: Colors.pink[200],
                  onPressed: () {},
                )
              ],
            ),
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    Image.asset(
                      image,
                      fit: BoxFit.cover,
                      height: 300,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, top: 15),
                      width: double.infinity,
                      height: 341,
                      color: backgroundColor,
                      child: ListView(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 3),
                            child: const Text( "Overview",
                              style: TextStyle(
                                color: textBase,
                                fontSize: 22,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 15, right: 10),
                            child:  Text( lorem,
                              style: const TextStyle(
                                  color: textBase,
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        width: double.infinity,
                        color: Colors.transparent,
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              )
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10,),
                              Container(
                                padding: const EdgeInsets.only(left: 15, right: 15),
                                height: 40,
                                width: double.infinity,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: items.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(left: 10, right: 10),
                                    width: double.infinity,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[800],
                                    ),
                                    child: Center(
                                      child: Text(
                                        items[index],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  );
                                },),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Positioned(
                    //   left: 20,
                    //   top: 200,
                    //   child: Container(
                    //     child: Text("HELLO"),
                    //   ),
                    // )
                  ],
                ),
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