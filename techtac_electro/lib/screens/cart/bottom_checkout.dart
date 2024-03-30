import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techtac_electro/provider/cart_provider.dart';
import 'package:techtac_electro/provider/product_provider.dart';
import 'package:techtac_electro/provider/product_provider.dart';
import 'package:techtac_electro/provider/product_provider.dart';
import 'package:techtac_electro/widgets/subtitle_text.dart';
import 'package:techtac_electro/widgets/text_widget.dart';

class CartBottomCheckout extends StatelessWidget {
  const CartBottomCheckout({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
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
                        label:
                            "Total (${cartProvider.getCartItems.length} products/${cartProvider.getQty()})"),
                    SubtitleTextWidget(
                      label:
                          "${cartProvider.getTotal(productProvider: productProvider)}\$",
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Checkout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
