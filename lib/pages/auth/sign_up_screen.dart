import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hoteldise/services/firestore.dart';
import 'package:unicons/unicons.dart';
import 'package:hoteldise/pages/auth/sign_in_screen.dart';
import '../../themes/constants.dart';
import 'package:hoteldise/utils/toast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:hoteldise/services/auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  void _signUpWithEmailAndPassword(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    context.loaderOverlay.show();
    AuthBase? auth = Provider.of<AuthBase>(context, listen: false);
    try {
      await auth.signUpWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
          name: nameController.text);
      User? user = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (user != null) {
        await Firestore().addUser(user);
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    } catch (e) {
      CustomToast(message: 'enter correct field').show();
    } finally {
      context.loaderOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
      autocorrect: false,
      controller: nameController,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validator: RequiredValidator(errorText: 'name is requires'),
      onSaved: (value) {
        nameController.text = value!;
      },
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Name',
        hintText: "Enter your name",
      ),
    );

    final emailField = TextFormField(
      controller: emailController,
      validator: MultiValidator([
        RequiredValidator(errorText: 'email is required'),
        EmailValidator(errorText: 'enter correct email'),
      ]),
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Email',
        hintText: "Enter your email",
      ),
    );

    final passwordField = TextFormField(
      controller: passwordController,
      autovalidateMode: AutovalidateMode.disabled,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      obscureText: true,
      validator: MultiValidator([
        RequiredValidator(errorText: 'password is reqiured'),
        MinLengthValidator(8,
            errorText: 'password must be contain 8 characters'),
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

    final signUpButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: primaryColor,
          minimumSize: const Size.fromHeight(50),
        ),
        onPressed: () => _signUpWithEmailAndPassword(context),
        child: Text('Continue'));

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.only(top: 40, bottom: 20, left: 30, right: 30),
          reverse: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      constraints:
                          BoxConstraints(maxHeight: 160, minHeight: 80),
                      margin: const EdgeInsets.only(bottom: 15),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            nameField,
                            const SizedBox(
                              height: 10.0,
                            ),
                            emailField,
                            const SizedBox(
                              height: 10.0,
                            ),
                            passwordField,
                            const SizedBox(
                              height: 20.0,
                            ),
                            signUpButton,
                          ],
                        ))
                  ]),
              const SizedBox(
                height: 30.0,
              ),
              Center(
                child: RichText(
                  text: TextSpan(children: [
                    const TextSpan(
                      text: 'Already have account? ',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                        text: 'Login',
                        style: const TextStyle(
                          color: primaryColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignInScreen()));
                          }),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
