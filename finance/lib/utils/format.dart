import 'package:intl/intl.dart';

abstract class Format {
  static String currencyPtBr(double value) {
    return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$ ').format(value);
  }

  static String currencyPtBrToUs(String value) {
    return value
        .replaceAll(RegExp(r'R\$ '), '')
        .replaceAll('.', '')
        .replaceAll(',', '.');
  }

  static String datePtBr(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String datePtBrToUs(String date) {
    final parts = date.split('/');
    if (parts.length == 3) {
      return '${parts[2]}-${parts[1]}-${parts[0]}';
    }
    return date;
  }
}
