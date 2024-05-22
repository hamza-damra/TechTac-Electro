import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techtac_electro/screens/loading_manager.dart';
import 'package:techtac_electro/widgets/text_widget.dart';

import '../../provider/address_provider.dart';

class AddAddressScreen extends StatefulWidget {
  static const routeName = '/AddAddressScreen';
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
  final _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _streetController.text = widget.address!['street'] ?? '';
      _aptSuiteUnitController.text = widget.address!['aptSuiteUnit'] ?? '';
      _stateProvinceController.text = widget.address!['stateProvince'] ?? '';
      _cityController.text = widget.address!['city'] ?? '';
      _zipCodeController.text = widget.address!['zipCode'] ?? '';
      _phoneNumberController.text = widget.address!['phoneNumber'] ?? '';
    }
  }

  Future<void> _saveAddress(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final addressProvider = Provider.of<AddressProvider>(context, listen: false);

    final newAddress = {
      'street': _streetController.text,
      'aptSuiteUnit': _aptSuiteUnitController.text,
      'stateProvince': _stateProvinceController.text,
      'city': _cityController.text,
      'zipCode': _zipCodeController.text,
      'phoneNumber': _phoneNumberController.text,
    };

    await addressProvider.addOrUpdateAddress(newAddress, context: context);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _streetController.dispose();
    _aptSuiteUnitController.dispose();
    _stateProvinceController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const TitlesTextWidget(label: 'Add/Edit Address'),
      ),
      body: LoadingManager(
        isLoading: addressProvider.isLoading,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildTextFormField(
                  controller: _streetController,
                  label: 'Street',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the street';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                _buildTextFormField(
                  controller: _aptSuiteUnitController,
                  label: 'Apt/Suite/Unit',
                ),
                const SizedBox(height: 10),
                _buildTextFormField(
                  controller: _stateProvinceController,
                  label: 'State/Province',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the state or province';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                _buildTextFormField(
                  controller: _cityController,
                  label: 'City',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the city';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                _buildTextFormField(
                  controller: _zipCodeController,
                  label: 'Zip Code',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the zip code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                _buildTextFormField(
                  controller: _phoneNumberController,
                  label: 'Phone Number',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _saveAddress(context),
                  child: const Text('Save Address'),
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
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}
