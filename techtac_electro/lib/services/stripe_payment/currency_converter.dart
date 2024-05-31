class CurrencyConverter {
  static const double conversionRate = 3.7;

  static double convertNisToUsd(double amount) {
    return amount / conversionRate;
  }
}
