import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hoteldise/themes/constants.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:hoteldise/services/auth.dart';
import 'package:hoteldise/services/firebase_storage.dart';
import 'package:hoteldise/utils/toast.dart';
import 'package:unicons/unicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool circular = false;
  final ImagePicker _picker = ImagePicker();
  String? _imageFileUrl;
  String username = "User";
  final TextEditingController _textFieldController = TextEditingController();
  late AuthBase Auth;

  @override
  void initState() {
    super.initState();
  }

  void _logOut() async {
    context.loaderOverlay.show();
    try {
      await Auth.logOut();
      Navigator.pushNamedAndRemoveUntil(context, '/signIn', (route) => false);
    } catch (e) {
      CustomToast().show();
    } finally {
      context.loaderOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthBase auth = Provider.of<AuthBase>(context);
    setState(() {
      Auth = auth;
    });

    if (auth.currentUser!.photoURL != null) {
      setState(() {
        _imageFileUrl = auth.currentUser!.photoURL;
      });
    }
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 70,
              ),
              imageProfile(),
              Form(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 0.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(Auth.currentUser!.displayName ?? "User",
                              style: Theme.of(context).textTheme.headline5),
                          const SizedBox(
                            width: 10.0,
                          ),
                          InkWell(
                            onTap: () {
                              _showPopup(Auth);
                            },
                            child: const Icon(
                              UniconsLine.pen,
                              color: primaryColor,
                              size: 25.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      indent: 0,
                      endIndent: 0,
                      color: primaryColor,
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(Auth.currentUser!.email ?? "Email",
                            style: Theme.of(context).textTheme.headline5),
                        const SizedBox(
                          width: 10.0,
                        ),
                      ],
                    ),
                    const Divider(
                      indent: 0,
                      endIndent: 0,
                      color: primaryColor,
                      thickness: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.black,
                  side: BorderSide(color: primaryColor, width: 1.5),
                  minimumSize: Size.fromHeight(40),
                ),
                onPressed: () => _logOut(),
                child: const Text(
                  "LogOut",
                  style: TextStyle(color: primaryColor, fontSize: 15),
                ),
              )
            ],
          )),
    );
  }

  Future _showPopup(AuthBase Auth) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: const Text("Change Your Name",
                style: TextStyle(color: primaryColor)),
            content: TextField(
              onChanged: (value) {
                username = value;
              },
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "Your Name"),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("Add"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30)),
                onPressed: () {
                  if (username != '') {
                    Auth.updateUserName(username).then((value) {
                      if (value != null && value != '') {
                        setState(() {
                          username = value;
                        });
                        CustomToast(
                                color: Colors.green, message: "Sucess Changed")
                            .show();
                      }
                    });
                  }
                  _textFieldController.clear();

                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
            radius: 100.0,
            backgroundImage: _imageFileUrl != null
                ? NetworkImage(_imageFileUrl!)
                : const NetworkImage(
                    'https://images.unsplash.com/photo-1498503403619-e39e4ff390fe?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80')),
        Positioned(
          bottom: 20.0,
          right: 30.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: const Icon(
              Icons.camera_alt,
              color: primaryColor,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      String? res =
          await FStorage().putFile(Uuid().v4(), File(pickedFile!.path));
      await Auth.currentUser!.updatePhotoURL(res);
      if (res != null) {
        setState(() {
          _imageFileUrl = res;
        });
      }
    }
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose profile photo",
            style: TextStyle(fontSize: 20.0, color: primaryColor),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            // ignore: deprecated_member_use
            // ignore: deprecated_member_use
            TextButton.icon(
              icon: const Icon(Icons.image, color: primaryColor),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: const Text(
                "Gallery",
                style: TextStyle(color: primaryColor),
              ),
            ),
          ])
        ],
      ),
    );
  }
}
