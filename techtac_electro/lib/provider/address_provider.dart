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

  Future<void> addNewAddress(Map<String, dynamic> passedAddress, {required BuildContext context}) async {
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
        'addresses': FieldValue.arrayUnion([passedAddress]),
      });
      await fetchAddresses(context: context);
    } catch (error) {
      await MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "An error occurred: $error",
        fct: () {},
      );
    }
  }

  Future<void> updateAddress(Map<String, dynamic> passedAddress, {required BuildContext context}) async {
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
      List<Map<String, dynamic>> updatedAddresses = [];
      for (var address in _addresses) {
        if (address['id'] == passedAddress['id']) {
          updatedAddresses.add(passedAddress);
        } else {
          updatedAddresses.add(address);
        }
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'addresses': updatedAddresses,
      });

      await fetchAddresses(context: context);
    } catch (error) {
      await MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "An error occurred: $error",
        fct: () {},
      );
    }
  }


  Future<void> deleteAddress(Map<String, dynamic> passedAddress, {required BuildContext context}) async {
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
        'addresses': FieldValue.arrayRemove([passedAddress]),
      });
      await fetchAddresses(context: context);
    } catch (error) {
      await MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "An error occurred: $error",
        fct: () {},
      );
    }
  }
}
