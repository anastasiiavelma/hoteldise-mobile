import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCircle(
      color: Theme.of(context).primaryColor,
      size: 60.0,
    );
  }
}
