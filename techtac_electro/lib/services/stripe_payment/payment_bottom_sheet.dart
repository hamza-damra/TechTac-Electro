import 'package:flutter/material.dart';
import 'package:techtac_electro/services/stripe_payment/payment_manager.dart';

class PaymentBottomSheet extends StatelessWidget {
  final int amount;

  const PaymentBottomSheet({Key? key, required this.amount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select a payment method',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('Stripe'),
            subtitle: const Text('Pay with Stripe'),
            onTap: () async {
              try {
                await PaymentManager.makePayment(amount);
                Navigator.of(context).pop('Stripe');
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Payment failed: $error")),
                );
                Navigator.of(context).pop(null);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_shipping),
            title: const Text('Payment on Delivery'),
            subtitle: const Text('Pay when you receive the product'),
            onTap: () {
              Navigator.of(context).pop('Payment on Delivery');
            },
          ),
        ],
      ),
    );
  }
}
