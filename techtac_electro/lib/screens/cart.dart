import 'package:flutter/material.dart';
import 'package:techtac_electro/services/assets_manager.dart';
import 'package:techtac_electro/widgets/empty_bag.dart';
import 'package:techtac_electro/widgets/subtitle_text.dart';
import 'package:techtac_electro/widgets/text_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EmptyBagWidget(
        imagePath: AssetsManager.shoppingBasket,
        title: "Your card is empty",
        subtitle:
            "Looks like you didn't add anything yet to your card \n go ahead and start shopping now",
        buttonText: "Shop Now",
      ),
    );
  }
}
