import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:techtac_electro/provider/dark_theme_provider.dart';
import 'package:techtac_electro/screens/cart/cart_screen.dart';
import 'package:techtac_electro/screens/search_screen.dart';
import 'package:techtac_electro/screens/home_screen.dart';
import 'package:techtac_electro/screens/user_screen.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;
  final List _pages = [
    const HomeScreen(),
    SearchScreen(),
    const CartScreen(),
    const UserScreen(),
  ];
  void _selectedPage(int index) {
    //to choose the page
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<ThemeProvider>(context);
    bool _isDark = themeState.getIsDarkTheme;

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: _isDark ? Theme.of(context).cardColor : Colors.white,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          unselectedItemColor: _isDark ? Colors.white10 : Colors.black12,
          selectedItemColor: _isDark ? Colors.lightBlue[200] : Colors.black87,
          onTap: _selectedPage,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                  _selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                  _selectedIndex == 1 ? IconlyBold.search : IconlyLight.search),
              label: "Categories",
            ),
            BottomNavigationBarItem(
              icon: Badge(
                  label: Text("6"),
                  child: Icon(_selectedIndex == 2
                      ? IconlyBold.bag2
                      : IconlyLight.bag2)),
              label: "Cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 3
                  ? IconlyBold.profile
                  : IconlyLight.profile),
              label: "Profile",
            ),
          ]),
    );
  }
}