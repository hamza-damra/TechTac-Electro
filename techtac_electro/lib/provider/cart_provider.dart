import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:techtac_electro/models/cart_model.dart';
import 'package:techtac_electro/models/product_model.dart';
import 'package:techtac_electro/provider/product_provider.dart';
import 'package:techtac_electro/services/my_app_method.dart';
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};

  Map<String, CartModel> get getCartItems {
    return _cartItems;
  }
// Firebase

  final usersDB = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;
  Future<void> addToCartFirebase(
      {required String productId,
      required int qty,
      required BuildContext context}) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      MyAppMethods.showErrorORWarningDialog(
          context: context, subtitle: "No user found", fct: () {});
      return;
    }
    final uid = user.uid;
    final cartId = const Uuid().v4();
    try {
      usersDB.doc(uid).update({
        'userCart': FieldValue.arrayUnion([
          {
            "cartId": cartId,
            'productId': productId,
            'quantity': qty,
          }
        ])
      });
      Fluttertoast.showToast(msg: "Item has been added to cart");
    } catch (e) {
      rethrow;
    }
  }

  bool isProductInCart({required String productId}) {
    return _cartItems.containsKey(productId);
  }

  void addProductToCart({required String productId}) {
    _cartItems.putIfAbsent(
      productId,
      () => CartModel(
        cartId: const Uuid().v4(),
        productId: productId,
        quantity: 1,
      ),
    );
    notifyListeners();
  }

  void updateQuantity({required String productId, required int quantity}) {
    _cartItems.update(
      productId,
      (item) => CartModel(
        cartId: item.cartId,
        productId: productId,
        quantity: quantity,
      ),
    );
    notifyListeners();
  }

  double getTotal({required ProductProvider productProvider}) {
    double total = 0.0;
    _cartItems.forEach((key, value) {
      final ProductModel? getCurrProduct =
          productProvider.findByProdId(value.productId);
      if (getCurrProduct == null) {
        total += 0;
      } else {
        total += double.parse(getCurrProduct.productPrice) * value.quantity;
      }
    });
    return total;
  }

  int getQty() {
    int total = 0;
    _cartItems.forEach((key, value) {
      total += value.quantity;
    });
    return total;
  }

  void removeOneItem({required String productId}) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void clearLocalCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
