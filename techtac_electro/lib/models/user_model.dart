import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String userName;
  final String userImage;
  final String userEmail;
  final List<dynamic> userCart;
  final List<dynamic> userWish;
  final Timestamp createdAt;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.userEmail,
    required this.userCart,
    required this.userWish,
    required this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      userId: data['userId'],
      userName: data['userName'],
      userImage: data['userImage'],
      userEmail: data['userEmail'],
      userCart: data['userCart'] ?? [],
      userWish: data['userWish'] ?? [],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'userEmail': userEmail,
      'userCart': userCart,
      'userWish': userWish,
      'createdAt': createdAt,
    };
  }
}
