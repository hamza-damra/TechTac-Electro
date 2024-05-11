import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techtac_electro/provider/cart_provider.dart';
import 'package:techtac_electro/provider/product_provider.dart';
import 'package:techtac_electro/provider/viewed_prod_provider.dart';
import 'package:techtac_electro/services/my_app_method.dart';
import 'package:techtac_electro/widgets/subtitle_text.dart';
import '../../models/product_model.dart';
import '../../screens/inner_screens/product_details.dart';
import 'heart_btn.dart';

class LatestArrivalProductsWidget extends StatelessWidget {
  const LatestArrivalProductsWidget({super.key, required this.productId});
  final String productId;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final productsModel = Provider.of<ProductModel>(context);
    final viewedProvider = Provider.of<ViewedProdProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findByProdId(productId);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          viewedProvider.addProductToHistory(
              productId: productsModel.productId);
          await Navigator.pushNamed(
            context,
            ProductDetails.routName,
            arguments: productsModel.productId,
          );
        },
        child: SizedBox(
          width: size.width * 0.45,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FancyShimmerImage(
                    imageUrl: productsModel.productImage,
                    width: size.width * 0.28,
                    height: size.width * 0.28,
                  ),
                ),
              ),
              const SizedBox(
                width: 7,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productsModel.productTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          HeartButtonWidget(productId: productsModel.productId),
                          IconButton(
                            onPressed: () async {
                              if (cartProvider.isProductInCart(
                                  productId: getCurrProduct.productId)) {
                                return;
                              }

                              try {
                                await cartProvider.addToCartFirebase(
                                    productId: getCurrProduct.productId,
                                    qty: 1,
                                    context: context);
                              } catch (error) {
                                MyAppMethods.showErrorORWarningDialog(
                                    // ignore: use_build_context_synchronously
                                    context: context,
                                    subtitle: error.toString(),
                                    fct: () {});
                              }
                              cartProvider.addProductToCart(
                                  productId: getCurrProduct.productId);
                            },
                            icon: Icon(
                              cartProvider.isProductInCart(
                                      productId: getCurrProduct!.productId)
                                  ? Icons.check
                                  : Icons.add_shopping_cart_rounded,
                              size: 20,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FittedBox(
                      child: SubtitleTextWidget(
                        label: "${productsModel.productPrice}\$",
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
