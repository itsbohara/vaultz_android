import 'package:intl/intl.dart';

formateDate(String date) {
  var _date = DateTime.parse(date);
  return DateFormat.yMMMMEEEEd().format(_date);
}
