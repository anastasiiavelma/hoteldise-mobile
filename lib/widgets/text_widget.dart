import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final double size;
  final String text;
  final Color color;
  final FontWeight weight;
   AppText({Key? key,
    this.size = 16,
    this.color = Colors.black,
    required this.text,
    this.weight = FontWeight.normal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: weight
      ),
    );
  }
}