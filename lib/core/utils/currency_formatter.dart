import 'package:intl/intl.dart';

// TODO: Add currency selection dropdown to WelcomeScreen. Default CAD.
// Store selected currency in ZakatCalculationState. Apply currency symbol as
// prefix to all monetary inputs. Convert nisab USD thresholds to selected
// currency via exchange rate API. Consider a Settings screen if other global
// preferences are added.
abstract final class CurrencyFormatter {
  static final _formatter = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static final _compact = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 0,
  );

  static String format(double amount) => _formatter.format(amount);
  static String formatCompact(double amount) => _compact.format(amount);
  static String formatWeight(double grams) =>
      '${NumberFormat('#,##0.##').format(grams)}g';
}
