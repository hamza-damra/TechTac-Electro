import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techtac_electro/provider/cart_provider.dart';
import 'package:techtac_electro/provider/dark_theme_provider.dart';
import 'package:techtac_electro/provider/order_provider.dart';
import 'package:techtac_electro/provider/product_provider.dart';
import 'package:techtac_electro/provider/user_provier.dart';
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
      storageBucket: "techtacelectro.appspot.com",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: SelectableText(
                      "An error has been occured ${snapshot.error}"),
                ),
              );
            }
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => ThemeProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => ProductProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => CartProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => WishlistProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => ViewedProdProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => UserProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => OrdersProvider(),
                ),
              ],
              child: Consumer<ThemeProvider>(
                builder: (
                  context,
                  themeProvider,
                  child,
                ) {
                  return MaterialApp(
                    title: 'Shop Smart AR',
                    theme: Styles.themeData(
                        isDarkTheme: themeProvider.getIsDarkTheme,
                        context: context),
                    home: const RootScreen(),
                    // home: const RegisterScreen(),
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
                      RootScreen.routName: (context) => const RootScreen(),
                    },
                  );
                },
              ),
            );
          }),
    );
  }
}
