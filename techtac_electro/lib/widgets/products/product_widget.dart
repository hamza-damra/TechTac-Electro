import 'dart:developer';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:techtac_electro/consts/app_constants.dart';
import 'package:techtac_electro/widgets/subtitle_text.dart';
import 'package:techtac_electro/widgets/text_widget.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({super.key});

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
        onTap: () {
          log("TODO navigate to the product details screen");
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: FancyShimmerImage(
                imageUrl: AppConstants.productImageUrl,
                width: double.infinity,
                height: size.height * 0.22,
              ),
            ),
            Row(
              children: [
                Flexible(
                  flex: 5,
                  child: TitlesTextWidget(label: "Title " * 10),
                ),
                Flexible(
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(IconlyLight.heart),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  flex: 3,
                  child: SubtitleTextWidget(label: "166.5\$"),
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
                        child: Icon(Icons.add_shopping_cart_rounded),
                      ),
                    ),
                  ),
                ),
              ],
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
