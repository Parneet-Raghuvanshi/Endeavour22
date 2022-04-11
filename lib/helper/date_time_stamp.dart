import 'package:intl/intl.dart';

class DateTimeStamp {
  int getDate() {
    final DateTime now = DateTime.now();
    String secOne = now.toString().substring(11).replaceAll(':', '');
    secOne = secOne.replaceAll('.', '').substring(0, 8);
    final DateFormat formatter = DateFormat('yyyyMMdd');
    final String formatted = formatter.format(now);
    String date = formatted + secOne;
    int datenum = int.parse(date);
    return datenum;
  }
}
