import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:stock_price_app/screens/home_screen.dart';
import 'package:stock_price_app/screens/watchlist_screen.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  List screens = [
    HomeScreen(),
    WatchlistScreen(),
  ];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60,
        color: Colors.deepPurple.shade50,
        backgroundColor: Colors.deepPurple.shade100,
        items: [
          Icon(Icons.home),
          Icon(Icons.heart_broken),
        ],
        onTap: (index){
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: screens[_selectedIndex],

    );
  }
}
