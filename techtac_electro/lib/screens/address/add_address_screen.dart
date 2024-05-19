import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:techtac_electro/consts/my_validators.dart';
import 'package:techtac_electro/screens/loading_manager.dart';
import 'package:techtac_electro/services/my_app_method.dart';
import 'package:techtac_electro/widgets/text_widget.dart';

class AddAddressScreen extends StatefulWidget {
  static const routName = '/AddAddressScreen';
  final Map<String, dynamic>? address;

  const AddAddressScreen({super.key, this.address});

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _aptSuiteUnitController = TextEditingController();
  final _stateProvinceController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _streetController.text = widget.address!['street'] ?? '';
      _aptSuiteUnitController.text = widget.address!['aptSuiteUnit'] ?? '';
      _stateProvinceController.text = widget.address!['stateProvince'] ?? '';
      _cityController.text = widget.address!['city'] ?? '';
      _zipCodeController.text = widget.address!['zipCode'] ?? '';
      _phoneController.text = widget.address!['phoneNumber'] ?? '';
    }
  }

  @override
  void dispose() {
    _streetController.dispose();
    _aptSuiteUnitController.dispose();
    _stateProvinceController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    setState(() {
      _isLoading = true;
    });

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      DocumentSnapshot userSnapshot = await userRef.get();
      List<Map<String, dynamic>> addresses = userSnapshot.exists ? List<Map<String, dynamic>>.from((userSnapshot.data() as Map<String, dynamic>)['addresses'] ?? []) : [];

      if (widget.address != null) {
        int index = addresses.indexWhere((address) => address['street'] == widget.address!['street']);
        if (index != -1) {
          addresses[index] = {
            'street': _streetController.text,
            'aptSuiteUnit': _aptSuiteUnitController.text,
            'stateProvince': _stateProvinceController.text,
            'city': _cityController.text,
            'zipCode': _zipCodeController.text,
            'phoneNumber': _phoneController.text,
          };
        }
      } else {
        addresses.add({
          'street': _streetController.text,
          'aptSuiteUnit': _aptSuiteUnitController.text,
          'stateProvince': _stateProvinceController.text,
          'city': _cityController.text,
          'zipCode': _zipCodeController.text,
          'phoneNumber': _phoneController.text,
        });
      }

      await userRef.update({
        'addresses': addresses,
      });

      if (!mounted) return;
      Navigator.pop(context);
    } catch (error) {
      await MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "An error occurred: $error",
        fct: () {},
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitlesTextWidget(label: 'Add/Edit Address'),
      ),
      body: LoadingManager(
        isLoading: _isLoading,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildTextFormField(
                          controller: _streetController,
                          label: 'Street',
                          validator: MyValidators.addressValidator,
                        ),
                        const SizedBox(height: 10),
                        _buildTextFormField(
                          controller: _aptSuiteUnitController,
                          label: 'Apt/Suite/Unit (optional)',
                        ),
                        const SizedBox(height: 10),
                        _buildTextFormField(
                          controller: _stateProvinceController,
                          label: 'State/Province',
                          validator: MyValidators.addressValidator,
                        ),
                        const SizedBox(height: 10),
                        _buildTextFormField(
                          controller: _cityController,
                          label: 'City',
                          validator: MyValidators.cityValidator,
                        ),
                        const SizedBox(height: 10),
                        _buildTextFormField(
                          controller: _zipCodeController,
                          label: 'Zip Code',
                          validator: MyValidators.zipCodeValidator,
                        ),
                        const SizedBox(height: 10),
                        _buildTextFormField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          validator: MyValidators.phoneValidator,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveAddress,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Address'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
      validator: validator,
    );
  }
}
