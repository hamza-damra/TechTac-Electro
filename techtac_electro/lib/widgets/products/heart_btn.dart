import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:techtac_electro/provider/wishlist_provider.dart';
import 'package:techtac_electro/services/my_app_method.dart';

class HeartButtonWidget extends StatefulWidget {
  const HeartButtonWidget({
    super.key,
    this.size = 22,
    this.color = Colors.transparent,
    required this.productId,
  });
  final double size;
  final Color color;
  final String productId;

  @override
  State<HeartButtonWidget> createState() => _HeartButtonWidgetState();
}

class _HeartButtonWidgetState extends State<HeartButtonWidget> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.color,
      ),
      child: IconButton(
        style: IconButton.styleFrom(
          shape: const CircleBorder(),
        ),
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          try {
            if (wishlistProvider.isProductInWishlist(productId: widget.productId)) {
              await wishlistProvider.removeWishlistItemFromFirebase(
                wishlistId: wishlistProvider.getWishlistItems[widget.productId]!.id,
                productId: widget.productId,
              );
            } else {
              await wishlistProvider.addToWishlistFirebase(
                productId: widget.productId,
                context: context,
              );
            }
            await wishlistProvider.fetchWishlist();
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
        },
        icon: isLoading
            ? const CircularProgressIndicator()
            : Icon(
          wishlistProvider.isProductInWishlist(productId: widget.productId)
              ? IconlyBold.heart
              : IconlyLight.heart,
          size: widget.size,
          color: wishlistProvider.isProductInWishlist(productId: widget.productId)
              ? Colors.red
              : Colors.grey,
        ),
      ),
    );
  }
}
