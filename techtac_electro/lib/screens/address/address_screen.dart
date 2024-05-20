import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:techtac_electro/screens/address/add_address_screen.dart';
import 'package:techtac_electro/screens/loading_manager.dart';
import 'package:techtac_electro/services/my_app_method.dart';
import 'package:techtac_electro/widgets/subtitle_text.dart';
import 'package:techtac_electro/widgets/text_widget.dart';

class AddressScreen extends StatefulWidget {
  static const routeName = '/AddressScreen';

  const AddressScreen({super.key});

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _addresses = [];

  @override
  void initState() {
    super.initState();
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          _addresses = List<Map<String, dynamic>>.from((snapshot.data() as Map<String, dynamic>)['addresses'] ?? []);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      await MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "An error occurred: $error",
        fct: () {},
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitlesTextWidget(label: 'Addresses'),
      ),
      body: LoadingManager(
        isLoading: _isLoading,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _addresses.isEmpty
              ? const Center(
                  child: TitlesTextWidget(label: 'No addresses found.'),
                )
              : ListView.builder(
                  itemCount: _addresses.length,
                  itemBuilder: (context, index) {
                    final address = _addresses[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SubtitleTextWidget(label: 'Street: ${address['street']}'),
                            SubtitleTextWidget(label: 'Apt/Suite/Unit: ${address['aptSuiteUnit']}'),
                            SubtitleTextWidget(label: 'State/Province: ${address['stateProvince']}'),
                            SubtitleTextWidget(label: 'City: ${address['city']}'),
                            SubtitleTextWidget(label: 'Zip Code: ${address['zipCode']}'),
                            SubtitleTextWidget(label: 'Phone Number: ${address['phoneNumber']}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddAddressScreen(address: address),
                              ),
                            ).then((_) => fetchAddresses());
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddAddressScreen(),
            ),
          ).then((_) => fetchAddresses());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
