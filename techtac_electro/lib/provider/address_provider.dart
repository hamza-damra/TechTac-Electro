import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:techtac_electro/services/my_app_method.dart';

class AddressProvider with ChangeNotifier {
  bool _isLoading = true;
  List<Map<String, dynamic>> _addresses = [];

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get addresses => _addresses;

  Future<void> fetchAddresses({required BuildContext context}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        _addresses = List<Map<String, dynamic>>.from((snapshot.data() as Map<String, dynamic>)['addresses'] ?? []);
      }
    } catch (error) {
      await MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "An error occurred: $error",
        fct: () {},
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addOrUpdateAddress(Map<String, dynamic> address, {required BuildContext context}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      await MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "No user found",
        fct: () {},
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'addresses': FieldValue.arrayUnion([address]),
      });
      fetchAddresses(context: context);
    } catch (error) {
      await MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "An error occurred: $error",
        fct: () {},
      );
    }
  }

  Future<void> deleteAddress(Map<String, dynamic> address, {required BuildContext context}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      await MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "No user found",
        fct: () {},
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'addresses': FieldValue.arrayRemove([address]),
      });
      fetchAddresses(context: context);
    } catch (error) {
      await MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "An error occurred: $error",
        fct: () {},
      );
    }
  }
}
