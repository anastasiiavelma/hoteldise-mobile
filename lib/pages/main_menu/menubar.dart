import 'package:flutter/material.dart';
import 'package:hoteldise/pages/favourite/favScreen.dart';
import 'package:hoteldise/pages/hotels/home/home.dart';
import 'package:hoteldise/pages/profile/profile_screen.dart';
import 'package:hoteldise/pages/settings/support.dart';
import 'package:unicons/unicons.dart';

import '../../themes/constants.dart';

class MenuBar extends StatefulWidget {
  const MenuBar({Key? key}) : super(key: key);

  @override
  State<MenuBar> createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HotelsHome(),
    FavScreen(),
    ProfileScreen(),
    SupportScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _widgetOptions.length,
      initialIndex: _selectedIndex,
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomAppBar(
          color: secondaryColor,
          child: TabBar(
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.white,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: const [
              Tab(
                icon: Icon(UniconsLine.bed),
              ),
              Tab(
                icon: Icon(UniconsLine.heart),
              ),
              Tab(icon: Icon(UniconsLine.user_circle)),
              Tab(icon: Icon(UniconsLine.envelope_question)),
            ],
          ),
        ),
      ),
    );
  }
}
