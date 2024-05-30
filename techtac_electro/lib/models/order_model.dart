import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class OrdersModel with ChangeNotifier {
  final String orderId;
  final String userId;
  final String productId;
  final String productTitle;
  final String userName;
  final String price;
  final String imageUrl;
  final String quantity;
  final Timestamp orderDate;
  final String? paymentMethod;

  OrdersModel({
    required this.orderId,
    required this.userId,
    required this.productId,
    required this.productTitle,
    required this.userName,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.orderDate,
    this.paymentMethod,
  });

  factory OrdersModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrdersModel(
      orderId: data['orderId'],
      userId: data['userId'],
      productId: data['productId'],
      productTitle: data['productTitle'],
      userName: data['userName'],
      price: data['price'],
      imageUrl: data['imageUrl'],
      quantity: data['quantity'],
      orderDate: data['orderDate'],
      paymentMethod: data['paymentMethod'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'productId': productId,
      'productTitle': productTitle,
      'userName': userName,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'orderDate': orderDate,
      'paymentMethod': paymentMethod,
    };
  }
}
