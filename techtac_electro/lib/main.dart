import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techtac_electro/consts/theme_data.dart';
import 'package:techtac_electro/provider/dark_theme_provider.dart';
import 'package:techtac_electro/screens/btmBar_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeProvider themeChangeProvider = ThemeProvider();

  // This widget is the root of your application.
  void getCurrentAppTheme(bool value) async {
    await themeChangeProvider.setDarkTheme(value);
  }

  @override
  void initState() {
    getCurrentAppTheme(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return themeChangeProvider;
        })
      ],
      child: Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: Styles.themeData(themeProvider.getIsDarkTheme, context),
            home: const BottomBarScreen());
      }),
    );
  }
}
