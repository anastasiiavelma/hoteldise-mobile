import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../themes/colors.dart';

class BottomMenu extends StatefulWidget {
  const BottomMenu({Key? key}) : super(key: key);

  @override
  State<BottomMenu> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<BottomMenu>
    with SingleTickerProviderStateMixin {
  late final TabController controller;

  @override
  void initState() {
    controller = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Added
      initialIndex: 0, //Added
      child: Material(
        color: secondaryColor,
        child: TabBar(
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.white,
          // labelColor: Color(0xffffdad8),
          onTap: (index) {},
          tabs: [
            Tab(icon: Icon(UniconsLine.bed)),
            Tab(icon: Icon(Icons.favorite)),
            Tab(icon: Icon(Icons.account_box)),
            Tab(icon: Icon(Icons.settings_rounded)),
          ],
        ),
      ),
    );
  }
}
