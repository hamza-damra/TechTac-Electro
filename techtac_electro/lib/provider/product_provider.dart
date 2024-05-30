import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:techtac_electro/models/product_model.dart';

import '../models/review_model.dart';

class ProductProvider with ChangeNotifier {
  final List<ProductModel> _products = [];

  List<ProductModel> get getProducts => _products;

  ProductModel? findByProdId(String productId) {
    return _products.firstWhereOrNull((element) => element.productId == productId);
  }

  // Method to fetch products from Firestore
  Future<List<ProductModel>> fetchProducts() async {
    try {
      final productDB = FirebaseFirestore.instance.collection("products");
      final productsSnapshot = await productDB.orderBy("createdAt", descending: false).get();

      _products.clear();
      for (var element in productsSnapshot.docs) {
        _products.insert(0, ProductModel.fromFirestore(element));
      }
      notifyListeners();
      return _products;
    } catch (error) {
      rethrow;
    }
  }

  // Stream to listen to real-time updates of products
  Stream<List<ProductModel>> fetchProductStream() {
    try {
      final productDB = FirebaseFirestore.instance.collection("products");
      return productDB.snapshots().map((snapshot) {
        _products.clear();
        for (var element in snapshot.docs) {
          _products.insert(0, ProductModel.fromFirestore(element));
        }
        return _products;
      });
    } catch (e) {
      rethrow;
    }
  }

  // Method to find products by category
  List<ProductModel> findByCategory({required String ctgName}) {
    return _products
        .where((element) => element.productCategory
        .toLowerCase()
        .contains(ctgName.toLowerCase()))
        .toList();
  }

  // Method to search products by a query
  List<ProductModel> searchQuery({
    required String searchText,
    required List<ProductModel> passedList
  }) {
    return passedList
        .where((element) => element.productTitle
        .toLowerCase()
        .contains(searchText.toLowerCase())).toList();
  }

  // Methods to handle reviews (optional based on your needs)
  Future<void> addReview(String productId, ReviewModel review) async {
    try {
      final reviewDoc = await FirebaseFirestore.instance
          .collection("products")
          .doc(productId)
          .collection('reviews')
          .add(review.toMap());
      review.reviewId = reviewDoc.id;
      await reviewDoc.update({'reviewId': review.reviewId});
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateReview(String productId, ReviewModel review) async {
    try {
      await FirebaseFirestore.instance
          .collection("products")
          .doc(productId)
          .collection('reviews')
          .doc(review.reviewId)
          .update(review.toMap());
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteReview(String productId, String reviewId) async {
    try {
      await FirebaseFirestore.instance
          .collection("products")
          .doc(productId)
          .collection('reviews')
          .doc(reviewId)
          .delete();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<ReviewModel>> fetchReviews(String productId) {
    return FirebaseFirestore.instance
        .collection("products")
        .doc(productId)
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc)).toList();
    });
  }

  Stream<List<ReviewModel>> fetchUserReview(String productId, String userId) {
    return FirebaseFirestore.instance
        .collection("products")
        .doc(productId)
        .collection('reviews')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc)).toList();
    });
  }
}
