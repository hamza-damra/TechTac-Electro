import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String? reviewId;
  String productId;
  String userId;
  String username;
  String userProfileImage;
  String reviewText;
  double rating;
  Timestamp createdAt;

  ReviewModel({
    this.reviewId,
    required this.productId,
    required this.userId,
    required this.username,
    required this.userProfileImage,
    required this.reviewText,
    required this.rating,
    required this.createdAt,
  });

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      reviewId: doc.id,
      productId: data['productId'],
      userId: data['userId'],
      username: data['username'],
      userProfileImage: data['userProfileImage'],
      reviewText: data['reviewText'],
      rating: (data['rating'] as num).toDouble(),
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reviewId': reviewId,
      'productId': productId,
      'userId': userId,
      'username': username,
      'userProfileImage': userProfileImage,
      'reviewText': reviewText,
      'rating': rating,
      'createdAt': createdAt,
    };
  }
}
