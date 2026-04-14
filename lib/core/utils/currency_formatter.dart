import 'package:intl/intl.dart';

// TODO: Add live exchange rate API to complement the currency selection
// added on WelcomeScreen. Currently uses hardcoded rates from currencies.dart.

abstract final class CurrencyFormatter {
  /// Format [amount] with a given currency [symbol].
  static String format(double amount, {String symbol = '\$'}) {
    final f = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
    return f.format(amount);
  }

  static String formatCompact(double amount, {String symbol = '\$'}) {
    final f = NumberFormat.currency(symbol: symbol, decimalDigits: 0);
    return f.format(amount);
  }

  static String formatWeight(double value, {String unit = 'g'}) {
    final formatted = NumberFormat('#,##0.####').format(value);
    return '$formatted $unit';
  }
}
