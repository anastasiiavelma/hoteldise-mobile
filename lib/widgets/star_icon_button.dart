import 'package:flutter/material.dart';
import 'package:hoteldise/themes/constants.dart';

class StarIconButton extends StatelessWidget {
  final bool isFilled;
  final VoidCallback onPressed;
  final bool isDisabled;

  const StarIconButton(
      {Key? key,
      required this.isFilled,
      required this.onPressed,
      required this.isDisabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: Icon(
          isFilled ? Icons.star_rounded : Icons.star_border_rounded,
          color: primaryColor,
          size: 30,
        ),
        onPressed: isDisabled ? () {} : onPressed);
  }
}
