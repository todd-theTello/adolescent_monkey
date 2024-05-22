import 'package:intl/intl.dart';

/// extensions on numbers
extension Number on num? {
  String get currency => NumberFormat.currency(symbol: '').format(this);

  /// converts an integer to a duration format HH:MM
  String get toHHMM {
    if (this! < 0) {
      return '00:00'; // Return a default value or handle invalid input as needed.
    }

    final hours = this! ~/ 60;
    final remainingMinutes = (this! as int) % 60;

    final hoursStr = hours.toString();
    final minutesStr = remainingMinutes.toString().padLeft(2, '0');
    if (this! < 60) {
      return '$minutesStr min';
    }

    if (this == 60) {
      return '1hr';
    }
    return '${hoursStr}hr ${minutesStr}min';
  }

  /// converts an integer second to a duration format HH:MM:SS or MM:SS
  String get toHHMMSS {
    // Calculate hours, minutes, and remaining seconds
    final hours = (this! ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((this! % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = ((this! as int) % 60).toString().padLeft(2, '0');

    // Format the time as hh:mm:ss or mm:ss
    if ((this! ~/ 3600) > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }
}
