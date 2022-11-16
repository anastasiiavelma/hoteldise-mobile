import 'package:flutter/material.dart';
import 'package:hoteldise/pages/favourite/favScreen.dart';
import 'package:hoteldise/pages/hotels/home/home.dart';
import 'package:unicons/unicons.dart';

import '../../themes/constants.dart';

class MenuBar extends StatefulWidget {
  const MenuBar({Key? key}) : super(key: key);

  @override
  State<MenuBar> createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static const List<Widget> _widgetOptions = <Widget>[
    HotelsHome(),
    FavScreen(),
    FavScreen(),
    FavScreen(),
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
                icon: Icon(Icons.favorite),
              ),
              Tab(icon: Icon(Icons.account_box)),
              Tab(icon: Icon(Icons.settings_rounded)),
            ],
          ),
        ),
      ),
    );
  }
}
