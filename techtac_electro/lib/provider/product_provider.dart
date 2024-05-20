import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:techtac_electro/models/product_model.dart';
import 'package:techtac_electro/models/review_model.dart';

class ProductProvider with ChangeNotifier {
  final Logger _logger = Logger();
  final List<ProductModel> _products = [];

  List<ProductModel> get getProducts => _products;

  ProductModel? findByProdId(String productId) {
    _logger.d("Searching for product ID: $productId");
    return _products.firstWhereOrNull((element) => element.productId == productId);
  }

  List<ProductModel> findByCategory({required String ctgName}) {
    _logger.d("Searching for category: $ctgName");
    return _products
        .where((element) => element.productCategory
            .toLowerCase()
            .contains(ctgName.toLowerCase()))
        .toList();
  }

  List<ProductModel> searchQuery(
      {required String searchText, required List<ProductModel> passedList}) {
    _logger.d("Searching for query: $searchText");
    return passedList
        .where((element) => element.productTitle
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();
  }

  final productDB = FirebaseFirestore.instance.collection("products");

  Future<List<ProductModel>> fetchProducts() async {
    try {
      _logger.d("Fetching products from Firestore");
      await productDB.orderBy("createdAt", descending: false).get().then((productsSnapshot) {
        _products.clear();
        for (var element in productsSnapshot.docs) {
          _products.insert(0, ProductModel.fromFirestore(element));
        }
      });
      notifyListeners();
      return _products;
    } catch (error) {
      _logger.e("Error fetching products: $error");
      rethrow;
    }
  }

  Stream<List<ProductModel>> fetchProductStream() {
    try {
      _logger.d("Streaming products from Firestore");
      return productDB.snapshots().map((snapshot) {
        _products.clear();
        for (var element in snapshot.docs) {
          _products.insert(0, ProductModel.fromFirestore(element));
        }
        return _products;
      });
    } catch (e) {
      _logger.e("Error streaming products: $e");
      rethrow;
    }
  }

  Future<void> addReview(String productId, ReviewModel review) async {
    try {
      _logger.d("Adding review for product ID: $productId");
      final reviewDoc = await productDB
          .doc(productId)
          .collection('reviews')
          .add(review.toMap());
      review.reviewId = reviewDoc.id;
      await reviewDoc.update({'reviewId': review.reviewId});
      _logger.d("Review added with ID: ${review.reviewId}");
      notifyListeners();
    } catch (e) {
      _logger.e("Error adding review: $e");
      rethrow;
    }
  }

  Future<void> updateReview(String productId, ReviewModel review) async {
    try {
      _logger.d("Attempting to update review for product ID: $productId with review ID: ${review.reviewId}");
      _logger.d("Review data: ${review.toMap()}");
      await productDB
          .doc(productId)
          .collection('reviews')
          .doc(review.reviewId)
          .update(review.toMap());
      _logger.d("Successfully updated review with ID: ${review.reviewId}");
      notifyListeners();
    } catch (e) {
      _logger.e("Error updating review: $e");
      rethrow;
    }
  }

  Future<void> deleteReview(String productId, String reviewId) async {
    try {
      _logger.d("Deleting review with ID: $reviewId for product ID: $productId");
      await productDB
          .doc(productId)
          .collection('reviews')
          .doc(reviewId)
          .delete();
      _logger.d("Successfully deleted review with ID: $reviewId");
      notifyListeners();
    } catch (e) {
      _logger.e("Error deleting review: $e");
      rethrow;
    }
  }

  Stream<List<ReviewModel>> fetchReviews(String productId) {
    _logger.d("Fetching reviews for product ID: $productId");
    return productDB
        .doc(productId)
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc)).toList();
    });
  }

  Stream<List<ReviewModel>> fetchUserReview(String productId, String userId) {
    _logger.d("Fetching reviews for product ID: $productId by user ID: $userId");
    return productDB
        .doc(productId)
        .collection('reviews')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc)).toList();
    });
  }
}
