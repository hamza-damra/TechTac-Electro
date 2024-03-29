import 'package:flutter/material.dart';
import 'package:techtac_electro/models/cart_model.dart';
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};
  Map<String, CartModel> get getCartItems {
    return _cartItems;
  }

  bool isProductInCard({required String productId}) {
    return _cartItems.containsKey(productId);
  }

  void addProductsToCart({required String productId}) {
    _cartItems.putIfAbsent(
        productId, //productId is key and key must be const.
        () => CartModel(
              cartID: const Uuid().v4(),
              productId: productId,
              quantity: 1,
            ));
    notifyListeners();
  }
}
