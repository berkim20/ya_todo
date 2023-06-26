import 'package:intl/intl.dart';

/// Extension on DateTime
extension DateFormating on DateTime? {
  /// format date in to dd MMMM yyyy  string
  String getFormattedTime(String locale) {
    if (this == null) return '';
    return DateFormat('dd MMMM yyyy', locale).format(this!);
  }

  // DateTime returnFormattedTime(String date) {
  //   return DateTime.parse(date, 'en').format('dd MMMM yyyy');
  // }

  /// format date in to dd MMMM  string
  String getShortFormat(String locale) {
    if (this == null) return '';
    return DateFormat('dd MMMM', locale).format(this!);
  }
}
