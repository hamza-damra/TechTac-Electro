import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:techtac_electro/models/wishlist_model.dart';
import 'package:techtac_electro/services/my_app_method.dart';
import 'package:uuid/uuid.dart';

class WishlistProvider with ChangeNotifier {
  final Map<String, WishlistModel> _wishlistItems = {};

  Map<String, WishlistModel> get getWishlistItems {
    return _wishlistItems;
  }

  bool isProductInWishlist({required String productId}) {
    return _wishlistItems.containsKey(productId);
  }

  final usersDB = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;

  Future<void> addToWishlistFirebase({
    required String productId,
    required BuildContext context,
  }) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "No user found",
        fct: () {},
      );
      return;
    }
    final uid = user.uid;
    final wishlistId = const Uuid().v4();
    try {
      await usersDB.doc(uid).update({
        'userWish': FieldValue.arrayUnion([
          {
            "wishlistId": wishlistId,
            'productId': productId,
          }
        ])
      });
      showToast(
        'Item has been added to Wishlist',
        context: context,
        animation: StyledToastAnimation.scale,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        borderRadius: BorderRadius.circular(8.0),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchWishlist() async {
    User? user = _auth.currentUser;
    if (user == null) {
      log("The function has been called and the user is null");
      _wishlistItems.clear();
      return;
    }
    try {
      final userDoc = await usersDB.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey("userWish")) {
        return;
      }
      final length = userDoc.get("userWish").length;
      for (int index = 0; index < length; index++) {
        _wishlistItems.putIfAbsent(
          userDoc.get('userWish')[index]['productId'],
              () => WishlistModel(
            id: userDoc.get('userWish')[index]['wishlistId'],
            productId: userDoc.get('userWish')[index]['productId'],
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeWishlistItemFromFirebase({
    required String wishlistId,
    required String productId,
  }) async {
    User? user = _auth.currentUser;
    try {
      await usersDB.doc(user!.uid).update({
        "userWish": FieldValue.arrayRemove([
          {
            'wishlistId': wishlistId,
            'productId': productId,
          }
        ])
      });
      _wishlistItems.remove(productId);
      await fetchWishlist();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> clearWishlistFromFirebase() async {
    User? user = _auth.currentUser;
    try {
      await usersDB.doc(user!.uid).update({"userWish": []});
      _wishlistItems.clear();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  void clearLocalWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }

  void addOrRemoveFromWishlist({required String productId}) {
    if (_wishlistItems.containsKey(productId)) {
      _wishlistItems.remove(productId);
    } else {
      _wishlistItems.putIfAbsent(
        productId,
            () => WishlistModel(
          id: const Uuid().v4(),
          productId: productId,
        ),
      );
    }

    notifyListeners();
  }

  void clearWishlistItems() {
    _wishlistItems.clear();
    notifyListeners();
  }
}
