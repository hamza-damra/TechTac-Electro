import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techtac_electro/screens/address/add_address_screen.dart';
import 'package:techtac_electro/widgets/subtitle_text.dart';
import 'package:techtac_electro/widgets/text_widget.dart';

import '../../provider/address_provider.dart';
import '../loading_manager.dart';

class AddressScreen extends StatefulWidget {
  static const routeName = '/AddressScreen';

  const AddressScreen({super.key});

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddressProvider>(context, listen: false).fetchAddresses(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const TitlesTextWidget(label: 'Addresses'),
      ),
      body: LoadingManager(
        isLoading: addressProvider.isLoading,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: addressProvider.addresses.isEmpty
              ? const Center(
            child: TitlesTextWidget(label: 'No addresses found.'),
          )
              : ListView.builder(
            itemCount: addressProvider.addresses.length,
            itemBuilder: (context, index) {
              final address = addressProvider.addresses[index];
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddAddressScreen(passedAddress: address),
                            ),
                          ).then((_) => addressProvider.fetchAddresses(context: context));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await addressProvider.deleteAddress(address, context: context);
                        },
                      ),
                    ],
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
          ).then((_) => addressProvider.fetchAddresses(context: context));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
