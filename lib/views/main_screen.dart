import 'package:flutter/material.dart';
import 'package:game_galaxy/views/favorite_page.dart';
import 'package:game_galaxy/views/home_page.dart';
import 'package:game_galaxy/utils/color.dart';
import 'package:game_galaxy/views/logout.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> _screens = [
    const Home(),
    const FavoritePage(),
    const LogoutPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: redColor1,
        unselectedItemColor: Colors.grey.shade800,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
      ),
    );
  }
}
