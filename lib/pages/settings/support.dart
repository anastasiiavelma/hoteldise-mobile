import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'package:hoteldise/themes/constants.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 15.0,
            ),
            child: Column(children: [
              const SizedBox(
                height: 70.0,
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: const Text(
                    "Our unique HotelDise app invites users to take advantage of our support! Write to us on social networks or by mail what worries you or you notice an error. Our staff will be happy to answer you during the working day. All your suggestions will be heard. \n Stay with us!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                    )),
              ),
              const SizedBox(
                height: 50.0,
              ),
              const Text("Contact with us",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                  )),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                IconButton(
                    icon: const Icon(
                      UniconsLine.telegram_alt,
                      color: secondaryColor,
                      size: 40,
                    ),
                    onPressed: () {}),
                IconButton(
                    icon: const Icon(
                      UniconsLine.facebook_f,
                      color: secondaryColor,
                      size: 40,
                    ),
                    onPressed: () {}),
                IconButton(
                    icon: const Icon(
                      UniconsLine.instagram,
                      color: secondaryColor,
                      size: 40,
                    ),
                    onPressed: () {}),
              ]),
            ])));
  }
}
