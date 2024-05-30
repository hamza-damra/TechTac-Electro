import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class OrderService {
  static Future<void> placeOrder({
    required String productId,
    required String productTitle,
    required String userName,
    required double price,
    required String imageUrl,
    required int quantity,
    required String paymentMethod,
  }) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    final String orderId = const Uuid().v4();
    final orderData = {
      'orderId': orderId,
      'userId': user.uid,
      'productId': productId,
      'productTitle': productTitle,
      'userName': userName,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'orderDate': Timestamp.now(),
      'paymentMethod': paymentMethod,
    };
    await FirebaseFirestore.instance
        .collection('ordersAdvanced')
        .doc(orderId)
        .set(orderData);
  }
}
