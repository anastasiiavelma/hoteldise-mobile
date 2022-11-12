import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hoteldise/pages/auth/sign_in_screen.dart';
import 'package:hoteldise/themes/colors.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../../themes/colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  Widget _buildImage(String assetName, [double width = 250]) {
    return Image.asset('assets/images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('');
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: backgroundColor,
      imagePadding: EdgeInsets.zero,
    );

    return Scaffold(
      body: IntroductionScreen(
        globalBackgroundColor: backgroundColor,
        pages: [
          PageViewModel(
            title: "HotelDise",
            body:
                "This application is for those who like to travel in comfort. The application has many functions and features that can please every traveler.",
            image: Image.asset('assets/images/firstscreen.png', width: 350),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Beautiful hotels",
            body:
                "You have the opportunity to visit the most exotic and extraordinary hotels that will give you unforgettable emotions.",
            image: _buildImage('secondscreen.png'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Adding to favourites",
            body:
                "You have the ability to add the hotels you like to your favorites, as well as delete, sort and filter them..",
            image: _buildImage('thirdscreen.png'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Chat with managers",
            body:
                "You have the opportunity to communicate with managers when you have difficulties. \n \n Log in and discover all the delights of this application!",
            image: _buildImage('fourthscreen.png'),
            decoration: pageDecoration,
          ),
        ],
        onDone: () {
          box.put('introduction', false);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return const SignInScreen();
              },
            ),
          );
        },
        showSkipButton: true,
        skip: const Text("Skip",
            style: TextStyle(fontWeight: FontWeight.w600, color: primaryColor)),
        next: const Icon(
          Icons.forward,
          color: primaryColor,
        ),
        done: const Text("Done",
            style: TextStyle(fontWeight: FontWeight.w600, color: primaryColor)),
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: primaryColor,
            color: const Color.fromARGB(255, 122, 122, 122),
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
      ),
    );
  }
}
