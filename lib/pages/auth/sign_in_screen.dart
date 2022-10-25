import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        padding:
            const EdgeInsets.only(top: 40, bottom: 70, left: 30, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        constraints: BoxConstraints.loose(Size.infinite),
                        margin: const EdgeInsets.only(bottom: 15),
                        child: Image.asset(
                          'assets/images/building.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Form(
                        child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(UniconsLine.user),
                            border: UnderlineInputBorder(),
                            hintText: "Name",
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            icon: Icon(UniconsLine.envelope_alt),
                            border: UnderlineInputBorder(),
                            hintText: "Email",
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          autocorrect: false,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            icon: Icon(UniconsLine.key_skeleton_alt),
                            border: UnderlineInputBorder(),
                            hintText: "Password",
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                            ),
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/', (route) => false);
                            },
                            child: const Text("Sign Up")),
                      ],
                    ))
                  ]),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Divider(
              height: 3.0,
              indent: 50.0,
              endIndent: 50.0,
              color: Colors.black,
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.bottomCenter,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        side:
                            BorderSide(color: Theme.of(context).primaryColor)),
                    onPressed: () {
                      Navigator.pushNamed(context, '/signIn');
                    },
                    child: const Text("Sign In")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
