import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/cart_provider.dart';
import '../../provider/product_provider.dart';
import '../../services/stripe_payment/payment_manager.dart';
import '../../widgets/subtitle_text.dart';
import '../../widgets/text_widget.dart';

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
                      label: "${totalAmount}",
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
                  try {
                    await PaymentManager.makePayment(totalAmount);
                  }catch(e)
                  {
                    if (kDebugMode) {
                      print("exception happened: $e");
                    }
                  }
                  finally {
                    setState(() {
                      _isProcessing = false;
                    });
                  }
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
