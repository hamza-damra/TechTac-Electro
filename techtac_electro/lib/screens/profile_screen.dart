import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:techtac_electro/models/user_model.dart';
import 'package:techtac_electro/provider/dark_theme_provider.dart';
import 'package:techtac_electro/provider/order_provider.dart';
import 'package:techtac_electro/provider/user_provider.dart';
import 'package:techtac_electro/provider/wishlist_provider.dart';
import 'package:techtac_electro/provider/viewed_prod_provider.dart';
import 'package:techtac_electro/provider/cart_provider.dart';
import 'package:techtac_electro/screens/address/address_screen.dart';
import 'package:techtac_electro/screens/auth/login.dart';
import 'package:techtac_electro/screens/inner_screens/orders/orders_screen.dart';
import 'package:techtac_electro/screens/inner_screens/viewed_recently.dart';
import 'package:techtac_electro/screens/inner_screens/wishlist.dart';
import 'package:techtac_electro/screens/loading_manager.dart';
import 'package:techtac_electro/services/assets_manager.dart';
import 'package:techtac_electro/services/my_app_method.dart';
import 'package:techtac_electro/widgets/app_name_text.dart';
import 'package:techtac_electro/widgets/subtitle_text.dart';
import 'package:techtac_electro/widgets/text_widget.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/ProfileScreen';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  User? user = FirebaseAuth.instance.currentUser;
  bool _isLoading = true;
  UserModel? userModel;

  Future<void> fetchUserInfo() async {
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      userModel = await userProvider.fetchUserInfo();
    } catch (error) {
      await MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "An error has occurred $error",
        fct: () {},
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        // Prevent default back navigation
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const AppNameTextWidget(fontSize: 20),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.shoppingCart),
          ),
        ),
        body: LoadingManager(
          isLoading: _isLoading,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: user == null,
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TitlesTextWidget(
                        label: "Please login to have ultimate access"),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                userModel == null
                    ? const SizedBox.shrink()
                    : Padding(
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    width: 3),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    userModel!.userImage,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitlesTextWidget(label: userModel!.userName),
                                SubtitleTextWidget(
                                  label: userModel!.userEmail,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TitlesTextWidget(label: "General"),
                      user == null
                          ? const SizedBox.shrink()
                          : CustomListTile(
                              imagePath: AssetsManager.orderSvg,
                              text: "All orders",
                              function: () async {
                                await Navigator.pushNamed(
                                  context,
                                  OrdersScreen.routeName,
                                );
                              },
                            ),
                      user == null
                          ? const SizedBox.shrink()
                          : CustomListTile(
                              imagePath: AssetsManager.wishlistSvg,
                              text: "Wishlist",
                              function: () async {
                                await Navigator.pushNamed(
                                  context,
                                  WishlistScreen.routeName,
                                );
                              },
                            ),
                      CustomListTile(
                        imagePath: AssetsManager.recent,
                        text: "Viewed recently",
                        function: () async {
                          await Navigator.pushNamed(
                            context,
                            ViewedRecentlyScreen.routeName,
                          );
                        },
                      ),
                      user == null
                          ? const SizedBox.shrink()
                          : CustomListTile(
                              imagePath: AssetsManager.address,
                              text: "Address",
                              function: () {
                                Navigator.pushNamed(context, AddressScreen.routeName);
                              },
                            ),
                      const Divider(
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      const TitlesTextWidget(label: "Settings"),
                      const SizedBox(
                        height: 7,
                      ),
                      SwitchListTile(
                        secondary: Image.asset(
                          AssetsManager.theme,
                          height: 30,
                        ),
                        title: Text(themeProvider.getIsDarkTheme
                            ? "Dark mode"
                            : "Light mode"),
                        value: themeProvider.getIsDarkTheme,
                        onChanged: (value) {
                          themeProvider.setDarkTheme(themeValue: value);
                        },
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          30,
                        ),
                      ),
                    ),
                    icon: Icon(user == null ? Icons.login : Icons.logout),
                    label: Text(
                      user == null ? "Login" : "Logout",
                    ),
                    onPressed: () async {
                      if (user == null) {
                        await Navigator.pushNamed(
                          context,
                          LoginScreen.routeName,
                        );
                      } else {
                        await MyAppMethods.showErrorORWarningDialog(
                          context: context,
                          subtitle: "Are you sure?",
                          fct: () async {
                            await FirebaseAuth.instance.signOut();
                            wishlistProvider.clearWishlistItems();
                            viewedProdProvider.clearViewedProducts();
                            cartProvider.clearLocalCart();
                            ordersProvider.clearOrders();
                            if (!mounted) return;
                            await Navigator.pushNamed(
                              context,
                              LoginScreen.routeName,
                            );
                          },
                          isError: false,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.imagePath,
    required this.text,
    required this.function,
  });

  final String imagePath, text;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        function();
      },
      leading: Image.asset(
        imagePath,
        height: 30,
      ),
      title: SubtitleTextWidget(label: text),
      trailing: const Icon(IconlyLight.arrowRight2),
    );
  }
}
