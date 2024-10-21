import 'package:intl/intl.dart';
import 'package:nttcs/core/constants/constants.dart';

String convertSecondsToHHMMSS(String secondsString) {
  if (secondsString.isEmpty) {
    return "00:00:00";
  }

  int seconds = int.parse(secondsString);
  int hours = seconds ~/ 3600;
  int minutes = (seconds % 3600) ~/ 60;
  int remainingSeconds = seconds % 60;

  return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
}

String convertDateFormat(String dateString) {
  final DateFormat targetFormat = DateFormat(Constants.formatDate2);
  final List<DateFormat> sourceFormats = [
    DateFormat(Constants.formatDate), // dd-MM-yyyy
    DateFormat(Constants.formatDate2), // yyyy-MM-dd
  ];

  for (var format in sourceFormats) {
    try {
      final date = format.parseStrict(dateString);
      return targetFormat.format(date);
    } catch (e) {
      continue;
    }
  }

  throw ArgumentError('Ngày không hợp lệ: $dateString');
}
