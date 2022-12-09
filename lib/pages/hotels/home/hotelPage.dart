import 'dart:convert';
import 'package:hoteldise/utils/toast.dart';
import 'package:hoteldise/widgets/comments.dart';
import 'package:flutter/material.dart';
import 'package:hoteldise/models/rating.dart';
import 'package:hoteldise/pages/hotels/home/home.dart';
import 'package:hoteldise/services/auth.dart';
import 'package:hoteldise/services/firestore.dart';
import 'package:provider/provider.dart';
import 'package:hoteldise/widgets/star_icon_button.dart';
import '/../../themes/constants.dart';
import '/../models/hotel.dart';
//import 'package:hoteldise/services/auth.dart';
//import 'package:provider/provider.dart';

class HotelPage extends StatefulWidget {
  final String imagePath;
  final Hotel? hotel;
  final bool barrierDismissible;
  final Function(DateTime, DateTime)? onApplyClick;
  final Function()? onCancelClick;
  final BuildContext context;

  const HotelPage(
      {Key? key,
      this.onApplyClick,
      this.onCancelClick,
      this.barrierDismissible = true,
      this.hotel, // required this.hotel
      required this.context,
      required this.imagePath})
      : super(key: key);

  @override
  State<HotelPage> createState() => HotelPageState();
}

class HotelPageState extends State<HotelPage> with TickerProviderStateMixin {
  AnimationController? animationController;
  final TextEditingController _textFieldController = TextEditingController();
  String commentText = '';
  List<dynamic> comments = [];

  Map<String, dynamic> _placeRating = {"mark": 0, "count": 0};
  bool _isRatingSending = false;
  int filledStars = 0;
  late AuthBase Auth;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    animationController?.forward();
    super.initState();
    setState(() {
      _placeRating = jsonDecode(widget.hotel!.rating.toString());
    });
    setState(() {
      Auth = Provider.of<AuthBase>(widget.context);
    });
    Firestore()
        .getUserRatingForPlace(Auth.currentUser!.uid, widget.hotel!.hotelId)
        .then((value) => setState(() {
              filledStars = value;
            }));
    Firestore().getPlaceComments(widget.hotel!.hotelId).then((value) {
      print(value);
      setState(() {
        comments = value;
      });
    });
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
          oldMark: _placeRating['mark'].toDouble(),
          hotelId: widget.hotel!.hotelId,
          usersCount: _placeRating['users']);
      await Firestore().updateUserPlaceRating(
          Auth.currentUser!.uid, widget.hotel!.hotelId, newRating);
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

  @override
  Widget build(BuildContext context) {
    const String image = "assets/images/hotel_template.jpg";
    String hotelName = "Hotel Name";
    int matchedPlaces = 3;
    String lorem =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque elementum volutpat porta. Nulla in nisl egestas, euismod ante vel, pulvinar erat. Duis varius ut ante et vulputate. Ut non porta diam. Aliquam convallis iaculis nunc et placerat. Nunc malesuada nisi accumsan diam viverra, vitae placerat magna commodo. Duis sit amet purus at lectus convallis pharetra dignissim id nisi. Duis hendrerit justo sed enim finibus, id tincidunt odio rutrum. Aliquam erat volutpat. Nulla dictum sollicitudin ante, eu luctus tortor aliquam vel. Pellentesque iaculis augue nisl, eu ultricies neque pellentesque vitae. Nam leo sapien, porttitor nec diam in, efficitur congue mi. Nam nibh mi, rutrum nec suscipit at, tincidunt sed nulla. Phasellus nibh turpis, maximus ac volutpat sed, varius sed lorem. Praesent luctus eros ac pellentesque condimentum. Sed viverra cursus velit, luctus lacinia orci placerat sed. Vestibulum mollis diam purus, nec vulputate erat mollis id. Aliquam in est dapibus, porta magna sit amet, cursus tortor. Etiam lobortis sed arcu sed cursus. Nam et lacus ut est vestibulum semper. Donec semper tincidunt magna id posuere. Sed ac sodales arcu. Donec urna lorem, luctus sed finibus nec, feugiat vitae sem. Nulla facilisi. Morbi pulvinar accumsan dui et vehicula. Mauris pharetra tellus est, vestibulum mattis. Aliquam in est dapibus, porta magna sit amet, cursus tortor. Etiam lobortis sed arcu sed cursus. Nam et lacus ut est vestibulum semper. Donec semper tincidunt magna id posuere. Sed ac sodales arcu. Donec urna lorem, luctus sed finibus nec, feugiat vitae sem. Nulla facilisi. Morbi pulvinar accumsan dui et vehicula. Mauris pharetra tellus est, vestibulum mattis.";
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
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HotelsHome()),
                  );
                },
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
                Column(children: [
                  Image.asset(
                    image,
                    fit: BoxFit.cover,
                    height: 300,
                  ),
                  Column(children: [
                    const Text("Rating",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.yellow,
                        )),
                    _buildRatingStars(filledStars)
                  ]),
                  Container(
                    padding: const EdgeInsets.only(left: 10, top: 15),
                    width: double.infinity,
                    height: 351,
                    color: backgroundColor,
                    child: ListView(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 3),
                          child: const Text(
                            "Overview",
                            style: TextStyle(
                                color: textBase,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 15, right: 10),
                          child: Text(
                            lorem,
                            style: const TextStyle(
                                color: textBase,
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Container(
                      width: double.infinity,
                      color: backgroundColor,
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            )),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              height: 40,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    width: 100,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade800,
                                    ),
                                    child: const Text(
                                      "Overview",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: textBase,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    width: 100,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade800,
                                    ),
                                    child: const Text(
                                      "Rooms",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: textBase,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    width: 100,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade800,
                                    ),
                                    child: const Text(
                                      "Reviews",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: textBase,
                                      ),
                                    ),
                                  )
                                ],
                              ),
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
                  ElevatedButton(
                      child: Text("Add comment"),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30)),
                      onPressed: () => _showPopup())
                ]),
                ...comments.map((item) => Comment(
                      commentText: item['comment'],
                      imagePath: item['avatarUrl'],
                    ))
              ],
            )));
  }

  Future _showPopup() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add your comment"),
            content: TextField(
              onChanged: (value) {
                commentText = value;
              },
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "Comment"),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("Add"),
                style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 30)),
                onPressed: () {
                  if (commentText != '') {
                    Firestore()
                        .addComment(
                            comment: commentText,
                            hotel_id: widget.hotel!.hotelId,
                            user_email: Auth.currentUser!.email ?? '',
                            user_id: Auth.currentUser!.uid)
                        .then((value) => CustomToast(
                                color: Colors.green,
                                message: "Your comment added")
                            .show());
                  }
                  _textFieldController.clear();
                  setState(() {
                    commentText = '';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

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
