import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techtac_electro/provider/cart_provider.dart';
import 'package:techtac_electro/provider/product_provider.dart';
import 'package:techtac_electro/provider/viewed_prod_provider.dart';
import 'package:techtac_electro/screens/inner_screens/product_details.dart';
import 'package:techtac_electro/services/my_app_method.dart';
import 'package:techtac_electro/widgets/products/heart_btn.dart';
import 'package:techtac_electro/widgets/subtitle_text.dart';
import 'package:techtac_electro/widgets/text_widget.dart';

import '../../provider/user_provider.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    super.key,
    required this.productId,
  });

  final String productId;
  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findByProdId(widget.productId);
    final cartProvider = Provider.of<CartProvider>(context);
    final viewedProvider = Provider.of<ViewedProdProvider>(context);
    Size size = MediaQuery.of(context).size;

    if (getCurrProduct == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
        onTap: () async {
          viewedProvider.addProductToHistory(productId: getCurrProduct.productId);
          await Navigator.pushNamed(
            context,
            ProductDetails.routeName,
            arguments: getCurrProduct.productId,
          );
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: FancyShimmerImage(
                imageUrl: getCurrProduct.productImage,
                width: double.infinity,
                height: size.height * 0.22,
              ),
            ),
            const SizedBox(height: 15.0),
            Row(
              children: [
                Flexible(
                  flex: 5,
                  child: TitlesTextWidget(
                    label: getCurrProduct.productTitle,
                    maxLines: 2,
                    fontSize: 18,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: HeartButtonWidget(productId: getCurrProduct.productId),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: SubtitleTextWidget(
                      label: "${getCurrProduct.productPrice}\₪",
                    ),
                  ),
                  Flexible(
                    child: Material(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.lightBlue,
                      child: InkWell(
                        splashColor: Colors.red,
                        borderRadius: BorderRadius.circular(16.0),
                        onTap: () async {
                          final userProvider = Provider.of<UserProvider>(context, listen: false);
                          final user = await userProvider.fetchUserInfo();

                          if (user == null) {
                            // Display a message or navigate to the login screen
                            MyAppMethods.showErrorORWarningDialog(
                              context: context,
                              subtitle: 'Please log in to add items to the cart.',
                              fct: () {},
                            );
                            return;
                          }

                          if (cartProvider.isProductInCart(productId: getCurrProduct.productId)) {
                            return;
                          }

                          try {
                            await cartProvider.addToCartFirebase(
                              productId: getCurrProduct.productId,
                              qty: 1,
                              context: context,
                            );
                          } catch (error) {
                            MyAppMethods.showErrorORWarningDialog(
                              context: context,
                              subtitle: error.toString(),
                              fct: () {},
                            );
                          }
                          cartProvider.addProductToCart(productId: getCurrProduct.productId);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            cartProvider.isProductInCart(productId: getCurrProduct.productId)
                                ? Icons.check
                                : Icons.add_shopping_cart_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
