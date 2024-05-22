import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:techtac_electro/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? userModel;

  UserModel? get getUserModel => userModel;

  Future<UserModel?> fetchUserInfo() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      return null;
    }
    var uid = user.uid;
    try {
      final userDoc = await FirebaseFirestore.instance.collection("users").doc(uid).get();
      final userDocDict = userDoc.data()!;
      userModel = UserModel(
        userId: userDocDict["userId"],
        userName: userDocDict["userName"],
        userImage: userDocDict["userImage"],
        userEmail: userDocDict['userEmail'],
        userCart: userDocDict.containsKey("userCart") ? userDocDict["userCart"] : [],
        userWish: userDocDict.containsKey("userWish") ? userDocDict["userWish"] : [],
        createdAt: userDocDict['createdAt'],
      );
      notifyListeners();
      return userModel;
    } catch (error) {
      throw error.toString();
    }
  }
}
