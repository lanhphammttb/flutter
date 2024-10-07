String convertSecondsToHHMMSS(String secondsString) {
  if (secondsString == null || secondsString.isEmpty) {
    return "00:00:00";
  }

  int seconds = int.parse(secondsString);
  int hours = seconds ~/ 3600;
  int minutes = (seconds % 3600) ~/ 60;
  int remainingSeconds = seconds % 60;

  return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
}
