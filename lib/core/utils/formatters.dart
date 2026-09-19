/// Narx, sana va sonlarni o'zbekcha formatlash.
class Formatters {
  Formatters._();

  /// 1234567 -> "1 234 567 so'm"
  static String price(num value, {bool withCurrency = true}) {
    final s = value.round().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final left = s.length - i;
      buf.write(s[i]);
      if (left > 1 && left % 3 == 1) buf.write(' ');
    }
    return withCurrency ? "${buf.toString()} so'm" : buf.toString();
  }

  /// 12500 -> "12,5 ming"
  static String compact(int value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1).replaceAll('.', ',')} mln';
    if (value >= 1000) {
      final v = value / 1000;
      return '${v % 1 == 0 ? v.toInt() : v.toStringAsFixed(1).replaceAll('.', ',')} ming';
    }
    return value.toString();
  }

  static const _months = [
    'yanvar', 'fevral', 'mart', 'aprel', 'may', 'iyun',
    'iyul', 'avgust', 'sentabr', 'oktabr', 'noyabr', 'dekabr',
  ];

  /// 2026-09-19 -> "19 sentabr 2026"
  static String date(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

  /// "19 sentabr, 14:05"
  static String dateTime(DateTime d) =>
      '${d.day} ${_months[d.month - 1]}, ${_two(d.hour)}:${_two(d.minute)}';

  static String _two(int n) => n.toString().padLeft(2, '0');

  /// "+998901234567" -> "+998 90 123 45 67"
  static String phone(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 12) return raw;
    return '+${digits.substring(0, 3)} ${digits.substring(3, 5)} ${digits.substring(5, 8)} ${digits.substring(8, 10)} ${digits.substring(10)}';
  }

  static int discountPercent(num price, num? oldPrice) {
    if (oldPrice == null || oldPrice <= price) return 0;
    return (((oldPrice - price) / oldPrice) * 100).round();
  }
}
