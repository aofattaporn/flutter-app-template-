import 'package:intl/intl.dart';

/// Utility class for currency formatting
class CurrencyUtils {
  CurrencyUtils._();

  /// Default currency formatter for Thai Baht
  static final NumberFormat _thaiFormatter = NumberFormat.currency(
    locale: 'th_TH',
    symbol: '฿',
    decimalDigits: 2,
  );

  /// Format amount as Thai Baht currency string
  /// 
  /// Example: 1000.50 -> ฿1,000.50
  static String formatCurrency(double amount) {
    return _thaiFormatter.format(amount);
  }

  /// Format amount with custom locale and symbol
  static String formatCurrencyCustom(
    double amount, {
    String locale = 'th_TH',
    String symbol = '฿',
    int decimalDigits = 2,
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }
}
