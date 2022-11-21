import 'package:flutter/material.dart';
import 'package:hoteldise/services/auth.dart';
import 'package:hoteldise/widgets/fav_cards.dart';
import '../../themes/constants.dart';
import 'package:provider/provider.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({Key? key}) : super(key: key);

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  Widget build(BuildContext context) {
    AuthBase Auth = Provider.of<AuthBase>(context);
    return Scaffold(
        backgroundColor: backgroundColor, body: FavCards(Auth: Auth));
  }
}
