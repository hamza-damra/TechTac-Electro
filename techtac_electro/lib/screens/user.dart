import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:techtac_electro/provider/dark_theme_provider.dart';
import 'package:techtac_electro/services/assets_manager.dart';
import 'package:techtac_electro/widgets/custom_listt_ile.dart';
import 'package:techtac_electro/widgets/subtitle_text.dart';
import 'package:techtac_electro/widgets/text_widget.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressTextController =
      TextEditingController(text: "");
  @override
  void dispose() {
    _addressTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Profile screen'),
          leading: Image.asset(AssetsManager.shoppingCart),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Visibility(
              visible: false,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: TitlesTextWidget(
                    label: "Please login to have ultimate access"),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).cardColor,
                      border: Border.all(
                          color: Theme.of(context).colorScheme.background,
                          width: 3),
                      image: const DecorationImage(
                        image: NetworkImage(
                            'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitlesTextWidget(label: "Mohammad Hirbawi"),
                      SubtitleTextWidget(label: 'MohammadHirbawi6@gmail.com'),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitlesTextWidget(label: 'General'),
                  CustomListTile(
                    imagesPath: AssetsManager.orderSvg,
                    text: "All orders",
                    function: () {},
                  ),
                  CustomListTile(
                    imagesPath: AssetsManager.wishlistSvg,
                    text: "WishList",
                    function: () {},
                  ),
                  CustomListTile(
                    imagesPath: AssetsManager.recent,
                    text: "Viewed recently",
                    function: () {},
                  ),
                  CustomListTile(
                    imagesPath: AssetsManager.address,
                    text: "Address",
                    function: () {},
                  ),
                  const Divider(thickness: 1),
                  const SizedBox(width: 7),
                  const TitlesTextWidget(label: "Settings"),
                  const SizedBox(width: 7),
                  SwitchListTile(
                    title: Text(themeProvider.getIsDarkTheme
                        ? "Dark mode"
                        : "Light mode"),
                    secondary: Image.asset(
                      AssetsManager.theme,
                      height: 30,
                    ),
                    onChanged: (bool value) {
                      setState(
                        () {
                          themeProvider.setDarkTheme(value);
                        },
                      );
                    },
                    value: themeProvider.getIsDarkTheme,
                  ),
                  const Divider(thickness: 1),
                ],
              ),
            ),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 17, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {},
                icon: Icon(
                  Icons.login,
                  color: themeProvider.getIsDarkTheme
                      ? Colors.black
                      : Colors.white,
                ),
                label: Text(
                  "Login",
                  style: TextStyle(
                    color: themeProvider.getIsDarkTheme
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
