import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'api_keys.dart';

abstract class PaymentManager {
  static Future<void> makePayment(int amountNis, Function(String) showSnackbar) async {
    try {
      int amountInShekels = (amountNis * 100);
      String clientSecret = await _getClientSecret(amountInShekels.toString());
      await _initializePaymentSheet(clientSecret);
      await Stripe.instance.presentPaymentSheet();
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        showSnackbar('Payment was cancelled');
      } else {
        showSnackbar('Error from Stripe: ${e.error.localizedMessage}');
      }
    } catch (error) {
      showSnackbar('An error occurred: ${error.toString()}');
    }
  }

  static Future<void> _initializePaymentSheet(String clientSecret) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: "Hamza",
      ),
    );
  }

  static Future<String> _getClientSecret(String amount) async {
    Dio dio = Dio();
    var response = await dio.post(
      'https://api.stripe.com/v1/payment_intents',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${ApiKeys.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      ),
      data: {
        'amount': amount,
        'currency': 'ILS',
      },
    );
    return response.data["client_secret"];
  }
}