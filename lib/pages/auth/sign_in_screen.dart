// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hoteldise/utils/welcome.dart';
import 'package:unicons/unicons.dart';
import 'package:hoteldise/pages/auth/sign_up_screen.dart';
import '../../themes/constants.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hoteldise/services/auth.dart';
import 'package:hoteldise/utils/toast.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void _signInWithEmailAndPassword(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    context.loaderOverlay.show();
    AuthBase? auth = Provider.of<AuthBase>(context, listen: false);
    try {
      await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      context.loaderOverlay.hide();
      Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
    } catch (e) {
      CustomToast(message: 'No user or incorrect password').show();
    } finally {
      context.loaderOverlay.hide();
    }
  }

  void _signInWithGoogle(BuildContext context) async {
    context.loaderOverlay.show();
    AuthBase? auth = Provider.of<AuthBase>(context, listen: false);
    try {
      await auth.signInWithGoogle();
      Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
    } catch (e) {
      CustomToast(message: "Something went wrong").show();
    } finally {
      context.loaderOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: MultiValidator([
        RequiredValidator(errorText: 'email is required'),
        EmailValidator(errorText: 'enter correct email'),
      ]),
      onSaved: (value) {
        emailController.text = value!;
      },
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Email',
        hintText: "Enter your email",
      ),
    );

    final passwordField = TextFormField(
      controller: passwordController,
      autocorrect: false,
      autovalidateMode: AutovalidateMode.disabled,
      textInputAction: TextInputAction.done,
      obscureText: true,
      validator: MultiValidator([
        RequiredValidator(errorText: 'password is requires'),
        MinLengthValidator(8, errorText: 'password must be more 8 letters'),
      ]),
      onSaved: (value) {
        passwordController.text = value!;
      },
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Password',
        hintText: "Enter your password",
      ),
    );

    final signInButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: primaryColor,
          minimumSize: const Size.fromHeight(50),
        ),
        onPressed: () => _signInWithEmailAndPassword(context),
        child: Text('Sign In'));

    final googleButton = OutlinedButton(
      style: ElevatedButton.styleFrom(
        primary: secondaryColor,
        minimumSize: const Size.fromHeight(50),
      ),
      child: const Text(
        'Sign in with google',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () => _signInWithGoogle(context),
    );
    final box = Hive.box('');

    bool firstTimeState = box.get('introduction') ?? true;
    return firstTimeState
        ? const WelcomeScreen()
        : Scaffold(
            backgroundColor: backgroundColor,
            body: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(
                  top: 40, bottom: 70, left: 30, right: 30),
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
                              constraints:
                                  BoxConstraints.loose(const Size(75, 50)),
                              child: Image.asset(
                                'assets/images/building.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Hi there! Nice to see you again",
                              style: TextStyle(
                                color: Color.fromARGB(255, 122, 122, 122),
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Form(
                              child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(
                                height: 10.0,
                              ),
                              Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      emailField,
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      passwordField,
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      signInButton,
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      googleButton,
                                    ],
                                  )),
                            ],
                          ))
                        ]),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: 'Sign Up',
                            style: const TextStyle(
                              color: secondaryColor,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpScreen()));
                              }),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
