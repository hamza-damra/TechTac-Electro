import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:techtac_electro/provider/cart_provider.dart';
import 'package:techtac_electro/provider/dark_theme_provider.dart';
import 'package:techtac_electro/screens/cart/cart_screen.dart';
import 'package:techtac_electro/screens/search_screen.dart';
import 'package:techtac_electro/screens/home_screen.dart';
import 'package:techtac_electro/screens/profile_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;
  final List _pages = [
    const HomeScreen(),
    const SearchScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];
  void _selectedPage(int index) {
    //to choose the page
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final themeState = Provider.of<ThemeProvider>(context);
    bool isDark = themeState.getIsDarkTheme;

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: isDark ? Theme.of(context).cardColor : Colors.white,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          unselectedItemColor: isDark ? Colors.white10 : Colors.black12,
          selectedItemColor: isDark ? Colors.lightBlue[200] : Colors.black87,
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
                  label: Text(cartProvider.getCartItems.length.toString()),
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
