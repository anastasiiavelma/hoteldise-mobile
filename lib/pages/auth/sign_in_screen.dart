import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => SighInScreenState();
}

class SighInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            alignment: Alignment.center,
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                    top: 40, bottom: 30, left: 30, right: 30),
                reverse: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          constraints: const BoxConstraints(
                              maxHeight: 160, minHeight: 80),
                          margin: const EdgeInsets.only(bottom: 15),
                          child: Image.asset(
                            'assets/images/planet.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text('ddfdf'),
                        Text('ddfdf'),
                        TextField(),
                        const TextField(),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0x00f85f6a)), //Background Color
                            elevation: MaterialStateProperty.all(
                                3), //Defines Elevation
                            shadowColor: MaterialStateProperty.all(
                                const Color(0x00f85f6a)), //Defines shadowColor
                          ),
                          onPressed: () {},
                          child: Text('Sign In'),
                        )
                      ],
                    ),
                  ],
                ))));
  }
}
