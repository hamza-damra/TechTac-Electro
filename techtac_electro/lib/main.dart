import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techtac_electro/provider/address_provider.dart';
import 'package:techtac_electro/provider/cart_provider.dart';
import 'package:techtac_electro/provider/dark_theme_provider.dart';
import 'package:techtac_electro/provider/order_provider.dart';
import 'package:techtac_electro/provider/product_provider.dart';
import 'package:techtac_electro/provider/user_provider.dart';
import 'package:techtac_electro/provider/viewed_prod_provider.dart';
import 'package:techtac_electro/provider/wishlist_provider.dart';
import 'package:techtac_electro/screens/address/add_address_screen.dart';
import 'package:techtac_electro/screens/address/address_screen.dart';
import 'package:techtac_electro/screens/auth/forgot_password.dart';
import 'package:techtac_electro/screens/auth/login.dart';
import 'package:techtac_electro/screens/auth/register.dart';
import 'package:techtac_electro/screens/inner_screens/orders/orders_screen.dart';
import 'package:techtac_electro/screens/inner_screens/viewed_recently.dart';
import 'package:techtac_electro/screens/onboarding/onboardingscreen.dart';
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
  final prefs = await SharedPreferences.getInstance();
  final onboarding = prefs.getBool("onboarding") ?? false;
  runApp(MyApp(onboarding: onboarding));
}

class MyApp extends StatelessWidget {
  final bool onboarding;
  const MyApp({super.key, this.onboarding = false});

  @override
  Widget build(BuildContext context) {
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
        ChangeNotifierProvider(
          create: (_) => AddressProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (
          context,
          themeProvider,
          child,
        ) {
          return MaterialApp(
            title: 'TechTac Electro',
            theme: Styles.themeData(
                isDarkTheme: themeProvider.getIsDarkTheme, context: context),
            debugShowCheckedModeBanner: false,
            home: onboarding ? RootScreen() : OnboardingScreen(),
            routes: {
              ProductDetails.routeName: (context) => const ProductDetails(),
              WishlistScreen.routName: (context) => const WishlistScreen(),
              ViewedRecentlyScreen.routName: (context) =>
                  const ViewedRecentlyScreen(),
              RegisterScreen.routName: (context) => const RegisterScreen(),
              LoginScreen.routName: (context) => const LoginScreen(),
              OrdersScreen.routeName: (context) => const OrdersScreen(),
              ForgotPasswordScreen.routeName: (context) =>
                  const ForgotPasswordScreen(),
              SearchScreen.routName: (context) => const SearchScreen(),
              RootScreen.routName: (context) => const RootScreen(),
              AddressScreen.routeName: (context) => const AddressScreen(),
              AddAddressScreen.routeName: (context) => const AddAddressScreen(),
            },
          );
        },
      ),
    );
  }
}
