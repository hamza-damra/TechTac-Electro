import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techtac_electro/provider/cart_provider.dart';
import 'package:techtac_electro/provider/dark_theme_provider.dart';
import 'package:techtac_electro/provider/product_provider.dart';
import 'package:techtac_electro/provider/viewed_prod_provider.dart';
import 'package:techtac_electro/provider/wishlist_provider.dart';
import 'package:techtac_electro/screens/auth/forgot_password.dart';
import 'package:techtac_electro/screens/auth/login.dart';
import 'package:techtac_electro/screens/auth/register.dart';
import 'package:techtac_electro/screens/inner_screens/orders/orders_screen.dart';
import 'package:techtac_electro/screens/inner_screens/viewed_recently.dart';
import 'package:techtac_electro/screens/root_screen.dart';
import 'package:techtac_electro/screens/search_screen.dart';
import 'consts/theme_data.dart';
import 'screens/inner_screens/product_details.dart';
import 'screens/inner_screens/wishlist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCafT4k49z1hH0KYgTklSj0Cw7RoqsGgL4",
      appId: "1:542912087664:android:dbc5eaa77b253a274e16b5",
      messagingSenderId: "542912087664",
      projectId: "techtacelectro",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              // Ensure MaterialApp wraps Scaffold during loading
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return MaterialApp(
              // Ensure MaterialApp wraps Scaffold during error
              home: Scaffold(
                body: Center(
                  child: SelectableText(
                      'An error has occurred: ${snapshot.error}'),
                ),
              ),
            );
          }

          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => ThemeProvider()),
              ChangeNotifierProvider(create: (_) => ProductProvider()),
              ChangeNotifierProvider(create: (_) => CartProvider()),
              ChangeNotifierProvider(create: (_) => WishlistProvider()),
              ChangeNotifierProvider(create: (_) => ViewedProdProvider()),
            ],
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Shop Smart AR',
                  theme: Styles.themeData(
                      isDarkTheme: themeProvider.getIsDarkTheme,
                      context: context),
                  home: const RootScreen(),
                  routes: {
                    ProductDetails.routName: (context) =>
                        const ProductDetails(),
                    WishlistScreen.routName: (context) =>
                        const WishlistScreen(),
                    ViewedRecentlyScreen.routName: (context) =>
                        const ViewedRecentlyScreen(),
                    RegisterScreen.routName: (context) =>
                        const RegisterScreen(),
                    LoginScreen.routName: (context) => const LoginScreen(),
                    OrdersScreenFree.routeName: (context) =>
                        const OrdersScreenFree(),
                    ForgotPasswordScreen.routeName: (context) =>
                        const ForgotPasswordScreen(),
                    SearchScreen.routName: (context) => const SearchScreen(),
                  },
                );
              },
            ),
          );
        });
  }
}
