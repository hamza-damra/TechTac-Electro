import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:techtac_electro/models/order.dart';

class OrdersProvider with ChangeNotifier {
  final List<OrdersModelAdvanced> orders = [];

  List<OrdersModelAdvanced> get getOrders => orders;

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
        orders.insert(
          0,
          OrdersModelAdvanced(
            orderId: element.get('orderId'),
            productId: element.get('productId'),
            userId: element.get('userId'),
            price: element.get('price').toString(),
            productTitle: element.get('productTitle').toString(),
            quantity: element.get('quantity').toString(),
            imageUrl: element.get('imageUrl'),
            userName: element.get('userName'),
            orderDate: element.get('orderDate'),
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

  void clearState() {
    orders.clear();
    notifyListeners();
  }
}
