import 'package:flutter/material.dart';

class CartModel with ChangeNotifier {
  final String cartID, productId;
  final int quantity;

  CartModel({
    required this.cartID,
    required this.productId,
    required this.quantity,
  });
}
