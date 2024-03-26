import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:techtac_electro/consts/app_constants.dart';
import 'package:techtac_electro/screens/inner_screens/product_details.dart';
import 'package:techtac_electro/widgets/products/heart_btn.dart';
import 'package:techtac_electro/widgets/subtitle_text.dart';
import 'package:techtac_electro/widgets/text_widget.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    super.key,
    this.image,
    this.title,
    this.price,
  });
  final String? image, title, price;

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
        onTap: () async {
          await Navigator.pushNamed(context, ProductDetails.routName);
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: FancyShimmerImage(
                imageUrl: widget.image ?? AppConstants.productImageUrl,
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
                    label: widget.title ?? "Title " * 10,
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
                        label: "${widget.price}" ?? "166.5\$"),
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
