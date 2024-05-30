import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/order_model.dart';

class OrdersProvider with ChangeNotifier {
  final List<OrdersModel> orders = [];

  List<OrdersModel> get getOrders => orders;

  Future<void> fetchOrder() async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      if (kDebugMode) {
        print("User is null");
      }
      return;
    }
    var uid = user.uid;
    try {
      if (kDebugMode) {
        print("Fetching orders for user: $uid");
      }
      final orderSnapshot = await FirebaseFirestore.instance
          .collection("ordersAdvanced")
          .where("userId", isEqualTo: uid)
          .get();

      orders.clear();
      for (var element in orderSnapshot.docs) {
        final data = element.data();
        orders.insert(
          0,
          OrdersModel(
            orderId: data['orderId'],
            productId: data['productId'],
            userId: data['userId'],
            price: data['price'].toString(),
            productTitle: data['productTitle'].toString(),
            quantity: data['quantity'].toString(),
            imageUrl: data['imageUrl'],
            userName: data['userName'],
            orderDate: data['orderDate'],
            paymentMethod: data.containsKey('paymentMethod') ? data['paymentMethod'] : null, // Handle missing paymentMethod
          ),
        );
      }
      notifyListeners();
      if (kDebugMode) {
        print("Orders fetched successfully");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching orders: $e");
      }
      rethrow;
    }
  }

  void clearOrders() {
    orders.clear();
    notifyListeners();
  }
}
