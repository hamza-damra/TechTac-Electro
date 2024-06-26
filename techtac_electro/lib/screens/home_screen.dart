import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techtac_electro/consts/app_constants.dart';
import 'package:techtac_electro/provider/product_provider.dart';
import 'package:techtac_electro/screens/cart/ctg_rounded_widget.dart';
import 'package:techtac_electro/widgets/products/latest_arrival.dart';
import 'package:techtac_electro/widgets/text_widget.dart';
import '../services/assets_manager.dart';
import '../widgets/app_name_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const AppNameTextWidget(fontSize: 20),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.shoppingCart),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.24,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      final product = productProvider.getProducts[index];
                      return Image.network(
                        product.productImage,
                        fit: BoxFit.fill,
                      );
                    },
                    autoplay: true,
                    itemCount: productProvider.getProducts.length <= 10
                        ? productProvider.getProducts.length
                        : 10,
                    pagination: const SwiperPagination(
                      alignment: Alignment.bottomCenter,
                      builder: DotSwiperPaginationBuilder(
                        color: Colors.white,
                        activeColor: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Visibility(
                visible: productProvider.getProducts.isNotEmpty,
                child: const TitlesTextWidget(
                  label: "Latest arrival",
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible: productProvider.getProducts.isNotEmpty,
                child: SizedBox(
                  height: size.height * 0.2,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: productProvider.getProducts.length < 10
                        ? productProvider.getProducts.length
                        : 10,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: productProvider.getProducts[index],
                        child: LatestArrivalProductsWidget(
                          productId: productProvider.getProducts[index].productId,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              const TitlesTextWidget(
                label: "Categories",
                fontSize: 22,
              ),
              const SizedBox(
                height: 18,
              ),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                children: List.generate(AppConstants.categoriesList.length, (index) {
                  return CategoryRoundedWidget(
                    image: AppConstants.categoriesList[index].image,
                    name: AppConstants.categoriesList[index].name,
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
