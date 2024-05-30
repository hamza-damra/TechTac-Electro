import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techtac_electro/provider/cart_provider.dart';
import 'package:techtac_electro/provider/product_provider.dart';
import 'package:techtac_electro/provider/user_provider.dart';
import 'package:techtac_electro/widgets/subtitle_text.dart';
import 'package:techtac_electro/widgets/text_widget.dart';
import 'package:techtac_electro/services/stripe_payment/payment_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/order_service.dart';
import '../../services/my_app_method.dart';
import '../../services/assets_manager.dart';
import 'package:techtac_electro/widgets/empty_bag.dart';
import 'package:techtac_electro/screens/root_screen.dart';
import 'package:techtac_electro/screens/loading_manager.dart';
import 'package:techtac_electro/models/user_model.dart';

import 'cart_widget.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = false;

  Future<String> fetchUserName() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (user != null) {
      UserModel? userModel = await userProvider.fetchUserInfo(); // Correctly await the Future
      if (userModel != null) {
        return userModel.userName; // Correctly access the userName property
      } else {
        throw Exception('User information is not available');
      }
    } else {
      throw Exception('User not logged in');
    }
  }



  Future<String?> selectPaymentMethod(BuildContext context, int totalAmount) async {
    return await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => PaymentBottomSheet(amount: totalAmount, currency: "USD"),
    );
  }

  Future<void> placeOrder(BuildContext context) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user == null) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final totalAmount = cartProvider.getTotal(productProvider: productProvider).toInt();
      final paymentMethod = await selectPaymentMethod(context, totalAmount);

      if (paymentMethod == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment method not selected")),
        );
        return;
      }

      final userName = await fetchUserName();

      for (var cartItem in cartProvider.getCartItems.values) {
        final productDetails = productProvider.findByProdId(cartItem.productId);

        if (productDetails != null) {
          await OrderService.placeOrder(
            productId: cartItem.productId,
            productTitle: productDetails.productTitle,
            userName: userName,
            price: double.parse(productDetails.productPrice) * cartItem.quantity,
            imageUrl: productDetails.productImage,
            quantity: cartItem.quantity,
            paymentMethod: paymentMethod,
          );
        }
      }

      await cartProvider.clearCartFromFirebase();
      cartProvider.clearLocalCart();
    } catch (e) {
      MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: e.toString(),
        fct: () {},
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return cartProvider.getCartItems.isEmpty
        ? Scaffold(
      body: EmptyBagWidget(
        imagePath: AssetsManager.shoppingBasket,
        title: "Your cart is empty",
        subtitle:
        'Looks like you didn\'t add anything yet to your cart \ngo ahead and start shopping now',
        buttonText: "Shop Now",
        function: () {
          Navigator.pushReplacementNamed(context, RootScreen.routeName);
        },
      ),
    )
        : Scaffold(
      appBar: AppBar(
        title: TitlesTextWidget(
            label: "Cart (${cartProvider.getCartItems.length})"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.shoppingCart),
        ),
        actions: [
          IconButton(
            onPressed: () {
              MyAppMethods.showErrorORWarningDialog(
                  isError: false,
                  context: context,
                  subtitle: "Remove items",
                  fct: () async {
                    await cartProvider.clearCartFromFirebase();
                  });
            },
            icon: const Icon(
              Icons.delete_forever_rounded,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: LoadingManager(
        isLoading: isLoading,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartProvider.getCartItems.length,
                itemBuilder: (context, index) {
                  return ChangeNotifierProvider.value(
                    value: cartProvider.getCartItems.values
                        .toList()
                        .reversed
                        .toList()[index],
                    child: const CartWidget(),
                  );
                },
              ),
            ),
            const SizedBox(
              height: kBottomNavigationBarHeight + 10,
            )
          ],
        ),
      ),
      bottomSheet: CartBottomCheckout(
        function: () async {
          await placeOrder(context);
        },
      ),
    );
  }
}

class CartBottomCheckout extends StatefulWidget {
  const CartBottomCheckout({super.key, required this.function});
  final Function function;

  @override
  State<CartBottomCheckout> createState() => _CartBottomCheckoutState();
}

class _CartBottomCheckoutState extends State<CartBottomCheckout> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final totalAmount = cartProvider.getTotal(productProvider: productProvider).toInt();
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const Border(
          top: BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      child: SizedBox(
        height: kBottomNavigationBarHeight + 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: ListView(
                  children: [
                    TitlesTextWidget(
                      fontSize: 17,
                      label: "Total (${cartProvider.getCartItems.length} products/${cartProvider.getQty()})",
                    ),
                    SubtitleTextWidget(
                      label: "$totalAmount\$",
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: !_isProcessing
                    ? () async {
                  setState(() {
                    _isProcessing = true;
                  });
                  await widget.function();
                  setState(() {
                    _isProcessing = false;
                  });
                }
                    : null,
                child: _isProcessing ? const CircularProgressIndicator() : const Text("Checkout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
