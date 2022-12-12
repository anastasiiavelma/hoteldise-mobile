import 'package:flutter/material.dart';
import 'package:hoteldise/themes/constants.dart';

class Comment extends StatelessWidget {
  final String imagePath;
  final String commentText;
  final String userEmail;
  const Comment({
    Key? key,
    required this.imagePath,
    required this.commentText,
    required this.userEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50.0,
            height: 50.0,
            child: ClipOval(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: 280.0,
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(color: primaryColor),
              borderRadius: const BorderRadius.all(Radius.circular(15.0) //
                  ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userEmail,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 15,
                      color: textBase,
                    )),
                Text(commentText,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 20,
                      color: secondaryColor,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
