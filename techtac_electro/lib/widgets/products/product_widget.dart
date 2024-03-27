import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techtac_electro/consts/app_constants.dart';
import 'package:techtac_electro/models/product_model.dart';
import 'package:techtac_electro/provider/product_provider.dart';
import 'package:techtac_electro/screens/inner_screens/product_details.dart';
import 'package:techtac_electro/widgets/products/heart_btn.dart';
import 'package:techtac_electro/widgets/subtitle_text.dart';
import 'package:techtac_electro/widgets/text_widget.dart';

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
    //final productModelProvider = Provider.of<ProductModel>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findByProdId(widget.productId);
    Size size = MediaQuery.of(context).size;
    return getCurrProduct == null
        ? SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(3.0),
            child: GestureDetector(
              onTap: () async {
                await Navigator.pushNamed(
                  context,
                  ProductDetails.routName,
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
                  const SizedBox(
                    height: 15,
                  ),
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
                      const Flexible(
                        flex: 2,
                        child: HeartButtonWidget(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 3,
                          child: SubtitleTextWidget(
                            label: "${getCurrProduct.productPrice}\$",
                          ),
                        ),
                        Flexible(
                          child: Material(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Colors.lightBlue,
                            child: InkWell(
                              splashColor: Colors.red,
                              borderRadius: BorderRadius.circular(16.0),
                              onTap: () {},
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.add_shopping_cart_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          //change
                          width: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
  }
}
