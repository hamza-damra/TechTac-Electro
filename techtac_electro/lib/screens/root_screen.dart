import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:techtac_electro/provider/cart_provider.dart';
import 'package:techtac_electro/provider/product_provider.dart';
import 'package:techtac_electro/provider/user_provider.dart';
import 'package:techtac_electro/provider/wishlist_provider.dart';
import 'package:techtac_electro/screens/cart/cart_screen.dart';
import 'package:techtac_electro/screens/home_screen.dart';
import 'package:techtac_electro/screens/profile_screen.dart';
import 'package:techtac_electro/screens/search_screen.dart';


class RootScreen extends StatefulWidget {
  static const routeName = '/RootScreen';
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late PageController controller;
  int currentScreen = 0;
  bool isLoadingProds = true;
  List<Widget> screens = [
    const HomeScreen(),
    const SearchScreen(),
    const CartScreen(),
    const ProfileScreen()
  ];
  @override
  void initState() {
    super.initState();
    controller = PageController(
      initialPage: currentScreen,
    );
  }

  Future<void> fetchAppData() async {

    final productsProvider = Provider.of<ProductProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);


    try {
      Future.wait({
        productsProvider.fetchProducts(),
        userProvider.fetchUserInfo(),
        cartProvider.fetchCart(),
        wishlistProvider.fetchWishlist(),
      });
    } catch (error) {
      log(error.toString());
    } finally {
      setState(() {
        isLoadingProds = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isLoadingProds) {
      fetchAppData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentScreen,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 2,
        height: kBottomNavigationBarHeight,
        onDestinationSelected: (index) {
          setState(() {
            currentScreen = index;
          });
          controller.jumpToPage(currentScreen);
        },
        destinations: [
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.home),
            icon: Icon(IconlyLight.home),
            label: "Home",
          ),
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.search),
            icon: Icon(IconlyLight.search),
            label: "Search",
          ),
          NavigationDestination(
            selectedIcon: const Icon(IconlyBold.bag2),
            icon: Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                return Badge(
                  backgroundColor: Colors.blue,
                  label: Text(cartProvider.getCartItems.length.toString()),
                  child: const Icon(IconlyLight.bag2),
                );
              },
            ),
            label: "Cart",
          ),
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.profile),
            icon: Icon(IconlyLight.profile),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
